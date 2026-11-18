-- Additional GaraMan demo data for H2/MySQL (UTF-8).
-- Run AFTER schema.sql and seed.sql. Existing reference staff IDs 2 (SALES), 3 (WAREHOUSE)
-- and garage ID 1 must exist. This file contains INSERT statements only, in FK order.
-- Supplemental IDs continue after each table's maximum baseline seed ID.
-- Suppliers 2-4; warehouse 2; services 5-12; parts 5-14; customers 4-9; cars 4-9.
-- Receipts 2-5; import lines 4-13; service-part lines 5-12; invoices 8-23.
-- Invoice-service lines 6-27; invoice-part lines 11-34. Existing reference rows stay unchanged.
-- Each INSERT skips an identical existing row. A conflicting ID or unique key raises
-- an error instead of overwriting data. Execute the WHOLE file in one transaction
-- and ROLLBACK on the first error. Never ignore errors and then COMMIT partial work.
-- Database.initialize() includes this file in the fresh-demo seeding transaction.
-- For an existing DB, apply explicitly after checking the baseline FK IDs and roles.
-- No August payments are added; August totals and the latest-paid month stay unchanged.
-- Do not add payment dates after August or consume PT01-PT03 without revising examples.
-- Additional suppliers and warehouse
INSERT INTO tblSupplier3 (id, name, taxCode, address, phone, email)
SELECT 2, 'Phụ tùng Bắc Hà', '0109001001', 'Long Biên, Hà Nội', '02435551001', 'lienhe@bacha.example'
WHERE NOT EXISTS (SELECT 1 FROM tblSupplier3 WHERE id=2 AND name='Phụ tùng Bắc Hà' AND taxCode='0109001001' AND address='Long Biên, Hà Nội' AND phone='02435551001' AND email='lienhe@bacha.example');
INSERT INTO tblSupplier3 (id, name, taxCode, address, phone, email)
SELECT 3, 'Vật tư ô tô An Phát', '0109001002', 'Hoàng Mai, Hà Nội', '02435551002', 'kho@anphat.example'
WHERE NOT EXISTS (SELECT 1 FROM tblSupplier3 WHERE id=3 AND name='Vật tư ô tô An Phát' AND taxCode='0109001002' AND address='Hoàng Mai, Hà Nội' AND phone='02435551002' AND email='kho@anphat.example');
INSERT INTO tblSupplier3 (id, name, taxCode, address, phone, email)
SELECT 4, 'Lốp và ắc quy Minh Thành', '0109001003', 'Cầu Giấy, Hà Nội', '02435551003', 'banhang@minhthanh.example'
WHERE NOT EXISTS (SELECT 1 FROM tblSupplier3 WHERE id=4 AND name='Lốp và ắc quy Minh Thành' AND taxCode='0109001003' AND address='Cầu Giấy, Hà Nội' AND phone='02435551003' AND email='banhang@minhthanh.example');

-- Second warehouse of the existing garage
INSERT INTO tblWarehouse3 (id, name, capacity, description, tblGarage3id)
SELECT 2, 'Kho vật tư bảo dưỡng', 600, 'Lưu dầu, lọc, lốp và vật tư bảo dưỡng định kỳ.', 1
WHERE NOT EXISTS (SELECT 1 FROM tblWarehouse3 WHERE id=2 AND name='Kho vật tư bảo dưỡng' AND capacity=600 AND description='Lưu dầu, lọc, lốp và vật tư bảo dưỡng định kỳ.' AND tblGarage3id=1);

-- Service prices are labor charges; parts are billed separately
INSERT INTO tblService3 (id, name, price, duration, description, category, applicableCar, warranty, status)
SELECT 5, 'Thay dầu động cơ', 150000, 1, 'Xả dầu cũ và thay dầu, lọc dầu theo khuyến cáo. Giá là tiền công, dầu và lọc tính riêng.', 'Bảo dưỡng định kỳ', 'Xe du lịch 4 đến 7 chỗ', 0, 'ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM tblService3 WHERE id=5 AND name='Thay dầu động cơ' AND price=150000 AND duration=1 AND description='Xả dầu cũ và thay dầu, lọc dầu theo khuyến cáo. Giá là tiền công, dầu và lọc tính riêng.' AND category='Bảo dưỡng định kỳ' AND applicableCar='Xe du lịch 4 đến 7 chỗ' AND warranty=0 AND status='ACTIVE');
INSERT INTO tblService3 (id, name, price, duration, description, category, applicableCar, warranty, status)
SELECT 6, 'Bảo dưỡng hệ thống phanh', 450000, 2, 'Kiểm tra, vệ sinh và bảo dưỡng phanh. Má phanh thay thế được tính riêng.', 'Hệ thống phanh', 'Sedan, Hatchback, SUV', 3, 'ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM tblService3 WHERE id=6 AND name='Bảo dưỡng hệ thống phanh' AND price=450000 AND duration=2 AND description='Kiểm tra, vệ sinh và bảo dưỡng phanh. Má phanh thay thế được tính riêng.' AND category='Hệ thống phanh' AND applicableCar='Sedan, Hatchback, SUV' AND warranty=3 AND status='ACTIVE');
INSERT INTO tblService3 (id, name, price, duration, description, category, applicableCar, warranty, status)
SELECT 7, 'Vệ sinh điều hòa ô tô', 650000, 2, 'Vệ sinh giàn lạnh và kiểm tra điều hòa. Dung dịch, lọc gió thay mới được tính riêng.', 'Điều hòa', 'Xe du lịch 4 đến 7 chỗ', 1, 'ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM tblService3 WHERE id=7 AND name='Vệ sinh điều hòa ô tô' AND price=650000 AND duration=2 AND description='Vệ sinh giàn lạnh và kiểm tra điều hòa. Dung dịch, lọc gió thay mới được tính riêng.' AND category='Điều hòa' AND applicableCar='Xe du lịch 4 đến 7 chỗ' AND warranty=1 AND status='ACTIVE');
INSERT INTO tblService3 (id, name, price, duration, description, category, applicableCar, warranty, status)
SELECT 8, 'Cân chỉnh góc đặt bánh xe', 500000, 2, 'Kiểm tra và điều chỉnh góc đặt bánh xe bằng thiết bị chuyên dụng.', 'Lốp và hệ thống lái', 'Sedan, SUV, bán tải', 1, 'ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM tblService3 WHERE id=8 AND name='Cân chỉnh góc đặt bánh xe' AND price=500000 AND duration=2 AND description='Kiểm tra và điều chỉnh góc đặt bánh xe bằng thiết bị chuyên dụng.' AND category='Lốp và hệ thống lái' AND applicableCar='Sedan, SUV, bán tải' AND warranty=1 AND status='ACTIVE');
INSERT INTO tblService3 (id, name, price, duration, description, category, applicableCar, warranty, status)
SELECT 9, 'Thay ắc quy', 120000, 1, 'Kiểm tra hệ thống sạc và lắp ắc quy mới. Bình ắc quy được tính riêng.', 'Hệ thống điện', 'Ô tô dùng ắc quy 12V', 1, 'ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM tblService3 WHERE id=9 AND name='Thay ắc quy' AND price=120000 AND duration=1 AND description='Kiểm tra hệ thống sạc và lắp ắc quy mới. Bình ắc quy được tính riêng.' AND category='Hệ thống điện' AND applicableCar='Ô tô dùng ắc quy 12V' AND warranty=1 AND status='ACTIVE');
INSERT INTO tblService3 (id, name, price, duration, description, category, applicableCar, warranty, status)
SELECT 10, 'Thay nước làm mát', 250000, 2, 'Xả nước làm mát cũ, súc rửa và nạp nước mới. Nước làm mát được tính riêng.', 'Bảo dưỡng động cơ', 'Theo khuyến cáo của nhà sản xuất', 0, 'ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM tblService3 WHERE id=10 AND name='Thay nước làm mát' AND price=250000 AND duration=2 AND description='Xả nước làm mát cũ, súc rửa và nạp nước mới. Nước làm mát được tính riêng.' AND category='Bảo dưỡng động cơ' AND applicableCar='Theo khuyến cáo của nhà sản xuất' AND warranty=0 AND status='ACTIVE');
INSERT INTO tblService3 (id, name, price, duration, description, category, applicableCar, warranty, status)
SELECT 11, 'Thay bugi động cơ', 300000, 1, 'Kiểm tra và thay bugi theo tình trạng động cơ. Bugi được tính riêng.', 'Bảo dưỡng động cơ', 'Động cơ xăng 4 xi lanh', 1, 'ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM tblService3 WHERE id=11 AND name='Thay bugi động cơ' AND price=300000 AND duration=1 AND description='Kiểm tra và thay bugi theo tình trạng động cơ. Bugi được tính riêng.' AND category='Bảo dưỡng động cơ' AND applicableCar='Động cơ xăng 4 xi lanh' AND warranty=1 AND status='ACTIVE');
INSERT INTO tblService3 (id, name, price, duration, description, category, applicableCar, warranty, status)
SELECT 12, 'Đảo lốp và cân bằng động', 350000, 2, 'Đảo vị trí lốp và cân bằng động bốn bánh, kiểm tra áp suất lốp.', 'Lốp và hệ thống lái', 'Sedan, Hatchback, SUV', 0, 'ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM tblService3 WHERE id=12 AND name='Đảo lốp và cân bằng động' AND price=350000 AND duration=2 AND description='Đảo vị trí lốp và cân bằng động bốn bánh, kiểm tra áp suất lốp.' AND category='Lốp và hệ thống lái' AND applicableCar='Sedan, Hatchback, SUV' AND warranty=0 AND status='ACTIVE');

