-- Khách hàng
SELECT
    *
FROM
    garaman3.tblCustomer3
ORDER BY id;

-- Dịch vụ
SELECT
    *
FROM
    garaman3.tblService3
ORDER BY id;

-- Phụ tùng
SELECT
    *
FROM
    garaman3.tblSparePart3
ORDER BY id;

-- Hóa đơn
SELECT
    *
FROM
    garaman3.tblInvoice3
ORDER BY id;

-- Chi tiết dịch vụ trong hóa đơn
SELECT
    *
FROM
    garaman3.tblInvoiceService3
ORDER BY id;

-- Chi tiết phụ tùng trong hóa đơn
SELECT
    *
FROM
    garaman3.tblInvoicePart3
ORDER BY id;

-- Tài khoản và vai trò quản lí (mật khẩu không đưa ra màn hình)
SELECT
    m.id,
    m.fullName,
    m.username,
    m.role
FROM
    garaman3.tblMember3 m
WHERE
    m.role = 'MANAGER';

-- Vai trò nhân viên bán hàng và nhân viên kho
SELECT
    id, fullName, username, role
FROM
    garaman3.tblMember3
WHERE
    role = 'SALES';

SELECT
    id, fullName, username, role
FROM
    garaman3.tblMember3
WHERE
    role = 'WAREHOUSE';
