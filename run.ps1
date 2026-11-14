param(
    [ValidateRange(1024,65535)][int]$Port = 8081,
    [string]$JavaHome = $env:JAVA_HOME,
    [string]$MavenHome = $env:MAVEN_HOME,
    [switch]$Build,
    [switch]$Test
)
$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $PSScriptRoot
if (-not $Build -and -not $Test) {
    $httpResponse = $null
    $reader = $null
    $alreadyRunning = $false
    $runningDatabase = $null
    $expectedDatabase = if ($env:GARAMAN_DB_URL -like 'jdbc:h2:*') { 'h2' } else { 'mysql' }
    try {
        $request = [System.Net.HttpWebRequest]::Create("http://127.0.0.1:$Port/home")
        $request.Proxy = $null
        $request.Timeout = 3000
        $request.ReadWriteTimeout = 3000
        $request.AllowAutoRedirect = $false
        $httpResponse = $request.GetResponse()
        $runningDatabase = $httpResponse.Headers['X-GaraMan-Database']
        $reader = [System.IO.StreamReader]::new($httpResponse.GetResponseStream())
        $html = $reader.ReadToEnd()
        $alreadyRunning = $httpResponse.StatusCode -eq 200 -and
            $html -match '<title>[^<]*\| GaraMan</title>' -and
            $html.Contains('/assets/css/style.css')
    }
    catch { $alreadyRunning = $false }
    finally {
        if ($reader) { $reader.Dispose() }
        if ($httpResponse) { $httpResponse.Dispose() }
    }
    if ($alreadyRunning) {
        if ($runningDatabase -ne $expectedDatabase) {
            throw "GaraMan tren cong $Port dang dung CSDL khac hoac phien ban cu. Dung cua so may chu cu bang Ctrl+C, roi chay lai run.cmd."
        }
        Write-Host "GaraMan da dang chay: http://localhost:$Port/home"
        Write-Host "CSDL: $runningDatabase"
        Write-Host 'Mo dia chi tren trong trinh duyet. Khong can khoi dong them.'
        return
    }
    if (Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue) {
        throw "Cong $Port dang duoc ung dung khac su dung. Hay chay .\run.ps1 -Port 8082 (hoac chon cong khac)."
    }
}
if (-not $JavaHome -or -not (Test-Path -LiteralPath (Join-Path $JavaHome 'bin\javac.exe'))) {
    $jdk = Get-ChildItem -LiteralPath "$env:ProgramFiles\Java" -Directory -Filter 'jdk*' -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($jdk) { $JavaHome = $jdk.FullName }
}
if (-not $JavaHome -or -not (Test-Path -LiteralPath (Join-Path $JavaHome 'bin\javac.exe'))) {
    throw 'Can JDK 11 tro len. Hay dat JAVA_HOME hoac truyen -JavaHome.'
}
$javaProcess = New-Object System.Diagnostics.Process
$javaProcess.StartInfo.FileName = Join-Path $JavaHome 'bin\java.exe'
$javaProcess.StartInfo.Arguments = '-version'
$javaProcess.StartInfo.UseShellExecute = $false
$javaProcess.StartInfo.CreateNoWindow = $true
$javaProcess.StartInfo.RedirectStandardOutput = $true
$javaProcess.StartInfo.RedirectStandardError = $true
try {
    # Java writes version information to stderr even when it succeeds.
    # Read it directly so Windows PowerShell 5.1 does not treat it as an error.
    if (-not $javaProcess.Start()) { throw 'Khong the chay Java.' }
    if (-not $javaProcess.WaitForExit(10000)) {
        $javaProcess.Kill()
        throw 'Java khong phan hoi khi kiem tra phien ban.'
    }
    $javaVersion = $javaProcess.StandardOutput.ReadToEnd() + $javaProcess.StandardError.ReadToEnd()
    if ($javaProcess.ExitCode -ne 0) { throw "Java ket thuc voi ma loi $($javaProcess.ExitCode)." }
}
finally { $javaProcess.Dispose() }
if ($javaVersion -notmatch 'version "(\d+)' -or [int]$Matches[1] -lt 11) { throw 'Can JDK 11 tro len.' }
$env:JAVA_HOME = $JavaHome
$env:PATH = "$JavaHome\bin;$env:PATH"
$maven = $null
if ($MavenHome) { $maven = Join-Path $MavenHome 'bin\mvn.cmd' }
if (-not $maven -or -not (Test-Path -LiteralPath $maven)) {
    $command = Get-Command mvn.cmd -ErrorAction SilentlyContinue
    if ($command) { $maven = $command.Source }
}
if (-not $maven -and (Test-Path -LiteralPath 'D:\netbeans-31-bin\netbeans\java\maven\bin\mvn.cmd')) {
    $maven = 'D:\netbeans-31-bin\netbeans\java\maven\bin\mvn.cmd'
}
if (-not $maven -or -not (Test-Path -LiteralPath $maven)) { throw 'Can Maven 3.6.3 tro len. Hay truyen -MavenHome hoac them Maven vao PATH.' }
$mavenArgs = @('-B', '-ntp', "-Dmaven.repo.local=$PSScriptRoot\.tools\m2")
if ($Build) { $mavenArgs += @('clean','package') }
elseif ($Test) { $mavenArgs += @('test') }
else {
    Write-Host "GaraMan: http://localhost:$Port/home"
    if ($env:GARAMAN_DB_URL -like 'jdbc:h2:*') { Write-Host 'CSDL: H2 (theo cau hinh GARAMAN_DB_URL)' }
    else { Write-Host 'CSDL: MySQL (mac dinh: 127.0.0.1:3306/garaman3)' }
    Write-Host 'Lan chay dau can Internet de tai thu vien. Nhan Ctrl+C de dung.'
    $mavenArgs += @('-Pdev', "-Dgaraman.port=$Port", 'compile', 'exec:java')
}
& $maven @mavenArgs
if ($LASTEXITCODE -ne 0) { throw "Maven ket thuc voi ma loi $LASTEXITCODE." }