-- New parts; id14 intentionally has no inventory movement
INSERT INTO tblSparePart3 (id, name, sellingPrice, description, unit, specification, applicableCar, warranty, status)
SELECT 5, 'Dầu động cơ tổng hợp 0W-20', 320000, 'Dầu bôi trơn động cơ xăng tổng hợp.', 'Lít', 'SAE 0W-20, API SP', 'Theo khuyến cáo của nhà sản xuất', 0, 'ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM tblSparePart3 WHERE id=5 AND name='Dầu động cơ tổng hợp 0W-20' AND sellingPrice=320000 AND description='Dầu bôi trơn động cơ xăng tổng hợp.' AND unit='Lít' AND specification='SAE 0W-20, API SP' AND applicableCar='Theo khuyến cáo của nhà sản xuất' AND warranty=0 AND status='ACTIVE');
INSERT INTO tblSparePart3 (id, name, sellingPrice, description, unit, specification, applicableCar, warranty, status)
SELECT 6, 'Lọc dầu động cơ Toyota', 180000, 'Lọc dầu thay thế trong bảo dưỡng định kỳ.', 'Cái', 'Lọc dầu theo mã động cơ', 'Toyota Vios, Corolla Cross phù hợp mã', 0, 'ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM tblSparePart3 WHERE id=6 AND name='Lọc dầu động cơ Toyota' AND sellingPrice=180000 AND description='Lọc dầu thay thế trong bảo dưỡng định kỳ.' AND unit='Cái' AND specification='Lọc dầu theo mã động cơ' AND applicableCar='Toyota Vios, Corolla Cross phù hợp mã' AND warranty=0 AND status='ACTIVE');
INSERT INTO tblSparePart3 (id, name, sellingPrice, description, unit, specification, applicableCar, warranty, status)
SELECT 7, 'Má phanh trước', 1250000, 'Bộ má phanh thay thế cho hai bánh trước.', 'Bộ', 'Một bộ gồm bốn má phanh', 'Theo mã phụ tùng của từng dòng xe', 6, 'ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM tblSparePart3 WHERE id=7 AND name='Má phanh trước' AND sellingPrice=1250000 AND description='Bộ má phanh thay thế cho hai bánh trước.' AND unit='Bộ' AND specification='Một bộ gồm bốn má phanh' AND applicableCar='Theo mã phụ tùng của từng dòng xe' AND warranty=6 AND status='ACTIVE');
INSERT INTO tblSparePart3 (id, name, sellingPrice, description, unit, specification, applicableCar, warranty, status)
SELECT 8, 'Dung dịch vệ sinh điều hòa', 220000, 'Dung dịch vệ sinh giàn lạnh điều hòa ô tô.', 'Chai', 'Dung tích 500 ml', 'Các dòng xe ô tô', 0, 'ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM tblSparePart3 WHERE id=8 AND name='Dung dịch vệ sinh điều hòa' AND sellingPrice=220000 AND description='Dung dịch vệ sinh giàn lạnh điều hòa ô tô.' AND unit='Chai' AND specification='Dung tích 500 ml' AND applicableCar='Các dòng xe ô tô' AND warranty=0 AND status='ACTIVE');
INSERT INTO tblSparePart3 (id, name, sellingPrice, description, unit, specification, applicableCar, warranty, status)
SELECT 9, 'Lốp ô tô 205/55R16', 1950000, 'Lốp thay thế đúng kích thước ghi trên xe.', 'Cái', '205/55R16', 'Theo kích thước lốp được nhà sản xuất cho phép', 12, 'ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM tblSparePart3 WHERE id=9 AND name='Lốp ô tô 205/55R16' AND sellingPrice=1950000 AND description='Lốp thay thế đúng kích thước ghi trên xe.' AND unit='Cái' AND specification='205/55R16' AND applicableCar='Theo kích thước lốp được nhà sản xuất cho phép' AND warranty=12 AND status='ACTIVE');
INSERT INTO tblSparePart3 (id, name, sellingPrice, description, unit, specification, applicableCar, warranty, status)
SELECT 10, 'Ắc quy 12V 60Ah', 1850000, 'Bình ắc quy khởi động kín khí.', 'Bình', '12V, 60Ah', 'Theo kích thước và cọc bình của xe', 12, 'ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM tblSparePart3 WHERE id=10 AND name='Ắc quy 12V 60Ah' AND sellingPrice=1850000 AND description='Bình ắc quy khởi động kín khí.' AND unit='Bình' AND specification='12V, 60Ah' AND applicableCar='Theo kích thước và cọc bình của xe' AND warranty=12 AND status='ACTIVE');
INSERT INTO tblSparePart3 (id, name, sellingPrice, description, unit, specification, applicableCar, warranty, status)
SELECT 11, 'Nước làm mát động cơ', 180000, 'Nước làm mát pha sẵn cho hệ thống động cơ.', 'Lít', 'Dung dịch pha sẵn, theo tiêu chuẩn xe', 'Theo khuyến cáo của nhà sản xuất', 0, 'ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM tblSparePart3 WHERE id=11 AND name='Nước làm mát động cơ' AND sellingPrice=180000 AND description='Nước làm mát pha sẵn cho hệ thống động cơ.' AND unit='Lít' AND specification='Dung dịch pha sẵn, theo tiêu chuẩn xe' AND applicableCar='Theo khuyến cáo của nhà sản xuất' AND warranty=0 AND status='ACTIVE');
INSERT INTO tblSparePart3 (id, name, sellingPrice, description, unit, specification, applicableCar, warranty, status)
SELECT 12, 'Bugi bạch kim', 280000, 'Bugi đánh lửa thay thế cho động cơ xăng.', 'Cái', 'Bugi bạch kim theo mã động cơ', 'Theo mã phụ tùng của từng dòng xe', 6, 'ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM tblSparePart3 WHERE id=12 AND name='Bugi bạch kim' AND sellingPrice=280000 AND description='Bugi đánh lửa thay thế cho động cơ xăng.' AND unit='Cái' AND specification='Bugi bạch kim theo mã động cơ' AND applicableCar='Theo mã phụ tùng của từng dòng xe' AND warranty=6 AND status='ACTIVE');
INSERT INTO tblSparePart3 (id, name, sellingPrice, description, unit, specification, applicableCar, warranty, status)
SELECT 13, 'Lọc gió điều hòa', 350000, 'Lọc bụi và tạp chất trong không khí vào cabin.', 'Cái', 'Lọc cabin theo kích thước xe', 'Theo mã phụ tùng của từng dòng xe', 0, 'ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM tblSparePart3 WHERE id=13 AND name='Lọc gió điều hòa' AND sellingPrice=350000 AND description='Lọc bụi và tạp chất trong không khí vào cabin.' AND unit='Cái' AND specification='Lọc cabin theo kích thước xe' AND applicableCar='Theo mã phụ tùng của từng dòng xe' AND warranty=0 AND status='ACTIVE');
INSERT INTO tblSparePart3 (id, name, sellingPrice, description, unit, specification, applicableCar, warranty, status)
SELECT 14, 'Cảm biến áp suất lốp', 850000, 'Cảm biến thay thế, hiện tạm hết hàng.', 'Cái', 'Cảm biến TPMS, cần lập trình theo xe', 'Theo mã và tần số tương thích', 12, 'ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM tblSparePart3 WHERE id=14 AND name='Cảm biến áp suất lốp' AND sellingPrice=850000 AND description='Cảm biến thay thế, hiện tạm hết hàng.' AND unit='Cái' AND specification='Cảm biến TPMS, cần lập trình theo xe' AND applicableCar='Theo mã và tần số tương thích' AND warranty=12 AND status='ACTIVE');

