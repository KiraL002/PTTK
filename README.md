# GaraMan — JSP/Servlet, MVC và DAO/JDBC

Dự án hoàn thiện hai module của đề số 30: tìm kiếm dịch vụ/phụ tùng và thống kê khách hàng theo doanh thu. Java EE 8 (`javax.servlet`), JSP/JSTL, Servlet 4.0, Tomcat 9. Cần JDK 11 trở lên và Maven 3.6.3 trở lên.

## Chạy trên máy hiện tại

1. Mở `D:\PTTK\Project`, nhấp đúp **run.cmd**.
2. Đợi thông báo Tomcat đã khởi động, mở **http://localhost:8081/home**.
3. Giữ cửa sổ đang chạy. Nhấn **Ctrl+C** để dừng.

Nếu mở `run.cmd` khi GaraMan đã chạy cùng loại CSDL, script báo địa chỉ truy cập và không khởi động thêm một máy chủ. Nếu máy chủ cũ đang dùng loại CSDL khác, script yêu cầu dừng bản cũ rồi chạy lại để tránh xem nhầm dữ liệu.

Lần đầu cần Internet tải thư viện. Script tìm JDK trong `Program Files\Java` và Maven của NetBeans tại `D:\netbeans-31-bin`. Thư viện nằm trong `.tools/m2`. Nếu cổng bận, chạy PowerShell trong Project:

```powershell
.\run.ps1 -Port 8082
```

Có thể truyền `-JavaHome` và `-MavenHome` nếu cài ở nơi khác. Hoặc dùng Maven chuẩn: `mvn -Pdev compile exec:java` (mặc định cổng 8081).

## CSDL và tài khoản ban đầu

Mặc định ứng dụng kết nối **MySQL tại 127.0.0.1:3306, database garaman3, user garaman, mật khẩu database trống** theo cấu hình máy hiện tại. MySQL cần đang chạy. Mở `run.cmd` sẽ dùng MySQL mà không cần nhập lại biến môi trường. Dữ liệu bạn sửa và lưu trong Workbench được DAO đọc ở lần tải trang tiếp theo. Ứng dụng không tự chuyển sang H2 khi MySQL gặp lỗi.

Các bảng và dữ liệu MySQL hiện tại được giữ nguyên khi chạy lại. Mặc định không tạo bảng hoặc chèn lại dữ liệu MySQL; có thể bật INIT/SEED như phần cấu hình bên dưới khi khởi tạo database mới. Các biến môi trường đã đặt trong cửa sổ PowerShell vẫn được ưu tiên hơn cấu hình mặc định.

Tài khoản quản lí của CSDL mẫu mới:

- Tên đăng nhập: **admin**
- Mật khẩu: **GaraMan@123**

Mật khẩu web lưu dưới dạng PBKDF2 có salt. Không sửa trực tiếp cột `password` thành mật khẩu văn bản. Tài khoản `admin` được tạo trong `Database.initialize()` bằng PreparedStatement cùng các dòng vai trò trong `tblStaff3` và `tblManager3`, trước khi chạy `seed.sql`; vì vậy `seed.sql` chỉ có lệnh INSERT các nhân viên còn lại. Nếu tài khoản đã được đổi mật khẩu, cấu hình khởi tạo không tự khôi phục mật khẩu mẫu. Có thể đặt `GARAMAN_ADMIN_USERNAME`, `GARAMAN_ADMIN_PASSWORD` trước lần khởi tạo CSDL mới để thay tài khoản ban đầu. Các biến này không ghi đè tài khoản của CSDL đã tồn tại. Tài khoản mẫu dùng cho việc chạy bài tập cục bộ.

Dữ liệu mẫu tháng **01/08/2026–31/08/2026**: KH08 có 2 hóa đơn, 15.000.000 ₫; KH12 có 1 hóa đơn, 8.500.000 ₫; KH05 có 3 hóa đơn, 5.000.000 ₫. Tổng cộng **28.500.000 ₫ / 6 lần sửa xe**. HD015 có tổng **10.000.000 ₫**. Khoảng ngày gợi ý trên form là tháng có hóa đơn thanh toán gần nhất.

## Hai luồng sử dụng

**Module 1:** Trang chủ → Tra cứu ngay → nhập **Sơn phủ gầm** (hoặc **son phu gam**) → xem chi tiết DV01 → quay lại kết quả → xem PT15. Chấp nhận tên có/không dấu. Chỉ hiển thị danh mục đang cung cấp, xử lí từ khóa sai, không có kết quả hoặc mục đã ngừng cung cấp.

