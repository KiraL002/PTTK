-- Loaded once, transactionally, only into an empty database.
-- The initial MANAGER (id=1) is inserted by Database.initialize() with a PBKDF2 password hash.
-- The INSERT below creates the remaining staff accounts.
INSERT INTO
    tblMember3 (id, fullName, username, password, phone, position)
VALUES
    (2, 'Phạm Văn D', 'sales', '!disabled!', '0900000002', 'SALES'),
    (3, 'Nhân viên kho', 'warehouse', '!disabled!', '0900000003', 'WAREHOUSE');

INSERT INTO
    tblGarage3 (id, name, address, phone, description)
VALUES
    (1, 'GaraMan', 'Hà Nội', '02430000000', 'Chăm sóc và bảo dưỡng ô tô');

INSERT INTO
    tblWarehouse3 (id, name, capacity, description, garageId)
VALUES
    (1, 'Kho phụ tùng', 1000, 'Kho chính', 1);

INSERT INTO
    tblSupplier3 (id, name, address, phone)
VALUES
    (1, 'Nhà cung cấp phụ tùng', 'Hà Nội', '02430000001');

INSERT INTO
    tblService3 (
        id,
        name,
        price,
        duration,
        description,
        category,
        applicableCar,
        warranty,
        status
    )
VALUES
    (
        1,
        'Sơn phủ gầm chống ồn',
        2500000,
        4,
        'Sử dụng dung dịch phủ gầm 3M, giúp chống rỉ sét và giảm tiếng ồn.',
        'Dịch vụ chăm sóc xe',
        'Sedan, Hatchback, SUV 5 chỗ',
        12,
        'ACTIVE'
    ),
    (
        2,
        'Sơn phủ gầm cao su non',
        3000000,
        5,
        'Phủ lớp cao su non bảo vệ gầm xe, hỗ trợ chống ăn mòn và cách âm.',
        'Dịch vụ chăm sóc xe',
        'Sedan, Hatchback, SUV',
        12,
        'ACTIVE'
    ),
    (
        3,
        'Bảo dưỡng cấp lớn',
        5000000,
        6,
        'Kiểm tra, bảo dưỡng động cơ, phanh, lái và hệ thống điện. Giá dịch vụ là tiền công, phụ tùng tính riêng.',
        'Dịch vụ bảo dưỡng',
        'Xe du lịch từ 4 đến 7 chỗ',
        0,
        'ACTIVE'
    ),
    (
        4,
        'Dịch vụ đã ngừng cung cấp',
        100000,
        1,
        'Không hiển thị trong danh mục hiện hành.',
        'Dịch vụ khác',
        'Ô tô',
        0,
        'INACTIVE'
    );

INSERT INTO
    tblSparePart3 (
        id,
        name,
        sellingPrice,
        description,
        unit,
        specification,
        applicableCar,
        warranty,
        status
    )
VALUES
    (
        15,
        'Chai xịt sơn phủ gầm 3M',
        250000,
        'Sơn bảo vệ bề mặt gầm xe, hỗ trợ chống rỉ sét và giảm tiếng ồn.',
        'Chai',
        'Dung tích 650 ml, màu đen',
        'Các dòng xe ô tô',
        0,
        'ACTIVE'
    ),
    (
        16,
        'Lọc nhớt động cơ',
        500000,
        'Lọc tạp chất trong dầu bôi trơn động cơ.',
        'Cái',
        'Lọc nhớt thay thế định kỳ',
        'Theo mã phụ tùng của từng dòng xe',
        0,
        'ACTIVE'
    ),
    (
        17,
        'Dầu máy tổng hợp',
        500000,
        'Dầu bôi trơn động cơ tổng hợp.',
        'Lít',
        'SAE 5W-30',
        'Theo khuyến cáo của nhà sản xuất',
        0,
        'ACTIVE'
    ),
    (
        18,
        'Phụ tùng đã ngừng kinh doanh',
        50000,
        'Không hiển thị trong danh mục hiện hành.',
        'Cái',
        'Mẫu cũ',
        'Ô tô',
        0,
        'INACTIVE'
    );

INSERT INTO
    tblServicePart3 (id, quantity, serviceId, sparePartId)
VALUES
    (1, 1, 1, 15),
    (2, 2, 2, 15),
    (3, 1, 3, 16),
    (4, 4, 3, 17);