-- Six additional customers
INSERT INTO tblCustomer3 (id, fullName, address, phone, customerType)
SELECT 4, 'Đặng Minh Đức', 'Long Biên, Hà Nội', '0903001001', 'REGULAR'
WHERE NOT EXISTS (SELECT 1 FROM tblCustomer3 WHERE id=4 AND fullName='Đặng Minh Đức' AND address='Long Biên, Hà Nội' AND phone='0903001001' AND customerType='REGULAR');
INSERT INTO tblCustomer3 (id, fullName, address, phone, customerType)
SELECT 5, 'Phạm Thu Hà', 'Cầu Giấy, Hà Nội', '0903001002', 'REGULAR'
WHERE NOT EXISTS (SELECT 1 FROM tblCustomer3 WHERE id=5 AND fullName='Phạm Thu Hà' AND address='Cầu Giấy, Hà Nội' AND phone='0903001002' AND customerType='REGULAR');
INSERT INTO tblCustomer3 (id, fullName, address, phone, customerType)
SELECT 6, 'Nguyễn Hoàng Long', 'Thanh Xuân, Hà Nội', '0903001003', 'REGULAR'
WHERE NOT EXISTS (SELECT 1 FROM tblCustomer3 WHERE id=6 AND fullName='Nguyễn Hoàng Long' AND address='Thanh Xuân, Hà Nội' AND phone='0903001003' AND customerType='REGULAR');
INSERT INTO tblCustomer3 (id, fullName, address, phone, customerType)
SELECT 7, 'Vũ Thanh Tùng', 'Gia Lâm, Hà Nội', '0903001004', 'REGULAR'
WHERE NOT EXISTS (SELECT 1 FROM tblCustomer3 WHERE id=7 AND fullName='Vũ Thanh Tùng' AND address='Gia Lâm, Hà Nội' AND phone='0903001004' AND customerType='REGULAR');
INSERT INTO tblCustomer3 (id, fullName, address, phone, customerType)
SELECT 8, 'Trần Ngọc Mai', 'Hà Đông, Hà Nội', '0903001005', 'REGULAR'
WHERE NOT EXISTS (SELECT 1 FROM tblCustomer3 WHERE id=8 AND fullName='Trần Ngọc Mai' AND address='Hà Đông, Hà Nội' AND phone='0903001005' AND customerType='REGULAR');
INSERT INTO tblCustomer3 (id, fullName, address, phone, customerType)
SELECT 9, 'Hoàng Quốc Bảo', 'Hoàng Mai, Hà Nội', '0903001006', 'REGULAR'
WHERE NOT EXISTS (SELECT 1 FROM tblCustomer3 WHERE id=9 AND fullName='Hoàng Quốc Bảo' AND address='Hoàng Mai, Hà Nội' AND phone='0903001006' AND customerType='REGULAR');

-- Each car belongs to its invoice customer
INSERT INTO tblCar3 (id, licensePlate, brand, model, `year`, tblCustomer3id)
SELECT 4, '30K-201.36', 'Toyota', 'Corolla Cross', 2022, 4
WHERE NOT EXISTS (SELECT 1 FROM tblCar3 WHERE id=4 AND licensePlate='30K-201.36' AND brand='Toyota' AND model='Corolla Cross' AND `year`=2022 AND tblCustomer3id=4);
INSERT INTO tblCar3 (id, licensePlate, brand, model, `year`, tblCustomer3id)
SELECT 5, '30H-482.59', 'Honda', 'CR-V', 2021, 5
WHERE NOT EXISTS (SELECT 1 FROM tblCar3 WHERE id=5 AND licensePlate='30H-482.59' AND brand='Honda' AND model='CR-V' AND `year`=2021 AND tblCustomer3id=5);
INSERT INTO tblCar3 (id, licensePlate, brand, model, `year`, tblCustomer3id)
SELECT 6, '30G-643.82', 'Mazda', 'Mazda3', 2020, 6
WHERE NOT EXISTS (SELECT 1 FROM tblCar3 WHERE id=6 AND licensePlate='30G-643.82' AND brand='Mazda' AND model='Mazda3' AND `year`=2020 AND tblCustomer3id=6);
INSERT INTO tblCar3 (id, licensePlate, brand, model, `year`, tblCustomer3id)
SELECT 7, '29H-762.14', 'Ford', 'Ranger', 2021, 7
WHERE NOT EXISTS (SELECT 1 FROM tblCar3 WHERE id=7 AND licensePlate='29H-762.14' AND brand='Ford' AND model='Ranger' AND `year`=2021 AND tblCustomer3id=7);
INSERT INTO tblCar3 (id, licensePlate, brand, model, `year`, tblCustomer3id)
SELECT 8, '30L-135.68', 'Kia', 'Seltos', 2023, 8
WHERE NOT EXISTS (SELECT 1 FROM tblCar3 WHERE id=8 AND licensePlate='30L-135.68' AND brand='Kia' AND model='Seltos' AND `year`=2023 AND tblCustomer3id=8);
INSERT INTO tblCar3 (id, licensePlate, brand, model, `year`, tblCustomer3id)
SELECT 9, '30F-579.26', 'Hyundai', 'Tucson', 2019, 9
WHERE NOT EXISTS (SELECT 1 FROM tblCar3 WHERE id=9 AND licensePlate='30F-579.26' AND brand='Hyundai' AND model='Tucson' AND `year`=2019 AND tblCustomer3id=9);

-- Received imports precede all new consumption; pending import does not count as stock
INSERT INTO tblImportReceipt3 (id, importDate, status, tblWarehouse3id, tblSupplier3id, tblMember3id)
SELECT 2, '2026-06-01 08:00:00', 'RECEIVED', 2, 2, 3
WHERE NOT EXISTS (SELECT 1 FROM tblImportReceipt3 WHERE id=2 AND importDate='2026-06-01 08:00:00' AND status='RECEIVED' AND tblWarehouse3id=2 AND tblSupplier3id=2 AND tblMember3id=3);
INSERT INTO tblImportReceipt3 (id, importDate, status, tblWarehouse3id, tblSupplier3id, tblMember3id)
SELECT 3, '2026-06-02 09:00:00', 'RECEIVED', 2, 3, 3
WHERE NOT EXISTS (SELECT 1 FROM tblImportReceipt3 WHERE id=3 AND importDate='2026-06-02 09:00:00' AND status='RECEIVED' AND tblWarehouse3id=2 AND tblSupplier3id=3 AND tblMember3id=3);
INSERT INTO tblImportReceipt3 (id, importDate, status, tblWarehouse3id, tblSupplier3id, tblMember3id)
SELECT 4, '2026-06-02 14:00:00', 'RECEIVED', 2, 4, 3
WHERE NOT EXISTS (SELECT 1 FROM tblImportReceipt3 WHERE id=4 AND importDate='2026-06-02 14:00:00' AND status='RECEIVED' AND tblWarehouse3id=2 AND tblSupplier3id=4 AND tblMember3id=3);
INSERT INTO tblImportReceipt3 (id, importDate, status, tblWarehouse3id, tblSupplier3id, tblMember3id)
SELECT 5, '2026-07-28 10:00:00', 'PENDING', 2, 4, 3
WHERE NOT EXISTS (SELECT 1 FROM tblImportReceipt3 WHERE id=5 AND importDate='2026-07-28 10:00:00' AND status='PENDING' AND tblWarehouse3id=2 AND tblSupplier3id=4 AND tblMember3id=3);