**Module 2:** Quản lí → đăng nhập → Xem báo cáo → Thống kê khách hàng → Chọn khoảng thời gian → Xem thống kê → chọn KH08 → xem HD015 → **In hóa đơn**. Nút in mở hộp thoại in của trình duyệt; có thể chọn máy in hoặc lưu PDF. Hóa đơn có bảng dịch vụ và bảng phụ tùng, dùng giá tại thời điểm lập hóa đơn.

Báo cáo chỉ gồm hóa đơn `PAID`, lọc theo `paymentDate`, tính cả hai ngày đầu/cuối. Mỗi hóa đơn là một lần sửa xe. Doanh thu bằng tổng số lượng × đơn giá lưu trên chi tiết dịch vụ và phụ tùng. Truy vấn tổng hợp tránh nhân đôi khi một hóa đơn có nhiều dòng của cả hai loại. Tồn kho `stockQty` được tính từ phiếu nhập `RECEIVED` trừ phụ tùng dùng trên hóa đơn chưa `CANCELLED`. Hai module chỉ đọc số lượng tồn, không đặt hàng, giữ hàng hoặc trừ kho khi xem chi tiết/in hóa đơn. `totalAmount`, `totalRevenue`, `visitCount` là số liệu tính từ chi tiết hóa đơn; `startDate/endDate` là tham số lọc theo `paymentDate`, không phải cột bổ sung trong bảng hóa đơn.

Đường dẫn dùng trong báo cáo:

```text
/search?keyword=son+phu+gam
/service-detail?serviceId=1&keyword=son+phu+gam
/part-detail?partId=15&keyword=son+phu+gam
/statistics-result?startDate=2026-08-01&endDate=2026-08-31
/customer-visits?customerId=8&startDate=2026-08-01&endDate=2026-08-31
/invoice-detail?invoiceId=15&customerId=8&startDate=2026-08-01&endDate=2026-08-31
```

Các trang quản lí yêu cầu phiên đăng nhập; phiên hết hạn sau 30 phút không hoạt động. Liên kết hóa đơn phải giữ đúng khách hàng và khoảng ngày. Đăng nhập/đăng xuất kiểm tra CSRF, truy vấn dùng tham số JDBC, JSP escape dữ liệu hiển thị. Tìm kiếm và báo cáo hoạt động khi tắt JavaScript; lúc đó dùng Ctrl+P để in.

## Cấu trúc

```text
src/main/java/vn/garaman/
  controller/     SearchServlet3, CustomerStatisticsServlet3, PageController, LoginServlet
  dao/            DAO3 và các DAO truy vấn JDBC
  model/          Các lớp thực thể, chi tiết hóa đơn và kết quả thống kê
  config/         Khởi tạo/kết thúc kết nối CSDL theo vòng đời ứng dụng
  util/           Kiểm tra từ khóa, ngày tháng, băm mật khẩu
  web/            Filter phiên quản lí, UTF-8/CSRF và định dạng cho JSP
src/main/resources/
  schema.sql      Cấu trúc 19 bảng đồng bộ bản thiết kế, dùng được cho H2/MySQL
  seed.sql        Dữ liệu mẫu của hai module
src/main/webapp/
  WEB-INF/view/
    member/       Đăng nhập tài khoản (login.jsp)
    customer/     Trang chủ, tìm kiếm, chi tiết dịch vụ và phụ tùng
    manager/      Trang quản lí, báo cáo, thống kê, các lần sửa xe và hóa đơn
    fragments/    header.jspf, footer.jspf dùng chung
    error.jsp     Trang lỗi dùng chung
  WEB-INF/web.xml Cấu hình Java EE
  assets/         CSS và JavaScript hỗ trợ in/kiểm tra form
src/test/java/    Kiểm thử DAO/JDBC và kiểm tra dữ liệu đầu vào
src/dev/java/    Tomcat nhúng dùng để chạy cục bộ
```

Servlet kiểm tra đầu vào và gọi DAO, DAO đọc CSDL và trả model, JSP hiển thị dữ liệu. `Web.view()` ánh xạ tên trang sang nhóm `member`, `customer` hoặc `manager`; URL người dùng truy cập vẫn là các URL Servlet như `/login`, `/search`, `/statistics-result`. Các JSP được bảo vệ trong `WEB-INF`, các trang dùng chung fragment qua đường dẫn tuyệt đối tính từ gốc ứng dụng. JavaScript không chứa danh mục/hóa đơn hoặc logic tính doanh thu. Phạm vi hiện tại chưa bao gồm các module tạo hóa đơn, quản lí kho hay CRUD danh mục.

## Cấu hình kết nối và khởi tạo CSDL

