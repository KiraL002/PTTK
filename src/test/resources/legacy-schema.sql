-- JDBC schema shared by embedded H2 (MySQL mode) and MySQL.
CREATE TABLE IF NOT EXISTS tblMember3 (
    id INT NOT NULL AUTO_INCREMENT,
    fullName VARCHAR(100) NOT NULL,
    address VARCHAR(255) NULL,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NULL,
    phone VARCHAR(20) NOT NULL,
    position VARCHAR(30) NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT uq_member3_username UNIQUE (username)
);

CREATE TABLE IF NOT EXISTS tblGarage3 (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    description TEXT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS tblCustomer3 (
    id INT NOT NULL AUTO_INCREMENT,
    fullName VARCHAR(100) NOT NULL,
    address VARCHAR(255) NULL,
    phone VARCHAR(20) NOT NULL,
    customerType VARCHAR(30) NOT NULL DEFAULT 'REGULAR',
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS tblSupplier3 (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    taxCode VARCHAR(30) NULL,
    address VARCHAR(255) NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS tblService3 (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    price DECIMAL(15, 2) NOT NULL,
    duration INT NULL,
    description TEXT NULL,
    category VARCHAR(100) NULL,
    applicableCar VARCHAR(255) NULL,
    warranty INT NOT NULL DEFAULT 0,
    status VARCHAR(30) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS tblSparePart3 (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    sellingPrice DECIMAL(15, 2) NOT NULL,
    description TEXT NULL,
    unit VARCHAR(30) NOT NULL,
    specification TEXT NULL,
    applicableCar VARCHAR(255) NULL,
    warranty INT NOT NULL DEFAULT 0,
    status VARCHAR(30) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS tblWarehouse3 (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    capacity INT NULL,
    description TEXT NULL,
    garageId INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_warehouse3_garage FOREIGN KEY (garageId) REFERENCES tblGarage3 (id)
);

CREATE TABLE IF NOT EXISTS tblCar3 (
    id INT NOT NULL AUTO_INCREMENT,
    licensePlate VARCHAR(20) NOT NULL,
    brand VARCHAR(50) NULL,
    model VARCHAR(100) NULL,
    `year` INT NULL,
    customerId INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_car3_customer FOREIGN KEY (customerId) REFERENCES tblCustomer3 (id)
);

CREATE TABLE IF NOT EXISTS tblAppointment3 (
    id INT NOT NULL AUTO_INCREMENT,
    appointmentDate DATE NOT NULL,
    appointmentTime TIME NOT NULL,
    status VARCHAR(30) NOT NULL,
    description TEXT NULL,
    createdDate DATETIME NOT NULL,
    customerId INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_appointment3_customer FOREIGN KEY (customerId) REFERENCES tblCustomer3 (id)
);

CREATE TABLE IF NOT EXISTS tblImportReceipt3 (
    id INT NOT NULL AUTO_INCREMENT,
    importDate DATETIME NOT NULL,
    status VARCHAR(30) NOT NULL,
    warehouseId INT NOT NULL,
    supplierId INT NOT NULL,
    warehouseStaffId INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_importreceipt3_warehouse FOREIGN KEY (warehouseId) REFERENCES tblWarehouse3 (id),
    CONSTRAINT fk_importreceipt3_supplier FOREIGN KEY (supplierId) REFERENCES tblSupplier3 (id),
    CONSTRAINT fk_importreceipt3_staff FOREIGN KEY (warehouseStaffId) REFERENCES tblMember3 (id)
);

CREATE TABLE IF NOT EXISTS tblImportDetail3 (
    id INT NOT NULL AUTO_INCREMENT,
    quantity DECIMAL(15, 3) NOT NULL,
    importPrice DECIMAL(15, 2) NOT NULL,
    importReceiptId INT NOT NULL,
    sparePartId INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_importdetail3_receipt FOREIGN KEY (importReceiptId) REFERENCES tblImportReceipt3 (id),
    CONSTRAINT fk_importdetail3_part FOREIGN KEY (sparePartId) REFERENCES tblSparePart3 (id)
);

CREATE TABLE IF NOT EXISTS tblServicePart3 (
    id INT NOT NULL AUTO_INCREMENT,
    quantity DECIMAL(15, 3) NOT NULL,
    serviceId INT NOT NULL,
    sparePartId INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT uq_servicepart3_service_part UNIQUE (serviceId, sparePartId),
    CONSTRAINT fk_servicepart3_service FOREIGN KEY (serviceId) REFERENCES tblService3 (id),
    CONSTRAINT fk_servicepart3_part FOREIGN KEY (sparePartId) REFERENCES tblSparePart3 (id)
);

CREATE TABLE IF NOT EXISTS tblInvoice3 (
    id INT NOT NULL AUTO_INCREMENT,
    createdDate DATETIME NOT NULL,
    paymentDate DATETIME NULL,
    status VARCHAR(30) NOT NULL,
    requestDescription TEXT NULL,
    paymentMethod VARCHAR(30) NULL,
    customerId INT NOT NULL,
    carId INT NOT NULL,
    salesStaffId INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_invoice3_customer FOREIGN KEY (customerId) REFERENCES tblCustomer3 (id),
    CONSTRAINT fk_invoice3_car FOREIGN KEY (carId) REFERENCES tblCar3 (id),
    CONSTRAINT fk_invoice3_staff FOREIGN KEY (salesStaffId) REFERENCES tblMember3 (id)
);

CREATE TABLE IF NOT EXISTS tblInvoiceService3 (
    id INT NOT NULL AUTO_INCREMENT,
    quantity INT NOT NULL,
    price DECIMAL(15, 2) NOT NULL,
    technicianName VARCHAR(100) NULL,
    workStatus VARCHAR(30) NOT NULL,
    invoiceId INT NOT NULL,
    serviceId INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_invoiceservice3_invoice FOREIGN KEY (invoiceId) REFERENCES tblInvoice3 (id),
    CONSTRAINT fk_invoiceservice3_service FOREIGN KEY (serviceId) REFERENCES tblService3 (id)
);

CREATE TABLE IF NOT EXISTS tblInvoicePart3 (
    id INT NOT NULL AUTO_INCREMENT,
    quantity DECIMAL(15, 3) NOT NULL,
    price DECIMAL(15, 2) NOT NULL,
    invoiceId INT NOT NULL,
    sparePartId INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_invoicepart3_invoice FOREIGN KEY (invoiceId) REFERENCES tblInvoice3 (id),
    CONSTRAINT fk_invoicepart3_part FOREIGN KEY (sparePartId) REFERENCES tblSparePart3 (id)
);