-- Historical purchase prices
INSERT INTO tblImportDetail3 (id, quantity, importPrice, tblImportReceipt3id, tblSparePart3id)
SELECT 4, 120, 220000, 2, 5
WHERE NOT EXISTS (SELECT 1 FROM tblImportDetail3 WHERE id=4 AND quantity=120 AND importPrice=220000 AND tblImportReceipt3id=2 AND tblSparePart3id=5);
INSERT INTO tblImportDetail3 (id, quantity, importPrice, tblImportReceipt3id, tblSparePart3id)
SELECT 5, 30, 110000, 2, 6
WHERE NOT EXISTS (SELECT 1 FROM tblImportDetail3 WHERE id=5 AND quantity=30 AND importPrice=110000 AND tblImportReceipt3id=2 AND tblSparePart3id=6);
INSERT INTO tblImportDetail3 (id, quantity, importPrice, tblImportReceipt3id, tblSparePart3id)
SELECT 6, 20, 850000, 2, 7
WHERE NOT EXISTS (SELECT 1 FROM tblImportDetail3 WHERE id=6 AND quantity=20 AND importPrice=850000 AND tblImportReceipt3id=2 AND tblSparePart3id=7);
INSERT INTO tblImportDetail3 (id, quantity, importPrice, tblImportReceipt3id, tblSparePart3id)
SELECT 7, 24, 150000, 3, 8
WHERE NOT EXISTS (SELECT 1 FROM tblImportDetail3 WHERE id=7 AND quantity=24 AND importPrice=150000 AND tblImportReceipt3id=3 AND tblSparePart3id=8);
INSERT INTO tblImportDetail3 (id, quantity, importPrice, tblImportReceipt3id, tblSparePart3id)
SELECT 8, 80, 110000, 3, 11
WHERE NOT EXISTS (SELECT 1 FROM tblImportDetail3 WHERE id=8 AND quantity=80 AND importPrice=110000 AND tblImportReceipt3id=3 AND tblSparePart3id=11);
INSERT INTO tblImportDetail3 (id, quantity, importPrice, tblImportReceipt3id, tblSparePart3id)
SELECT 9, 40, 190000, 3, 12
WHERE NOT EXISTS (SELECT 1 FROM tblImportDetail3 WHERE id=9 AND quantity=40 AND importPrice=190000 AND tblImportReceipt3id=3 AND tblSparePart3id=12);
INSERT INTO tblImportDetail3 (id, quantity, importPrice, tblImportReceipt3id, tblSparePart3id)
SELECT 10, 20, 230000, 3, 13
WHERE NOT EXISTS (SELECT 1 FROM tblImportDetail3 WHERE id=10 AND quantity=20 AND importPrice=230000 AND tblImportReceipt3id=3 AND tblSparePart3id=13);
INSERT INTO tblImportDetail3 (id, quantity, importPrice, tblImportReceipt3id, tblSparePart3id)
SELECT 11, 24, 1350000, 4, 9
WHERE NOT EXISTS (SELECT 1 FROM tblImportDetail3 WHERE id=11 AND quantity=24 AND importPrice=1350000 AND tblImportReceipt3id=4 AND tblSparePart3id=9);
INSERT INTO tblImportDetail3 (id, quantity, importPrice, tblImportReceipt3id, tblSparePart3id)
SELECT 12, 12, 1300000, 4, 10
WHERE NOT EXISTS (SELECT 1 FROM tblImportDetail3 WHERE id=12 AND quantity=12 AND importPrice=1300000 AND tblImportReceipt3id=4 AND tblSparePart3id=10);
INSERT INTO tblImportDetail3 (id, quantity, importPrice, tblImportReceipt3id, tblSparePart3id)
SELECT 13, 4, 1300000, 5, 10
WHERE NOT EXISTS (SELECT 1 FROM tblImportDetail3 WHERE id=13 AND quantity=4 AND importPrice=1300000 AND tblImportReceipt3id=5 AND tblSparePart3id=10);

-- Reference quantities used by service-detail pages
INSERT INTO tblServicePart3 (id, quantity, tblService3id, tblSparePart3id)
SELECT 5, 4, 5, 5
WHERE NOT EXISTS (SELECT 1 FROM tblServicePart3 WHERE id=5 AND quantity=4 AND tblService3id=5 AND tblSparePart3id=5);
INSERT INTO tblServicePart3 (id, quantity, tblService3id, tblSparePart3id)
SELECT 6, 1, 5, 6
WHERE NOT EXISTS (SELECT 1 FROM tblServicePart3 WHERE id=6 AND quantity=1 AND tblService3id=5 AND tblSparePart3id=6);
INSERT INTO tblServicePart3 (id, quantity, tblService3id, tblSparePart3id)
SELECT 7, 1, 6, 7
WHERE NOT EXISTS (SELECT 1 FROM tblServicePart3 WHERE id=7 AND quantity=1 AND tblService3id=6 AND tblSparePart3id=7);
INSERT INTO tblServicePart3 (id, quantity, tblService3id, tblSparePart3id)
SELECT 8, 1, 7, 8
WHERE NOT EXISTS (SELECT 1 FROM tblServicePart3 WHERE id=8 AND quantity=1 AND tblService3id=7 AND tblSparePart3id=8);
INSERT INTO tblServicePart3 (id, quantity, tblService3id, tblSparePart3id)
SELECT 9, 1, 7, 13
WHERE NOT EXISTS (SELECT 1 FROM tblServicePart3 WHERE id=9 AND quantity=1 AND tblService3id=7 AND tblSparePart3id=13);
INSERT INTO tblServicePart3 (id, quantity, tblService3id, tblSparePart3id)
SELECT 10, 1, 9, 10
WHERE NOT EXISTS (SELECT 1 FROM tblServicePart3 WHERE id=10 AND quantity=1 AND tblService3id=9 AND tblSparePart3id=10);
INSERT INTO tblServicePart3 (id, quantity, tblService3id, tblSparePart3id)
SELECT 11, 6, 10, 11
WHERE NOT EXISTS (SELECT 1 FROM tblServicePart3 WHERE id=11 AND quantity=6 AND tblService3id=10 AND tblSparePart3id=11);
INSERT INTO tblServicePart3 (id, quantity, tblService3id, tblSparePart3id)
SELECT 12, 4, 11, 12
WHERE NOT EXISTS (SELECT 1 FROM tblServicePart3 WHERE id=12 AND quantity=4 AND tblService3id=11 AND tblSparePart3id=12);

