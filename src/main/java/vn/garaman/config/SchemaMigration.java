package vn.garaman.config;

import java.sql.*;

/** Converts the earlier flattened JDBC schema into the submitted 19-table design.
 * MySQL DDL commits implicitly: take a backup first. Each step can be resumed.
 */
public final class SchemaMigration {
    private SchemaMigration() { }

    public static boolean isLegacy(Connection con) throws SQLException {
        return hasColumn(con,"tblMember3","position") || hasColumn(con,"tblCar3","customerId")
                || hasColumn(con,"tblInvoice3","salesStaffId") || hasColumn(con,"tblInvoiceService3","technicianName");
    }

    public static void upgrade(Connection con) throws SQLException {
        if (!con.getAutoCommit()) throw new SQLException("Chuyển đổi cấu trúc cần kết nối riêng ở chế độ auto-commit.");
        Database.executeResource(con,"/schema.sql");
        if (hasColumn(con,"tblMember3","position")) {
            execute(con,"INSERT INTO tblStaff3(tblMember3id,position) SELECT m.id,m.position FROM tblMember3 m WHERE NOT EXISTS (SELECT 1 FROM tblStaff3 s WHERE s.tblMember3id=m.id)");
            execute(con,"INSERT INTO tblManager3(tblMember3id) SELECT s.tblMember3id FROM tblStaff3 s WHERE UPPER(s.position)='MANAGER' AND NOT EXISTS (SELECT 1 FROM tblManager3 g WHERE g.tblMember3id=s.tblMember3id)");
            execute(con,"INSERT INTO tblSalesStaff3(tblMember3id) SELECT s.tblMember3id FROM tblStaff3 s WHERE UPPER(s.position) IN ('SALES','SALE') AND NOT EXISTS (SELECT 1 FROM tblSalesStaff3 g WHERE g.tblMember3id=s.tblMember3id)");
            execute(con,"INSERT INTO tblWarehouseStaff3(tblMember3id) SELECT s.tblMember3id FROM tblStaff3 s WHERE UPPER(s.position)='WAREHOUSE' AND NOT EXISTS (SELECT 1 FROM tblWarehouseStaff3 g WHERE g.tblMember3id=s.tblMember3id)");
        }
        String[][] renames={
            {"tblWarehouse3","garageId","tblGarage3id"},
            {"tblCar3","customerId","tblCustomer3id"},
            {"tblAppointment3","customerId","tblCustomer3id"},
            {"tblImportReceipt3","warehouseId","tblWarehouse3id"},
            {"tblImportReceipt3","supplierId","tblSupplier3id"},
            {"tblImportReceipt3","warehouseStaffId","tblWarehouseStaff3id"},
            {"tblImportDetail3","importReceiptId","tblImportReceipt3id"},
            {"tblImportDetail3","sparePartId","tblSparePart3id"},
            {"tblServicePart3","serviceId","tblService3id"},
            {"tblServicePart3","sparePartId","tblSparePart3id"},
            {"tblInvoice3","customerId","tblCustomer3id"},
            {"tblInvoice3","carId","tblCar3id"},
            {"tblInvoice3","salesStaffId","tblSalesStaff3id"},
            {"tblInvoiceService3","invoiceId","tblInvoice3id"},
            {"tblInvoiceService3","serviceId","tblService3id"},
            {"tblInvoiceService3","technicianName","technician"},
            {"tblInvoicePart3","invoiceId","tblInvoice3id"},
            {"tblInvoicePart3","sparePartId","tblSparePart3id"}
        };
        for (String[] rename:renames)
            if (hasColumn(con,rename[0],rename[1]) && !hasColumn(con,rename[0],rename[2]))
                execute(con,"ALTER TABLE "+rename[0]+" RENAME COLUMN "+rename[1]+" TO "+rename[2]);
        staffForeignKey(con,"tblInvoice3","tblSalesStaff3id","tblSalesStaff3","fk_invoice3_staff");
        staffForeignKey(con,"tblImportReceipt3","tblWarehouseStaff3id","tblWarehouseStaff3","fk_importreceipt3_staff");
        if (hasColumn(con,"tblMember3","position")) {
            try (Statement statement=con.createStatement(); ResultSet rows=statement.executeQuery(
                    "SELECT COUNT(*) FROM tblMember3 m LEFT JOIN tblStaff3 s ON s.tblMember3id=m.id WHERE s.tblMember3id IS NULL")) {
                rows.next(); if(rows.getInt(1)!=0) throw new SQLException("Chưa sao chép đủ thông tin nhân viên; dừng chuyển đổi.");
            }
            execute(con,"ALTER TABLE tblMember3 DROP COLUMN position");
        }
    }

    private static void staffForeignKey(Connection con,String table,String column,String target,String name) throws SQLException {
        String actual=table;
        try(ResultSet tables=con.getMetaData().getTables(con.getCatalog(),null,"%",new String[]{"TABLE"})) {
            while(tables.next()) if(table.equalsIgnoreCase(tables.getString("TABLE_NAME"))) {actual=tables.getString("TABLE_NAME");break;}
        }
        String oldName=null; boolean correct=false;
        try(ResultSet keys=con.getMetaData().getImportedKeys(con.getCatalog(),null,actual)) {
            while(keys.next()) if(column.equalsIgnoreCase(keys.getString("FKCOLUMN_NAME"))) {
                correct=target.equalsIgnoreCase(keys.getString("PKTABLE_NAME"));
                if(!correct) oldName=keys.getString("FK_NAME");
            }
        }
        if(correct)return;
        if(oldName!=null) {
            boolean mysql=con.getMetaData().getDatabaseProductName().equalsIgnoreCase("MySQL");
            execute(con,"ALTER TABLE "+table+(mysql?" DROP FOREIGN KEY ":" DROP CONSTRAINT ")+oldName);
        }
        execute(con,"ALTER TABLE "+table+" ADD CONSTRAINT "+name+" FOREIGN KEY ("+column+") REFERENCES "+target+"(tblMember3id)");
    }

    private static boolean hasColumn(Connection con,String table,String column) throws SQLException {
        try(ResultSet rows=con.getMetaData().getColumns(con.getCatalog(),null,"%","%")) {
            while(rows.next()) if(table.equalsIgnoreCase(rows.getString("TABLE_NAME")) && column.equalsIgnoreCase(rows.getString("COLUMN_NAME")))return true;
        }
        return false;
    }
    private static void execute(Connection con,String sql) throws SQLException {
        try(Statement statement=con.createStatement()) { statement.execute(sql); }
    }
}
