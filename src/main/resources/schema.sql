-- JDBC schema shared by embedded H2 (MySQL mode) and MySQL.
CREATE TABLE IF NOT EXISTS tblMember3 (
    id INT NOT NULL AUTO_INCREMENT,
    fullName VARCHAR(100) NOT NULL,
    address VARCHAR(255) NULL,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NULL,
    phone VARCHAR(20) NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT uq_member3_username UNIQUE (username)
);

CREATE TABLE IF NOT EXISTS tblStaff3 (
    tblMember3id INT NOT NULL,
    position VARCHAR(255) NOT NULL,
    PRIMARY KEY (tblMember3id),
    CONSTRAINT fk_staff3_member FOREIGN KEY (tblMember3id) REFERENCES tblMember3 (id)
);

CREATE TABLE IF NOT EXISTS tblManager3 (
    tblMember3id INT NOT NULL,
    PRIMARY KEY (tblMember3id),
    CONSTRAINT fk_manager3_staff FOREIGN KEY (tblMember3id) REFERENCES tblStaff3 (tblMember3id)
);

CREATE TABLE IF NOT EXISTS tblSalesStaff3 (
    tblMember3id INT NOT NULL,
    PRIMARY KEY (tblMember3id),
    CONSTRAINT fk_salesstaff3_staff FOREIGN KEY (tblMember3id) REFERENCES tblStaff3 (tblMember3id)
);

CREATE TABLE IF NOT EXISTS tblWarehouseStaff3 (
    tblMember3id INT NOT NULL,
    PRIMARY KEY (tblMember3id),
    CONSTRAINT fk_warehousestaff3_staff FOREIGN KEY (tblMember3id) REFERENCES tblStaff3 (tblMember3id)
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
    price DECIMAL(15,2) NOT NULL,
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
    sellingPrice DECIMAL(15,2) NOT NULL,
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
    tblGarage3id INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_warehouse3_garage
        FOREIGN KEY (tblGarage3id) REFERENCES tblGarage3 (id)
);

CREATE TABLE IF NOT EXISTS tblCar3 (
    id INT NOT NULL AUTO_INCREMENT,
    licensePlate VARCHAR(20) NOT NULL,
    brand VARCHAR(50) NULL,
    model VARCHAR(100) NULL,
    `year` INT NULL,
    tblCustomer3id INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_car3_customer
        FOREIGN KEY (tblCustomer3id) REFERENCES tblCustomer3 (id)
);

CREATE TABLE IF NOT EXISTS tblAppointment3 (
    id INT NOT NULL AUTO_INCREMENT,
    appointmentDate DATE NOT NULL,
    appointmentTime TIME NOT NULL,
    status VARCHAR(30) NOT NULL,
    description TEXT NULL,
    createdDate DATETIME NOT NULL,
    tblCustomer3id INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_appointment3_customer
        FOREIGN KEY (tblCustomer3id) REFERENCES tblCustomer3 (id)
);

CREATE TABLE IF NOT EXISTS tblImportReceipt3 (
    id INT NOT NULL AUTO_INCREMENT,
    importDate DATETIME NOT NULL,
    status VARCHAR(30) NOT NULL,
    tblWarehouse3id INT NOT NULL,
    tblSupplier3id INT NOT NULL,
    tblWarehouseStaff3id INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_importreceipt3_warehouse
        FOREIGN KEY (tblWarehouse3id) REFERENCES tblWarehouse3 (id),
    CONSTRAINT fk_importreceipt3_supplier
        FOREIGN KEY (tblSupplier3id) REFERENCES tblSupplier3 (id),
    CONSTRAINT fk_importreceipt3_staff
        FOREIGN KEY (tblWarehouseStaff3id) REFERENCES tblWarehouseStaff3 (tblMember3id)
);

CREATE TABLE IF NOT EXISTS tblImportDetail3 (
    id INT NOT NULL AUTO_INCREMENT,
    quantity DECIMAL(15,3) NOT NULL,
    importPrice DECIMAL(15,2) NOT NULL,
    tblImportReceipt3id INT NOT NULL,
    tblSparePart3id INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_importdetail3_receipt
        FOREIGN KEY (tblImportReceipt3id) REFERENCES tblImportReceipt3 (id),
    CONSTRAINT fk_importdetail3_part
        FOREIGN KEY (tblSparePart3id) REFERENCES tblSparePart3 (id)
);

CREATE TABLE IF NOT EXISTS tblServicePart3 (
    id INT NOT NULL AUTO_INCREMENT,
    quantity DECIMAL(15,3) NOT NULL,
    tblService3id INT NOT NULL,
    tblSparePart3id INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT uq_servicepart3_service_part UNIQUE (tblService3id, tblSparePart3id),
    CONSTRAINT fk_servicepart3_service
        FOREIGN KEY (tblService3id) REFERENCES tblService3 (id),
    CONSTRAINT fk_servicepart3_part
        FOREIGN KEY (tblSparePart3id) REFERENCES tblSparePart3 (id)
);

CREATE TABLE IF NOT EXISTS tblInvoice3 (
    id INT NOT NULL AUTO_INCREMENT,
    createdDate DATETIME NOT NULL,
    paymentDate DATETIME NULL,
    status VARCHAR(30) NOT NULL,
    requestDescription TEXT NULL,
    paymentMethod VARCHAR(30) NULL,
    tblCustomer3id INT NOT NULL,
    tblCar3id INT NOT NULL,
    tblSalesStaff3id INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_invoice3_customer
        FOREIGN KEY (tblCustomer3id) REFERENCES tblCustomer3 (id),
    CONSTRAINT fk_invoice3_car
        FOREIGN KEY (tblCar3id) REFERENCES tblCar3 (id),
    CONSTRAINT fk_invoice3_staff
        FOREIGN KEY (tblSalesStaff3id) REFERENCES tblSalesStaff3 (tblMember3id)
);

CREATE TABLE IF NOT EXISTS tblInvoiceService3 (
    id INT NOT NULL AUTO_INCREMENT,
    quantity INT NOT NULL,
    price DECIMAL(15,2) NOT NULL,
    technician VARCHAR(100) NULL,
    workStatus VARCHAR(30) NOT NULL,
    tblInvoice3id INT NOT NULL,
    tblService3id INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_invoiceservice3_invoice
        FOREIGN KEY (tblInvoice3id) REFERENCES tblInvoice3 (id),
    CONSTRAINT fk_invoiceservice3_service
        FOREIGN KEY (tblService3id) REFERENCES tblService3 (id)
);

CREATE TABLE IF NOT EXISTS tblInvoicePart3 (
    id INT NOT NULL AUTO_INCREMENT,
    quantity DECIMAL(15,3) NOT NULL,
    price DECIMAL(15,2) NOT NULL,
    tblInvoice3id INT NOT NULL,
    tblSparePart3id INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_invoicepart3_invoice
        FOREIGN KEY (tblInvoice3id) REFERENCES tblInvoice3 (id),
    CONSTRAINT fk_invoicepart3_part
        FOREIGN KEY (tblSparePart3id) REFERENCES tblSparePart3 (id)
);