-- Fourteen paid visits in June-July only; unpaid and cancelled are excluded from revenue
INSERT INTO tblInvoice3 (id, createdDate, paymentDate, status, requestDescription, paymentMethod, tblCustomer3id, tblCar3id, tblMember3id)
SELECT 8, '2026-06-04 08:30:00', '2026-06-04 15:00:00', 'PAID', 'Thay dầu và lọc dầu định kỳ.', 'CASH', 4, 4, 2
WHERE NOT EXISTS (SELECT 1 FROM tblInvoice3 WHERE id=8 AND createdDate='2026-06-04 08:30:00' AND paymentDate='2026-06-04 15:00:00' AND status='PAID' AND requestDescription='Thay dầu và lọc dầu định kỳ.' AND paymentMethod='CASH' AND tblCustomer3id=4 AND tblCar3id=4 AND tblMember3id=2);
INSERT INTO tblInvoice3 (id, createdDate, paymentDate, status, requestDescription, paymentMethod, tblCustomer3id, tblCar3id, tblMember3id)
SELECT 9, '2026-06-07 08:30:00', '2026-06-07 15:00:00', 'PAID', 'Vệ sinh điều hòa, thay lọc gió cabin.', 'BANK_TRANSFER', 5, 5, 2
WHERE NOT EXISTS (SELECT 1 FROM tblInvoice3 WHERE id=9 AND createdDate='2026-06-07 08:30:00' AND paymentDate='2026-06-07 15:00:00' AND status='PAID' AND requestDescription='Vệ sinh điều hòa, thay lọc gió cabin.' AND paymentMethod='BANK_TRANSFER' AND tblCustomer3id=5 AND tblCar3id=5 AND tblMember3id=2);
INSERT INTO tblInvoice3 (id, createdDate, paymentDate, status, requestDescription, paymentMethod, tblCustomer3id, tblCar3id, tblMember3id)
SELECT 10, '2026-06-10 08:30:00', '2026-06-10 15:00:00', 'PAID', 'Kiểm tra phanh và thay bộ má phanh trước.', 'CASH', 6, 6, 2
WHERE NOT EXISTS (SELECT 1 FROM tblInvoice3 WHERE id=10 AND createdDate='2026-06-10 08:30:00' AND paymentDate='2026-06-10 15:00:00' AND status='PAID' AND requestDescription='Kiểm tra phanh và thay bộ má phanh trước.' AND paymentMethod='CASH' AND tblCustomer3id=6 AND tblCar3id=6 AND tblMember3id=2);
INSERT INTO tblInvoice3 (id, createdDate, paymentDate, status, requestDescription, paymentMethod, tblCustomer3id, tblCar3id, tblMember3id)
SELECT 11, '2026-06-12 08:30:00', '2026-06-12 15:00:00', 'PAID', 'Cân chỉnh góc đặt bánh xe và đảo lốp.', 'BANK_TRANSFER', 7, 7, 2
WHERE NOT EXISTS (SELECT 1 FROM tblInvoice3 WHERE id=11 AND createdDate='2026-06-12 08:30:00' AND paymentDate='2026-06-12 15:00:00' AND status='PAID' AND requestDescription='Cân chỉnh góc đặt bánh xe và đảo lốp.' AND paymentMethod='BANK_TRANSFER' AND tblCustomer3id=7 AND tblCar3id=7 AND tblMember3id=2);
INSERT INTO tblInvoice3 (id, createdDate, paymentDate, status, requestDescription, paymentMethod, tblCustomer3id, tblCar3id, tblMember3id)
SELECT 12, '2026-06-15 08:30:00', '2026-06-15 15:00:00', 'PAID', 'Ắc quy yếu, kiểm tra sạc và thay bình mới.', 'CASH', 8, 8, 2
WHERE NOT EXISTS (SELECT 1 FROM tblInvoice3 WHERE id=12 AND createdDate='2026-06-15 08:30:00' AND paymentDate='2026-06-15 15:00:00' AND status='PAID' AND requestDescription='Ắc quy yếu, kiểm tra sạc và thay bình mới.' AND paymentMethod='CASH' AND tblCustomer3id=8 AND tblCar3id=8 AND tblMember3id=2);
INSERT INTO tblInvoice3 (id, createdDate, paymentDate, status, requestDescription, paymentMethod, tblCustomer3id, tblCar3id, tblMember3id)
SELECT 13, '2026-06-18 08:30:00', '2026-06-18 15:00:00', 'PAID', 'Thay nước làm mát và kiểm tra rò rỉ.', 'BANK_TRANSFER', 9, 9, 2
WHERE NOT EXISTS (SELECT 1 FROM tblInvoice3 WHERE id=13 AND createdDate='2026-06-18 08:30:00' AND paymentDate='2026-06-18 15:00:00' AND status='PAID' AND requestDescription='Thay nước làm mát và kiểm tra rò rỉ.' AND paymentMethod='BANK_TRANSFER' AND tblCustomer3id=9 AND tblCar3id=9 AND tblMember3id=2);
INSERT INTO tblInvoice3 (id, createdDate, paymentDate, status, requestDescription, paymentMethod, tblCustomer3id, tblCar3id, tblMember3id)
SELECT 14, '2026-06-24 08:30:00', '2026-06-24 15:00:00', 'PAID', 'Thay bugi và vệ sinh điều hòa.', 'CASH', 4, 4, 2
WHERE NOT EXISTS (SELECT 1 FROM tblInvoice3 WHERE id=14 AND createdDate='2026-06-24 08:30:00' AND paymentDate='2026-06-24 15:00:00' AND status='PAID' AND requestDescription='Thay bugi và vệ sinh điều hòa.' AND paymentMethod='CASH' AND tblCustomer3id=4 AND tblCar3id=4 AND tblMember3id=2);
INSERT INTO tblInvoice3 (id, createdDate, paymentDate, status, requestDescription, paymentMethod, tblCustomer3id, tblCar3id, tblMember3id)
SELECT 15, '2026-07-03 08:30:00', '2026-07-03 15:00:00', 'PAID', 'Bảo dưỡng phanh, thay nước làm mát.', 'BANK_TRANSFER', 5, 5, 2
WHERE NOT EXISTS (SELECT 1 FROM tblInvoice3 WHERE id=15 AND createdDate='2026-07-03 08:30:00' AND paymentDate='2026-07-03 15:00:00' AND status='PAID' AND requestDescription='Bảo dưỡng phanh, thay nước làm mát.' AND paymentMethod='BANK_TRANSFER' AND tblCustomer3id=5 AND tblCar3id=5 AND tblMember3id=2);
INSERT INTO tblInvoice3 (id, createdDate, paymentDate, status, requestDescription, paymentMethod, tblCustomer3id, tblCar3id, tblMember3id)
SELECT 16, '2026-07-06 08:30:00', '2026-07-06 15:00:00', 'PAID', 'Thay dầu động cơ.', 'CASH', 6, 6, 2
WHERE NOT EXISTS (SELECT 1 FROM tblInvoice3 WHERE id=16 AND createdDate='2026-07-06 08:30:00' AND paymentDate='2026-07-06 15:00:00' AND status='PAID' AND requestDescription='Thay dầu động cơ.' AND paymentMethod='CASH' AND tblCustomer3id=6 AND tblCar3id=6 AND tblMember3id=2);
INSERT INTO tblInvoice3 (id, createdDate, paymentDate, status, requestDescription, paymentMethod, tblCustomer3id, tblCar3id, tblMember3id)
SELECT 17, '2026-07-09 08:30:00', '2026-07-09 15:00:00', 'PAID', 'Thay hai lốp và cân chỉnh góc đặt bánh xe.', 'BANK_TRANSFER', 7, 7, 2
WHERE NOT EXISTS (SELECT 1 FROM tblInvoice3 WHERE id=17 AND createdDate='2026-07-09 08:30:00' AND paymentDate='2026-07-09 15:00:00' AND status='PAID' AND requestDescription='Thay hai lốp và cân chỉnh góc đặt bánh xe.' AND paymentMethod='BANK_TRANSFER' AND tblCustomer3id=7 AND tblCar3id=7 AND tblMember3id=2);
INSERT INTO tblInvoice3 (id, createdDate, paymentDate, status, requestDescription, paymentMethod, tblCustomer3id, tblCar3id, tblMember3id)
SELECT 18, '2026-07-13 08:30:00', '2026-07-13 15:00:00', 'PAID', 'Vệ sinh điều hòa và đảo lốp.', 'CASH', 8, 8, 2
WHERE NOT EXISTS (SELECT 1 FROM tblInvoice3 WHERE id=18 AND createdDate='2026-07-13 08:30:00' AND paymentDate='2026-07-13 15:00:00' AND status='PAID' AND requestDescription='Vệ sinh điều hòa và đảo lốp.' AND paymentMethod='CASH' AND tblCustomer3id=8 AND tblCar3id=8 AND tblMember3id=2);
INSERT INTO tblInvoice3 (id, createdDate, paymentDate, status, requestDescription, paymentMethod, tblCustomer3id, tblCar3id, tblMember3id)
SELECT 19, '2026-07-17 08:30:00', '2026-07-17 15:00:00', 'PAID', 'Thay dầu và kiểm tra phanh.', 'BANK_TRANSFER', 9, 9, 2
WHERE NOT EXISTS (SELECT 1 FROM tblInvoice3 WHERE id=19 AND createdDate='2026-07-17 08:30:00' AND paymentDate='2026-07-17 15:00:00' AND status='PAID' AND requestDescription='Thay dầu và kiểm tra phanh.' AND paymentMethod='BANK_TRANSFER' AND tblCustomer3id=9 AND tblCar3id=9 AND tblMember3id=2);
INSERT INTO tblInvoice3 (id, createdDate, paymentDate, status, requestDescription, paymentMethod, tblCustomer3id, tblCar3id, tblMember3id)
SELECT 20, '2026-07-22 08:30:00', '2026-07-22 15:00:00', 'PAID', 'Thay hai lốp và cân bằng động.', 'CASH', 4, 4, 2
WHERE NOT EXISTS (SELECT 1 FROM tblInvoice3 WHERE id=20 AND createdDate='2026-07-22 08:30:00' AND paymentDate='2026-07-22 15:00:00' AND status='PAID' AND requestDescription='Thay hai lốp và cân bằng động.' AND paymentMethod='CASH' AND tblCustomer3id=4 AND tblCar3id=4 AND tblMember3id=2);
INSERT INTO tblInvoice3 (id, createdDate, paymentDate, status, requestDescription, paymentMethod, tblCustomer3id, tblCar3id, tblMember3id)
SELECT 21, '2026-07-25 08:30:00', '2026-07-25 15:00:00', 'PAID', 'Thay bugi định kỳ và nước làm mát.', 'BANK_TRANSFER', 5, 5, 2
WHERE NOT EXISTS (SELECT 1 FROM tblInvoice3 WHERE id=21 AND createdDate='2026-07-25 08:30:00' AND paymentDate='2026-07-25 15:00:00' AND status='PAID' AND requestDescription='Thay bugi định kỳ và nước làm mát.' AND paymentMethod='BANK_TRANSFER' AND tblCustomer3id=5 AND tblCar3id=5 AND tblMember3id=2);
INSERT INTO tblInvoice3 (id, createdDate, paymentDate, status, requestDescription, paymentMethod, tblCustomer3id, tblCar3id, tblMember3id)
SELECT 22, '2026-07-28 08:30:00', NULL, 'UNPAID', 'Đã tiếp nhận thay ắc quy, chờ thanh toán.', NULL, 9, 9, 2
WHERE NOT EXISTS (SELECT 1 FROM tblInvoice3 WHERE id=22 AND createdDate='2026-07-28 08:30:00' AND paymentDate IS NULL AND status='UNPAID' AND requestDescription='Đã tiếp nhận thay ắc quy, chờ thanh toán.' AND paymentMethod IS NULL AND tblCustomer3id=9 AND tblCar3id=9 AND tblMember3id=2);
INSERT INTO tblInvoice3 (id, createdDate, paymentDate, status, requestDescription, paymentMethod, tblCustomer3id, tblCar3id, tblMember3id)
SELECT 23, '2026-07-29 08:30:00', NULL, 'CANCELLED', 'Khách hủy yêu cầu thay má phanh trước khi thực hiện.', NULL, 6, 6, 2
WHERE NOT EXISTS (SELECT 1 FROM tblInvoice3 WHERE id=23 AND createdDate='2026-07-29 08:30:00' AND paymentDate IS NULL AND status='CANCELLED' AND requestDescription='Khách hủy yêu cầu thay má phanh trước khi thực hiện.' AND paymentMethod IS NULL AND tblCustomer3id=6 AND tblCar3id=6 AND tblMember3id=2);

