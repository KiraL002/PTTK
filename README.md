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

Mật khẩu web lưu dưới dạng PBKDF2 có salt. Không sửa trực tiếp cột `password` thành mật khẩu văn bản. Tài khoản `admin` được tạo trong `Database.initialize()` bằng PreparedStatement với `role='MANAGER'` ngay trong `tblMember3`, trước khi chạy `seed.sql`; vì vậy `seed.sql` chỉ có lệnh INSERT các nhân viên còn lại. Nếu tài khoản đã được đổi mật khẩu, cấu hình khởi tạo không tự khôi phục mật khẩu mẫu. Có thể đặt `GARAMAN_ADMIN_USERNAME`, `GARAMAN_ADMIN_PASSWORD` trước lần khởi tạo CSDL mới để thay tài khoản ban đầu. Các biến này không ghi đè tài khoản của CSDL đã tồn tại. Tài khoản mẫu dùng cho việc chạy bài tập cục bộ.

Dữ liệu mẫu tháng **01/08/2026–31/08/2026** gồm 2 hóa đơn của KH02 (15.000.000 ₫), 1 hóa đơn của KH03 (8.500.000 ₫) và 3 hóa đơn của KH01 (5.000.000 ₫). Tổng cộng **28.500.000 ₫ / 6 lần sửa xe**. HD002 có tổng **10.000.000 ₫**. Khoảng ngày gợi ý trên form là tháng có hóa đơn thanh toán gần nhất.

`seed-extra.sql` bổ sung 8 dịch vụ, 10 phụ tùng, 6 khách hàng cùng 6 xe, 3 nhà cung cấp, 1 kho và 16 hóa đơn tháng 06–07/2026 (14 đã thanh toán, 1 chưa thanh toán, 1 bị hủy). Có phụ tùng đang kinh doanh nhưng tạm hết hàng (PT14), phiếu nhập đã nhận hàng và phiếu đang chờ. Dữ liệu mẫu bắt đầu từ ID 1 ở từng bảng. ID bổ sung nối tiếp dữ liệu mẫu gốc, gồm dịch vụ 5–12, phụ tùng 5–14, khách hàng 4–9, xe 4–9 và hóa đơn 8–23. Khi khởi tạo CSDL mẫu trống, ứng dụng chạy `seed.sql` rồi `seed-extra.sql` trong cùng một giao dịch.

Với CSDL đã có dữ liệu, chạy bổ sung trên cấu trúc hiện tại trong `src/main/resources/schema.sql`. Đối chiếu ID của dữ liệu mẫu gốc với `seed.sql` trước khi nạp bổ sung. Trên cùng kết nối MySQL Workbench, chạy `START TRANSACTION` rồi thực thi toàn bộ `src/main/resources/seed-extra.sql`. Chạy `COMMIT` sau khi kiểm tra kết quả hoặc `ROLLBACK` nếu có lỗi. Khi chạy lại, script bỏ qua các dòng khớp dữ liệu mẫu và báo lỗi nếu gặp xung đột khóa.

## Hai luồng sử dụng

**Module 1:** Trang chủ → Tra cứu ngay → nhập **Sơn phủ gầm** (hoặc **son phu gam**) → xem chi tiết DV01 → quay lại kết quả → xem PT01. Chấp nhận tên có/không dấu. Chỉ hiển thị danh mục đang cung cấp, xử lí từ khóa sai, không có kết quả hoặc mục đã ngừng cung cấp.

**Module 2:** Quản lí → đăng nhập → Xem báo cáo → Thống kê khách hàng → Theo doanh thu → Chọn khoảng thời gian → Xem thống kê → chọn KH02 → xem HD002. Có thể chọn **In hóa đơn** để mở hộp thoại in của trình duyệt, chọn máy in hoặc lưu PDF. Hóa đơn có bảng dịch vụ và bảng phụ tùng, dùng giá tại thời điểm lập hóa đơn.

Báo cáo chỉ gồm hóa đơn `PAID`, lọc theo `paymentDate`, tính cả hai ngày đầu/cuối. Mỗi hóa đơn là một lần sửa xe. Doanh thu bằng tổng số lượng × đơn giá lưu trên chi tiết dịch vụ và phụ tùng. Truy vấn tổng hợp tránh nhân đôi khi một hóa đơn có nhiều dòng của cả hai loại. Tồn kho `stockQty` được tính từ phiếu nhập `RECEIVED` trừ phụ tùng dùng trên hóa đơn chưa `CANCELLED`. Hai module chỉ đọc số lượng tồn, không đặt hàng, giữ hàng hoặc trừ kho khi xem chi tiết/in hóa đơn. `totalAmount`, `totalRevenue`, `visitCount` là số liệu tính từ chi tiết hóa đơn; `startDate/endDate` là tham số lọc theo `paymentDate`, không phải cột bổ sung trong bảng hóa đơn.

Đường dẫn minh họa với dữ liệu hiện tại

```text
/search?keyword=son+phu+gam
/service-detail?serviceId=1&keyword=son+phu+gam
/part-detail?partId=1&keyword=son+phu+gam
/statistics-result?startDate=2026-08-01&endDate=2026-08-31
/customer-visits?customerId=2&startDate=2026-08-01&endDate=2026-08-31
/invoice-detail?invoiceId=2&customerId=2&startDate=2026-08-01&endDate=2026-08-31
```