INSERT INTO
    tblCustomer3 (id, fullName, address, phone, customerType)
VALUES
    (8, 'Nguyễn Văn A', 'Hà Nội', '0901234567', 'REGULAR'),
    (12, 'Trần Thị B', 'Hà Nội', '0912345678', 'REGULAR'),
    (5, 'Lê Văn C', 'Hà Nội', '0987654321', 'REGULAR');

INSERT INTO
    tblCar3 (id, licensePlate, brand, model, `year`, customerId)
VALUES
    (1, '30A-123.45', 'Toyota', 'Vios', 2020, 8),
    (2, '30F-456.78', 'Honda', 'City', 2021, 12),
    (3, '30G-789.12', 'Hyundai', 'Accent', 2022, 5);

INSERT INTO
    tblImportReceipt3 (id, importDate, status, warehouseId, supplierId, warehouseStaffId)
VALUES
    (1, '2026-08-01 08:00:00', 'RECEIVED', 1, 1, 3);

INSERT INTO
    tblImportDetail3 (id, quantity, importPrice, importReceiptId, sparePartId)
VALUES
    (1, 50, 180000, 1, 15),
    (2, 50, 350000, 1, 16),
    (3, 200, 300000, 1, 17);

INSERT INTO
    tblInvoice3 (
        id,
        createdDate,
        paymentDate,
        status,
        requestDescription,
        paymentMethod,
        customerId,
        carId,
        salesStaffId
    )
VALUES
    (
        15,
        '2026-08-05 08:00:00',
        '2026-08-05 16:00:00',
        'PAID',
        'Sơn phủ gầm và bảo dưỡng cấp lớn.',
        'BANK_TRANSFER',
        8,
        1,
        2
    ),
    (
        42,
        '2026-08-20 08:00:00',
        '2026-08-20 14:30:00',
        'PAID',
        'Sơn phủ gầm, thay dầu máy.',
        'CASH',
        8,
        1,
        2
    ),
    (
        58,
        '2026-08-22 08:00:00',
        '2026-08-22 17:00:00',
        'PAID',
        'Bảo dưỡng định kỳ.',
        'BANK_TRANSFER',
        12,
        2,
        2
    ),
    (
        11,
        '2026-08-03 09:00:00',
        '2026-08-03 10:00:00',
        'PAID',
        'Thay dầu máy.',
        'CASH',
        5,
        3,
        2
    ),
    (
        30,
        '2026-08-14 09:00:00',
        '2026-08-14 10:30:00',
        'PAID',
        'Thay lọc nhớt và dầu máy.',
        'CASH',
        5,
        3,
        2
    ),
    (
        62,
        '2026-08-29 09:00:00',
        '2026-08-29 11:00:00',
        'PAID',
        'Thay lọc nhớt và dầu máy.',
        'BANK_TRANSFER',
        5,
        3,
        2
    ),
    (
        99,
        '2026-08-30 09:00:00',
        NULL,
        'UNPAID',
        'Yêu cầu chưa thanh toán.',
        NULL,
        8,
        1,
        2
    );

INSERT INTO
    tblInvoiceService3 (id, quantity, price, technicianName, workStatus, invoiceId, serviceId)
VALUES
    (1, 1, 2500000, 'Nguyễn Văn K', 'COMPLETED', 15, 1),
    (2, 1, 5000000, 'Nguyễn Văn K', 'COMPLETED', 15, 3),
    (3, 1, 3000000, 'Nguyễn Văn K', 'COMPLETED', 42, 2),
    (4, 1, 5000000, 'Nguyễn Văn K', 'COMPLETED', 58, 3),
    (5, 1, 5000000, 'Nguyễn Văn K', 'PENDING', 99, 3);

INSERT INTO
    tblInvoicePart3 (id, quantity, price, invoiceId, sparePartId)
VALUES
    (1, 1, 500000, 15, 16),
    (2, 4, 500000, 15, 17),
    (3, 4, 500000, 42, 17),
    (4, 2, 500000, 58, 16),
    (5, 5, 500000, 58, 17),
    (6, 4, 500000, 11, 17),
    (7, 1, 500000, 30, 16),
    (8, 2, 500000, 30, 17),
    (9, 1, 500000, 62, 16),
    (10, 2, 500000, 62, 17);