-- Service lines preserve their historical labor prices
INSERT INTO tblInvoiceService3 (id, quantity, price, technician, workStatus, tblInvoice3id, tblService3id)
SELECT 6, 1, 150000, 'Nguyễn Văn K', 'COMPLETED', 8, 5
WHERE NOT EXISTS (SELECT 1 FROM tblInvoiceService3 WHERE id=6 AND quantity=1 AND price=150000 AND technician='Nguyễn Văn K' AND workStatus='COMPLETED' AND tblInvoice3id=8 AND tblService3id=5);
INSERT INTO tblInvoiceService3 (id, quantity, price, technician, workStatus, tblInvoice3id, tblService3id)
SELECT 7, 1, 650000, 'Trần Văn H', 'COMPLETED', 9, 7
WHERE NOT EXISTS (SELECT 1 FROM tblInvoiceService3 WHERE id=7 AND quantity=1 AND price=650000 AND technician='Trần Văn H' AND workStatus='COMPLETED' AND tblInvoice3id=9 AND tblService3id=7);
INSERT INTO tblInvoiceService3 (id, quantity, price, technician, workStatus, tblInvoice3id, tblService3id)
SELECT 8, 1, 450000, 'Nguyễn Văn K', 'COMPLETED', 10, 6
WHERE NOT EXISTS (SELECT 1 FROM tblInvoiceService3 WHERE id=8 AND quantity=1 AND price=450000 AND technician='Nguyễn Văn K' AND workStatus='COMPLETED' AND tblInvoice3id=10 AND tblService3id=6);
INSERT INTO tblInvoiceService3 (id, quantity, price, technician, workStatus, tblInvoice3id, tblService3id)
SELECT 9, 1, 500000, 'Trần Văn H', 'COMPLETED', 11, 8
WHERE NOT EXISTS (SELECT 1 FROM tblInvoiceService3 WHERE id=9 AND quantity=1 AND price=500000 AND technician='Trần Văn H' AND workStatus='COMPLETED' AND tblInvoice3id=11 AND tblService3id=8);
INSERT INTO tblInvoiceService3 (id, quantity, price, technician, workStatus, tblInvoice3id, tblService3id)
SELECT 10, 1, 350000, 'Trần Văn H', 'COMPLETED', 11, 12
WHERE NOT EXISTS (SELECT 1 FROM tblInvoiceService3 WHERE id=10 AND quantity=1 AND price=350000 AND technician='Trần Văn H' AND workStatus='COMPLETED' AND tblInvoice3id=11 AND tblService3id=12);
INSERT INTO tblInvoiceService3 (id, quantity, price, technician, workStatus, tblInvoice3id, tblService3id)
SELECT 11, 1, 120000, 'Nguyễn Văn K', 'COMPLETED', 12, 9
WHERE NOT EXISTS (SELECT 1 FROM tblInvoiceService3 WHERE id=11 AND quantity=1 AND price=120000 AND technician='Nguyễn Văn K' AND workStatus='COMPLETED' AND tblInvoice3id=12 AND tblService3id=9);
INSERT INTO tblInvoiceService3 (id, quantity, price, technician, workStatus, tblInvoice3id, tblService3id)
SELECT 12, 1, 250000, 'Trần Văn H', 'COMPLETED', 13, 10
WHERE NOT EXISTS (SELECT 1 FROM tblInvoiceService3 WHERE id=12 AND quantity=1 AND price=250000 AND technician='Trần Văn H' AND workStatus='COMPLETED' AND tblInvoice3id=13 AND tblService3id=10);
INSERT INTO tblInvoiceService3 (id, quantity, price, technician, workStatus, tblInvoice3id, tblService3id)
SELECT 13, 1, 300000, 'Nguyễn Văn K', 'COMPLETED', 14, 11
WHERE NOT EXISTS (SELECT 1 FROM tblInvoiceService3 WHERE id=13 AND quantity=1 AND price=300000 AND technician='Nguyễn Văn K' AND workStatus='COMPLETED' AND tblInvoice3id=14 AND tblService3id=11);
INSERT INTO tblInvoiceService3 (id, quantity, price, technician, workStatus, tblInvoice3id, tblService3id)
SELECT 14, 1, 650000, 'Nguyễn Văn K', 'COMPLETED', 14, 7
WHERE NOT EXISTS (SELECT 1 FROM tblInvoiceService3 WHERE id=14 AND quantity=1 AND price=650000 AND technician='Nguyễn Văn K' AND workStatus='COMPLETED' AND tblInvoice3id=14 AND tblService3id=7);
INSERT INTO tblInvoiceService3 (id, quantity, price, technician, workStatus, tblInvoice3id, tblService3id)
SELECT 15, 1, 450000, 'Trần Văn H', 'COMPLETED', 15, 6
WHERE NOT EXISTS (SELECT 1 FROM tblInvoiceService3 WHERE id=15 AND quantity=1 AND price=450000 AND technician='Trần Văn H' AND workStatus='COMPLETED' AND tblInvoice3id=15 AND tblService3id=6);
INSERT INTO tblInvoiceService3 (id, quantity, price, technician, workStatus, tblInvoice3id, tblService3id)
SELECT 16, 1, 250000, 'Trần Văn H', 'COMPLETED', 15, 10
WHERE NOT EXISTS (SELECT 1 FROM tblInvoiceService3 WHERE id=16 AND quantity=1 AND price=250000 AND technician='Trần Văn H' AND workStatus='COMPLETED' AND tblInvoice3id=15 AND tblService3id=10);
INSERT INTO tblInvoiceService3 (id, quantity, price, technician, workStatus, tblInvoice3id, tblService3id)
SELECT 17, 1, 150000, 'Nguyễn Văn K', 'COMPLETED', 16, 5
WHERE NOT EXISTS (SELECT 1 FROM tblInvoiceService3 WHERE id=17 AND quantity=1 AND price=150000 AND technician='Nguyễn Văn K' AND workStatus='COMPLETED' AND tblInvoice3id=16 AND tblService3id=5);
INSERT INTO tblInvoiceService3 (id, quantity, price, technician, workStatus, tblInvoice3id, tblService3id)
SELECT 18, 1, 500000, 'Trần Văn H', 'COMPLETED', 17, 8
WHERE NOT EXISTS (SELECT 1 FROM tblInvoiceService3 WHERE id=18 AND quantity=1 AND price=500000 AND technician='Trần Văn H' AND workStatus='COMPLETED' AND tblInvoice3id=17 AND tblService3id=8);
INSERT INTO tblInvoiceService3 (id, quantity, price, technician, workStatus, tblInvoice3id, tblService3id)
SELECT 19, 1, 650000, 'Nguyễn Văn K', 'COMPLETED', 18, 7
WHERE NOT EXISTS (SELECT 1 FROM tblInvoiceService3 WHERE id=19 AND quantity=1 AND price=650000 AND technician='Nguyễn Văn K' AND workStatus='COMPLETED' AND tblInvoice3id=18 AND tblService3id=7);
INSERT INTO tblInvoiceService3 (id, quantity, price, technician, workStatus, tblInvoice3id, tblService3id)
SELECT 20, 1, 350000, 'Nguyễn Văn K', 'COMPLETED', 18, 12
WHERE NOT EXISTS (SELECT 1 FROM tblInvoiceService3 WHERE id=20 AND quantity=1 AND price=350000 AND technician='Nguyễn Văn K' AND workStatus='COMPLETED' AND tblInvoice3id=18 AND tblService3id=12);
INSERT INTO tblInvoiceService3 (id, quantity, price, technician, workStatus, tblInvoice3id, tblService3id)
SELECT 21, 1, 150000, 'Trần Văn H', 'COMPLETED', 19, 5
WHERE NOT EXISTS (SELECT 1 FROM tblInvoiceService3 WHERE id=21 AND quantity=1 AND price=150000 AND technician='Trần Văn H' AND workStatus='COMPLETED' AND tblInvoice3id=19 AND tblService3id=5);
INSERT INTO tblInvoiceService3 (id, quantity, price, technician, workStatus, tblInvoice3id, tblService3id)
SELECT 22, 1, 450000, 'Trần Văn H', 'COMPLETED', 19, 6
WHERE NOT EXISTS (SELECT 1 FROM tblInvoiceService3 WHERE id=22 AND quantity=1 AND price=450000 AND technician='Trần Văn H' AND workStatus='COMPLETED' AND tblInvoice3id=19 AND tblService3id=6);
INSERT INTO tblInvoiceService3 (id, quantity, price, technician, workStatus, tblInvoice3id, tblService3id)
SELECT 23, 1, 350000, 'Nguyễn Văn K', 'COMPLETED', 20, 12
WHERE NOT EXISTS (SELECT 1 FROM tblInvoiceService3 WHERE id=23 AND quantity=1 AND price=350000 AND technician='Nguyễn Văn K' AND workStatus='COMPLETED' AND tblInvoice3id=20 AND tblService3id=12);
INSERT INTO tblInvoiceService3 (id, quantity, price, technician, workStatus, tblInvoice3id, tblService3id)
SELECT 24, 1, 300000, 'Trần Văn H', 'COMPLETED', 21, 11
WHERE NOT EXISTS (SELECT 1 FROM tblInvoiceService3 WHERE id=24 AND quantity=1 AND price=300000 AND technician='Trần Văn H' AND workStatus='COMPLETED' AND tblInvoice3id=21 AND tblService3id=11);
INSERT INTO tblInvoiceService3 (id, quantity, price, technician, workStatus, tblInvoice3id, tblService3id)
SELECT 25, 1, 250000, 'Trần Văn H', 'COMPLETED', 21, 10
WHERE NOT EXISTS (SELECT 1 FROM tblInvoiceService3 WHERE id=25 AND quantity=1 AND price=250000 AND technician='Trần Văn H' AND workStatus='COMPLETED' AND tblInvoice3id=21 AND tblService3id=10);
INSERT INTO tblInvoiceService3 (id, quantity, price, technician, workStatus, tblInvoice3id, tblService3id)
SELECT 26, 1, 120000, 'Nguyễn Văn K', 'COMPLETED', 22, 9
WHERE NOT EXISTS (SELECT 1 FROM tblInvoiceService3 WHERE id=26 AND quantity=1 AND price=120000 AND technician='Nguyễn Văn K' AND workStatus='COMPLETED' AND tblInvoice3id=22 AND tblService3id=9);
INSERT INTO tblInvoiceService3 (id, quantity, price, technician, workStatus, tblInvoice3id, tblService3id)
SELECT 27, 1, 450000, 'Trần Văn H', 'CANCELLED', 23, 6
WHERE NOT EXISTS (SELECT 1 FROM tblInvoiceService3 WHERE id=27 AND quantity=1 AND price=450000 AND technician='Trần Văn H' AND workStatus='CANCELLED' AND tblInvoice3id=23 AND tblService3id=6);

