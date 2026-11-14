-- Khách hàng
SELECT * FROM garaman3.tblCustomer3;

-- Dịch vụ
SELECT * FROM garaman3.tblService3;

-- Phụ tùng
SELECT * FROM garaman3.tblSparePart3;

-- Hóa đơn
SELECT * FROM garaman3.tblInvoice3;

-- Chi tiết dịch vụ trong hóa đơn
SELECT * FROM garaman3.tblInvoiceService3;

-- Chi tiết phụ tùng trong hóa đơn
SELECT * FROM garaman3.tblInvoicePart3;

-- Tài khoản và vai trò quản lí (mật khẩu không đưa ra màn hình)
SELECT m.id, m.fullName, m.username, s.position
FROM garaman3.tblMember3 m
JOIN garaman3.tblStaff3 s ON s.tblMember3id=m.id
JOIN garaman3.tblManager3 g ON g.tblMember3id=s.tblMember3id;

-- Vai trò nhân viên bán hàng và nhân viên kho
SELECT * FROM garaman3.tblSalesStaff3;
SELECT * FROM garaman3.tblWarehouseStaff3;