MySQL là CSDL mặc định. Nếu đổi máy chủ/tài khoản hoặc cần khởi tạo database mới, cấu hình trong PowerShell trước khi chạy. Ví dụ dưới đây dùng CSDL trống `garaman3` đã tạo sẵn:

```powershell
$env:GARAMAN_DB_URL='jdbc:mysql://localhost:3306/garaman3?connectionTimeZone=Asia/Ho_Chi_Minh&characterEncoding=UTF-8'
$env:GARAMAN_DB_USER='garaman'
$env:GARAMAN_DB_PASSWORD='mat-khau-cua-ban'
$env:GARAMAN_DB_INIT='true'
$env:GARAMAN_SEED_DEMO='true'
.\run.ps1
```

`GARAMAN_DB_INIT=true` tạo các bảng còn thiếu, không xóa hay ghi đè dữ liệu. Dữ liệu mẫu chỉ được chèn khi các bảng nghiệp vụ chính còn trống. Với database đã có dữ liệu theo `GaraMan3.sql`, bỏ hai biến INIT/SEED (mặc định false cho MySQL). Cần có tài khoản `MANAGER` với mật khẩu định dạng PBKDF2 của ứng dụng để đăng nhập. Không tự chuyển đổi mật khẩu của database có sẵn. MySQL đã được kiểm tra trên máy chủ MySQL 8.4 tại máy hiện tại.

Cấu trúc hiện tại có **19 bảng**, giữ kế thừa nhân viên qua `tblMember3 → tblStaff3 → tblManager3/tblSalesStaff3/tblWarehouseStaff3`. Khóa ngoại dùng tên trong bản thiết kế, ví dụ `tblCustomer3id`, `tblCar3id`, `tblSalesStaff3id`. SQL JOIN/ModelMapper ánh xạ khóa ngoại sang các đối tượng Java; không yêu cầu tên tham số HTTP phải giống tên cột khóa ngoại. `password` chỉ dùng trong xác thực, không đưa vào model hiển thị.

CSDL MySQL của máy này đã được đồng bộ cấu trúc và giữ nguyên dữ liệu, không cần bật chuyển đổi mỗi lần chạy. Bản sao lưu trước chuyển đổi nằm ở `.data/garaman-before-design-sync.sql`. Với bản CSDL cũ còn `tblMember3.position` hoặc các khóa ngoại `customerId/carId/...`, hãy sao lưu trước rồi chạy một lần:

```powershell
$env:GARAMAN_DB_MIGRATE='true'
.\run.ps1
```

Sau khi dừng bằng Ctrl+C, bỏ cờ bằng `Remove-Item Env:GARAMAN_DB_MIGRATE` trong cửa sổ đó. Chuyển đổi giữ mật khẩu và dữ liệu nghiệp vụ, có thể chạy lại; MySQL tự commit các lệnh DDL nên bản sao lưu cần được giữ đến khi kiểm tra xong. `GARAMAN_DB_MIGRATE` cũng áp dụng cho bản H2 cũ.

H2 vẫn có thể được chọn rõ ràng để chạy thử. Bản H2 cũ được giữ ở `.data/garaman.mv.db`. Ví dụ chạy riêng ở cổng 8082:

```powershell
$env:GARAMAN_DB_URL='jdbc:h2:file:D:/PTTK/Project/.data/garaman;MODE=MySQL;DATABASE_TO_LOWER=TRUE;DB_CLOSE_ON_EXIT=FALSE'
$env:GARAMAN_DB_USER='sa'
$env:GARAMAN_DB_PASSWORD=''
$env:GARAMAN_DB_INIT='true'
$env:GARAMAN_SEED_DEMO='true'
.\run.ps1 -Port 8082
```

Để trở về MySQL mặc định, mở cửa sổ mới không có các biến H2 rồi chạy `run.cmd`.

## Kiểm thử và đóng gói

```powershell
.\run.ps1 -Test
.\run.ps1 -Build
```

Hoặc `mvn test` / `mvn clean package`. Kiểm thử dùng H2 trong bộ nhớ riêng, không thay đổi CSDL của ứng dụng. Đóng gói tạo **target/garaman.war**. Triển khai WAR trên **Tomcat 9** và JDK 11+; khi đó URL theo context là `http://localhost:8080/garaman/`. Tomcat 10+ dùng Jakarta Servlet nên không chạy trực tiếp mã `javax.servlet` này. WAR cũng dùng MySQL mặc định; dùng biến môi trường để cấu hình máy chủ MySQL khi triển khai ở máy khác. Trình chạy cục bộ chỉ lắng nghe trên 127.0.0.1.