-- Only new part IDs are consumed, preserving PT01-PT03 report stock
INSERT INTO tblInvoicePart3 (id, quantity, price, tblInvoice3id, tblSparePart3id)
SELECT 11, 4, 320000, 8, 5
WHERE NOT EXISTS (SELECT 1 FROM tblInvoicePart3 WHERE id=11 AND quantity=4 AND price=320000 AND tblInvoice3id=8 AND tblSparePart3id=5);
INSERT INTO tblInvoicePart3 (id, quantity, price, tblInvoice3id, tblSparePart3id)
SELECT 12, 1, 180000, 8, 6
WHERE NOT EXISTS (SELECT 1 FROM tblInvoicePart3 WHERE id=12 AND quantity=1 AND price=180000 AND tblInvoice3id=8 AND tblSparePart3id=6);
INSERT INTO tblInvoicePart3 (id, quantity, price, tblInvoice3id, tblSparePart3id)
SELECT 13, 1, 220000, 9, 8
WHERE NOT EXISTS (SELECT 1 FROM tblInvoicePart3 WHERE id=13 AND quantity=1 AND price=220000 AND tblInvoice3id=9 AND tblSparePart3id=8);
INSERT INTO tblInvoicePart3 (id, quantity, price, tblInvoice3id, tblSparePart3id)
SELECT 14, 1, 350000, 9, 13
WHERE NOT EXISTS (SELECT 1 FROM tblInvoicePart3 WHERE id=14 AND quantity=1 AND price=350000 AND tblInvoice3id=9 AND tblSparePart3id=13);
INSERT INTO tblInvoicePart3 (id, quantity, price, tblInvoice3id, tblSparePart3id)
SELECT 15, 1, 1250000, 10, 7
WHERE NOT EXISTS (SELECT 1 FROM tblInvoicePart3 WHERE id=15 AND quantity=1 AND price=1250000 AND tblInvoice3id=10 AND tblSparePart3id=7);
INSERT INTO tblInvoicePart3 (id, quantity, price, tblInvoice3id, tblSparePart3id)
SELECT 16, 1, 1850000, 12, 10
WHERE NOT EXISTS (SELECT 1 FROM tblInvoicePart3 WHERE id=16 AND quantity=1 AND price=1850000 AND tblInvoice3id=12 AND tblSparePart3id=10);
INSERT INTO tblInvoicePart3 (id, quantity, price, tblInvoice3id, tblSparePart3id)
SELECT 17, 6, 180000, 13, 11
WHERE NOT EXISTS (SELECT 1 FROM tblInvoicePart3 WHERE id=17 AND quantity=6 AND price=180000 AND tblInvoice3id=13 AND tblSparePart3id=11);
INSERT INTO tblInvoicePart3 (id, quantity, price, tblInvoice3id, tblSparePart3id)
SELECT 18, 4, 280000, 14, 12
WHERE NOT EXISTS (SELECT 1 FROM tblInvoicePart3 WHERE id=18 AND quantity=4 AND price=280000 AND tblInvoice3id=14 AND tblSparePart3id=12);
INSERT INTO tblInvoicePart3 (id, quantity, price, tblInvoice3id, tblSparePart3id)
SELECT 19, 1, 220000, 14, 8
WHERE NOT EXISTS (SELECT 1 FROM tblInvoicePart3 WHERE id=19 AND quantity=1 AND price=220000 AND tblInvoice3id=14 AND tblSparePart3id=8);
INSERT INTO tblInvoicePart3 (id, quantity, price, tblInvoice3id, tblSparePart3id)
SELECT 20, 1, 350000, 14, 13
WHERE NOT EXISTS (SELECT 1 FROM tblInvoicePart3 WHERE id=20 AND quantity=1 AND price=350000 AND tblInvoice3id=14 AND tblSparePart3id=13);
INSERT INTO tblInvoicePart3 (id, quantity, price, tblInvoice3id, tblSparePart3id)
SELECT 21, 1, 1250000, 15, 7
WHERE NOT EXISTS (SELECT 1 FROM tblInvoicePart3 WHERE id=21 AND quantity=1 AND price=1250000 AND tblInvoice3id=15 AND tblSparePart3id=7);
INSERT INTO tblInvoicePart3 (id, quantity, price, tblInvoice3id, tblSparePart3id)
SELECT 22, 6, 180000, 15, 11
WHERE NOT EXISTS (SELECT 1 FROM tblInvoicePart3 WHERE id=22 AND quantity=6 AND price=180000 AND tblInvoice3id=15 AND tblSparePart3id=11);
INSERT INTO tblInvoicePart3 (id, quantity, price, tblInvoice3id, tblSparePart3id)
SELECT 23, 4, 320000, 16, 5
WHERE NOT EXISTS (SELECT 1 FROM tblInvoicePart3 WHERE id=23 AND quantity=4 AND price=320000 AND tblInvoice3id=16 AND tblSparePart3id=5);
INSERT INTO tblInvoicePart3 (id, quantity, price, tblInvoice3id, tblSparePart3id)
SELECT 24, 1, 180000, 16, 6
WHERE NOT EXISTS (SELECT 1 FROM tblInvoicePart3 WHERE id=24 AND quantity=1 AND price=180000 AND tblInvoice3id=16 AND tblSparePart3id=6);
INSERT INTO tblInvoicePart3 (id, quantity, price, tblInvoice3id, tblSparePart3id)
SELECT 25, 2, 1950000, 17, 9
WHERE NOT EXISTS (SELECT 1 FROM tblInvoicePart3 WHERE id=25 AND quantity=2 AND price=1950000 AND tblInvoice3id=17 AND tblSparePart3id=9);
INSERT INTO tblInvoicePart3 (id, quantity, price, tblInvoice3id, tblSparePart3id)
SELECT 26, 1, 220000, 18, 8
WHERE NOT EXISTS (SELECT 1 FROM tblInvoicePart3 WHERE id=26 AND quantity=1 AND price=220000 AND tblInvoice3id=18 AND tblSparePart3id=8);
INSERT INTO tblInvoicePart3 (id, quantity, price, tblInvoice3id, tblSparePart3id)
SELECT 27, 1, 350000, 18, 13
WHERE NOT EXISTS (SELECT 1 FROM tblInvoicePart3 WHERE id=27 AND quantity=1 AND price=350000 AND tblInvoice3id=18 AND tblSparePart3id=13);
INSERT INTO tblInvoicePart3 (id, quantity, price, tblInvoice3id, tblSparePart3id)
SELECT 28, 4.5, 320000, 19, 5
WHERE NOT EXISTS (SELECT 1 FROM tblInvoicePart3 WHERE id=28 AND quantity=4.5 AND price=320000 AND tblInvoice3id=19 AND tblSparePart3id=5);
INSERT INTO tblInvoicePart3 (id, quantity, price, tblInvoice3id, tblSparePart3id)
SELECT 29, 1, 180000, 19, 6
WHERE NOT EXISTS (SELECT 1 FROM tblInvoicePart3 WHERE id=29 AND quantity=1 AND price=180000 AND tblInvoice3id=19 AND tblSparePart3id=6);
INSERT INTO tblInvoicePart3 (id, quantity, price, tblInvoice3id, tblSparePart3id)
SELECT 30, 2, 1950000, 20, 9
WHERE NOT EXISTS (SELECT 1 FROM tblInvoicePart3 WHERE id=30 AND quantity=2 AND price=1950000 AND tblInvoice3id=20 AND tblSparePart3id=9);
INSERT INTO tblInvoicePart3 (id, quantity, price, tblInvoice3id, tblSparePart3id)
SELECT 31, 4, 280000, 21, 12
WHERE NOT EXISTS (SELECT 1 FROM tblInvoicePart3 WHERE id=31 AND quantity=4 AND price=280000 AND tblInvoice3id=21 AND tblSparePart3id=12);
INSERT INTO tblInvoicePart3 (id, quantity, price, tblInvoice3id, tblSparePart3id)
SELECT 32, 6, 180000, 21, 11
WHERE NOT EXISTS (SELECT 1 FROM tblInvoicePart3 WHERE id=32 AND quantity=6 AND price=180000 AND tblInvoice3id=21 AND tblSparePart3id=11);
INSERT INTO tblInvoicePart3 (id, quantity, price, tblInvoice3id, tblSparePart3id)
SELECT 33, 1, 1850000, 22, 10
WHERE NOT EXISTS (SELECT 1 FROM tblInvoicePart3 WHERE id=33 AND quantity=1 AND price=1850000 AND tblInvoice3id=22 AND tblSparePart3id=10);
INSERT INTO tblInvoicePart3 (id, quantity, price, tblInvoice3id, tblSparePart3id)
SELECT 34, 1, 1250000, 23, 7
WHERE NOT EXISTS (SELECT 1 FROM tblInvoicePart3 WHERE id=34 AND quantity=1 AND price=1250000 AND tblInvoice3id=23 AND tblSparePart3id=7);