Các trang quản lí yêu cầu phiên đăng nhập; phiên hết hạn sau 30 phút không hoạt động. Liên kết hóa đơn phải giữ đúng khách hàng và khoảng ngày. Đăng nhập/đăng xuất kiểm tra CSRF, truy vấn dùng tham số JDBC, JSP escape dữ liệu hiển thị. Tìm kiếm và báo cáo hoạt động khi tắt JavaScript; lúc đó dùng Ctrl+P để in.

Các quan hệ trong model được đồng bộ với sơ đồ lớp thực thể: `ImportReceipt3` chứa `supplier`, `warehouseStaff`, `warehouse` và `importDetails`; `Invoice3` chứa `customer`, `car`, `salesStaff` và hai danh sách chi tiết. `Supplier3`, `WarehouseStaff3`, `Warehouse3` không giữ danh sách phiếu nhập; `SalesStaff3` và `Car3` không giữ danh sách hóa đơn. `Customer3.invoices` vẫn được giữ để xem các lần sửa xe của khách hàng.

Ở module thống kê, Servlet vẫn gọi DAO theo thứ tự trong biểu đồ tuần tự. Sau khi lấy dữ liệu, Servlet gắn các đối tượng vào hóa đơn và chuyển cho JSP. Trong trang các lần sửa xe, `Customer3.invoices` chứa danh sách hóa đơn của khoảng ngày đang xem; mỗi hóa đơn được gắn lại khách hàng và xe tương ứng. Trong trang chi tiết, `Invoice3` được gắn đầy đủ khách hàng, xe và nhân viên phụ trách. Các thuộc tính đều là `private`, truy cập qua getter/setter; các mảng chi tiết hóa đơn và phiếu nhập được sao chép khi gán/lấy để bảo vệ cấu trúc danh sách.

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
  schema.sql      Cấu trúc 15 bảng đồng bộ bản thiết kế, dùng được cho H2/MySQL
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

Cấu trúc hiện tại có **15 bảng**. Tất cả tài khoản nằm trong `tblMember3`, cột `role VARCHAR(30) NOT NULL` nhận một trong ba giá trị `MANAGER`, `SALES`, `WAREHOUSE`. Không tách bảng theo lớp nhân viên. `tblInvoice3.tblMember3id` và `tblImportReceipt3.tblMember3id` cùng tham chiếu `tblMember3.id`. Khóa ngoại bảo đảm tài khoản tồn tại; việc đăng nhập quản lí và lấy nhân viên bán hàng trong DAO còn kiểm tra vai trò tương ứng. Khi bổ sung chức năng ghi hóa đơn/phiếu nhập, phải kiểm tra vai trò người phụ trách trước khi ghi vì khóa ngoại chung không tự kiểm tra vai trò.

Các lớp Java `Staff3`, `Manager3`, `SalesStaff3`, `WarehouseStaff3` vẫn giữ quan hệ kế thừa. `ModelMapper.staff()` đọc `Member.role` vào thuộc tính `Staff3.position` hiện có để giữ cách sử dụng model; không còn cột SQL `position`. Thuộc tính của model được đóng gói bằng `private` và getter/setter. `password` chỉ dùng trong xác thực, không đưa vào model hiển thị. Các tên tham số HTTP như `customerId` vẫn có thể khác tên khóa ngoại `tblCustomer3id`.

Với bản CSDL cũ còn bốn bảng `tblStaff3`, `tblManager3`, `tblSalesStaff3`, `tblWarehouseStaff3`, cột `tblMember3.position` hoặc các khóa ngoại cũ, hãy sao lưu trước rồi chạy một lần:

```powershell
$env:GARAMAN_DB_MIGRATE='true'
.\run.ps1
```

Sau khi dừng bằng Ctrl+C, bỏ cờ bằng `Remove-Item Env:GARAMAN_DB_MIGRATE` trong cửa sổ đó. Chuyển đổi giữ id, mật khẩu và dữ liệu nghiệp vụ; chuyển vai trò sang `Member.role`, đổi hai khóa ngoại sang `tblMember3id`, rồi bỏ các bảng tài khoản phụ. Có thể chạy lại nếu bị gián đoạn. Nếu tài khoản có nhiều vai trò khác nhau, chức danh cũ không thể quy đổi, hoặc chứng từ gắn sai vai trò, chương trình dừng trước khi thay đổi cấu trúc để tránh mất thông tin. MySQL tự commit các lệnh DDL nên cần giữ bản sao lưu đến khi kiểm tra xong. `GARAMAN_DB_MIGRATE` cũng áp dụng cho bản H2 cũ.

MySQL `garaman3` tại máy hiện tại đã được chuyển sang cấu trúc 15 bảng ngày 14/11/2026, không cần bật cờ chuyển đổi khi chạy bình thường. Đã so sánh dữ liệu và mật khẩu trước–sau chuyển đổi; các bảng nghiệp vụ giữ nguyên dữ liệu. Bản sao lưu trước lần gộp này đã được xóa theo yêu cầu sau khi kiểm tra hoàn tất.

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
