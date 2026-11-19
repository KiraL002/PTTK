package vn.garaman.config;

import java.sql.*;
import java.util.*;

/** Merges earlier account tables into Member.role without resetting business data.
 * MySQL DDL commits implicitly: take a backup first. Each step can be resumed.
 */
public final class SchemaMigration {
    private static final String[][] RENAMES = {
        {"tblWarehouse3", "garageId", "tblGarage3id"},
        {"tblCar3", "customerId", "tblCustomer3id"},
        {"tblAppointment3", "customerId", "tblCustomer3id"},
        {"tblImportReceipt3", "warehouseId", "tblWarehouse3id"},
        {"tblImportReceipt3", "supplierId", "tblSupplier3id"},
        {"tblImportReceipt3", "warehouseStaffId", "tblMember3id"},
        {"tblImportReceipt3", "tblWarehouseStaff3id", "tblMember3id"},
        {"tblImportDetail3", "importReceiptId", "tblImportReceipt3id"},
        {"tblImportDetail3", "sparePartId", "tblSparePart3id"},
        {"tblServicePart3", "serviceId", "tblService3id"},
        {"tblServicePart3", "sparePartId", "tblSparePart3id"},
        {"tblInvoice3", "customerId", "tblCustomer3id"},
        {"tblInvoice3", "carId", "tblCar3id"},
        {"tblInvoice3", "salesStaffId", "tblMember3id"},
        {"tblInvoice3", "tblSalesStaff3id", "tblMember3id"},
        {"tblInvoiceService3", "invoiceId", "tblInvoice3id"},
        {"tblInvoiceService3", "serviceId", "tblService3id"},
        {"tblInvoiceService3", "technicianName", "technician"},
        {"tblInvoicePart3", "invoiceId", "tblInvoice3id"},
        {"tblInvoicePart3", "sparePartId", "tblSparePart3id"}
    };
    private static final String[] ACCOUNT_TABLES = {
        "tblManager3", "tblSalesStaff3", "tblWarehouseStaff3", "tblStaff3"
    };

    private SchemaMigration() {}

    public static boolean isLegacy(Connection con) throws SQLException {
        if (!hasTable(con, "tblMember3"))
            return false;
        if (!hasColumn(con, "tblMember3", "role") || hasColumn(con, "tblMember3", "position"))
            return true;
        for (String table : ACCOUNT_TABLES) if (hasTable(con, table))
            return true;
        for (String[] rename : RENAMES) if (hasColumn(con, rename[0], rename[1]))
            return true;
        return false;
    }

    public static void upgrade(Connection con) throws SQLException {
        if (!con.getAutoCommit())
            throw new SQLException("Chuyển đổi cấu trúc cần kết nối riêng ở chế độ auto-commit.");
        if (!hasTable(con, "tblMember3")) {
            Database.executeResource(con, "/schema.sql");
            return;
        }
        // Validate before DDL: one role per account, matching existing document owners.
        Map<Integer, String> roles = readRoles(con);
        validateOwners(
                con,
                roles,
                "tblInvoice3",
                "SALES",
                "tblMember3id",
                "tblSalesStaff3id",
                "salesStaffId");
        validateOwners(
                con,
                roles,
                "tblImportReceipt3",
                "WAREHOUSE",
                "tblMember3id",
                "tblWarehouseStaff3id",
                "warehouseStaffId");
        for (String[] rename : RENAMES)
            if (hasColumn(con, rename[0], rename[1]) && hasColumn(con, rename[0], rename[2]))
                throw new SQLException(
                        "Có cả cột cũ và mới tại " + rename[0] + "; cần kiểm tra trước khi gộp.");

        if (!hasColumn(con, "tblMember3", "role"))
            execute(con, "ALTER TABLE tblMember3 ADD COLUMN role VARCHAR(30) NULL");
        try (PreparedStatement statement =
                con.prepareStatement("UPDATE tblMember3 SET role=? WHERE id=?")) {
            for (Map.Entry<Integer, String> entry : roles.entrySet()) {
                statement.setString(1, entry.getValue());
                statement.setInt(2, entry.getKey());
                statement.addBatch();
            }
            statement.executeBatch();
        }
        execute(
                con,
                isMySql(con)
                        ? "ALTER TABLE tblMember3 MODIFY COLUMN role VARCHAR(30) NOT NULL"
                        : "ALTER TABLE tblMember3 ALTER COLUMN role SET NOT NULL");
        ensureRoleCheck(con);
        detachOldOwnerKey(con, "tblInvoice3", "tblSalesStaff3id", "salesStaffId");
        detachOldOwnerKey(con, "tblImportReceipt3", "tblWarehouseStaff3id", "warehouseStaffId");
        for (String[] rename : RENAMES)
            if (hasColumn(con, rename[0], rename[1]))
                execute(
                        con,
                        "ALTER TABLE "
                                + rename[0]
                                + " RENAME COLUMN "
                                + rename[1]
                                + " TO "
                                + rename[2]);
        memberForeignKey(con, "tblInvoice3", "fk_invoice3_staff");
        memberForeignKey(con, "tblImportReceipt3", "fk_importreceipt3_staff");
        for (String table : ACCOUNT_TABLES)
            if (hasTable(con, table))
                execute(con, "DROP TABLE " + table);
        if (hasColumn(con, "tblMember3", "position"))
            execute(con, "ALTER TABLE tblMember3 DROP COLUMN position");
        Database.executeResource(con, "/schema.sql");
    }

    private static Map<Integer, String> readRoles(Connection con) throws SQLException {
        Map<Integer, String> roles = new LinkedHashMap<>();
        try (Statement statement = con.createStatement();
                ResultSet rows = statement.executeQuery("SELECT id FROM tblMember3")) {
            while (rows.next())
                roles.put(rows.getInt(1), null);
        }
        for (String column : new String[] {"role", "position"})
            if (hasColumn(con, "tblMember3", column))
                readRoleColumn(con, roles, "SELECT id," + column + " FROM tblMember3");
        if (hasTable(con, "tblStaff3"))
            readRoleColumn(con, roles, "SELECT tblMember3id,position FROM tblStaff3");
        String[][] subtypes = {
            {"tblManager3", "MANAGER"},
            {"tblSalesStaff3", "SALES"},
            {"tblWarehouseStaff3", "WAREHOUSE"}
        };
        for (String[] subtype : subtypes)
            if (hasTable(con, subtype[0]))
                try (Statement statement = con.createStatement();
                        ResultSet rows =
                                statement.executeQuery("SELECT tblMember3id FROM " + subtype[0])) {
                    while (rows.next())
                        mergeRole(roles, rows.getInt(1), subtype[1]);
                }
        for (Map.Entry<Integer, String> entry : roles.entrySet())
            if (entry.getValue() == null)
                throw new SQLException(
                        "Tài khoản " + entry.getKey() + " chưa có vai trò; dừng chuyển đổi.");
        return roles;
    }

    private static void readRoleColumn(Connection con, Map<Integer, String> roles, String sql)
            throws SQLException {
        try (Statement statement = con.createStatement();
                ResultSet rows = statement.executeQuery(sql)) {
            while (rows.next()) {
                String role = rows.getString(2);
                if (role != null && !role.isBlank())
                    mergeRole(roles, rows.getInt(1), role);
            }
        }
    }

    private static void mergeRole(Map<Integer, String> roles, int id, String source)
            throws SQLException {
        String role = source.trim().toUpperCase(Locale.ROOT);
        if (role.equals("SALE"))
            role = "SALES";
        if (!roles.containsKey(id)
                || !Arrays.asList("MANAGER", "SALES", "WAREHOUSE").contains(role))
            throw new SQLException(
                    "Thông tin vai trò của tài khoản " + id + " không hợp lệ; dừng chuyển đổi.");
        String existing = roles.get(id);
        if (existing != null && !existing.equals(role))
            throw new SQLException(
                    "Tài khoản "
                            + id
                            + " có nhiều vai trò khác nhau; không thể gộp vào một cột role.");
        roles.put(id, role);
    }

    private static void validateOwners(
            Connection con,
            Map<Integer, String> roles,
            String table,
            String role,
            String... columns)
            throws SQLException {
        for (String column : columns)
            if (hasColumn(con, table, column))
                try (Statement statement = con.createStatement();
                        ResultSet rows =
                                statement.executeQuery("SELECT id," + column + " FROM " + table)) {
                    while (rows.next())
                        if (!role.equals(roles.get(rows.getInt(2))))
                            throw new SQLException(
                                    "Nhân viên phụ trách "
                                            + table
                                            + " id="
                                            + rows.getInt(1)
                                            + " không đúng vai trò; dừng chuyển đổi.");
                }
    }

    private static void ensureRoleCheck(Connection con) throws SQLException {
        try (PreparedStatement statement =
                con.prepareStatement(
                        "SELECT COUNT(*) FROM information_schema.table_constraints WHERE LOWER(table_name)='tblmember3' AND LOWER(constraint_name)='ck_member3_role' AND table_schema=?")) {
            statement.setString(1, isMySql(con) ? con.getCatalog() : con.getSchema());
            try (ResultSet rows = statement.executeQuery()) {
                rows.next();
                if (rows.getInt(1) != 0)
                    return;
            }
        }
        execute(
                con,
                "ALTER TABLE tblMember3 ADD CONSTRAINT ck_member3_role CHECK (role IN ('MANAGER','SALES','WAREHOUSE'))");
    }

    private static void detachOldOwnerKey(Connection con, String table, String... columns)
            throws SQLException {
        for (String column : columns)
            if (hasColumn(con, table, column))
                dropForeignKeys(con, table, column);
    }

    private static void memberForeignKey(Connection con, String table, String name)
            throws SQLException {
        if (!hasTable(con, table))
            return;
        try (ResultSet keys =
                con.getMetaData()
                        .getImportedKeys(con.getCatalog(), null, actualTable(con, table))) {
            while (keys.next())
                if ("tblMember3id".equalsIgnoreCase(keys.getString("FKCOLUMN_NAME"))
                        && "tblMember3".equalsIgnoreCase(keys.getString("PKTABLE_NAME"))
                        && "id".equalsIgnoreCase(keys.getString("PKCOLUMN_NAME")))
                    return;
        }
        dropForeignKeys(con, table, "tblMember3id");
        execute(
                con,
                "ALTER TABLE "
                        + table
                        + " ADD CONSTRAINT "
                        + name
                        + " FOREIGN KEY (tblMember3id) REFERENCES tblMember3(id)");
    }

    private static void dropForeignKeys(Connection con, String table, String column)
            throws SQLException {
        Set<String> names = new LinkedHashSet<>();
        try (ResultSet keys =
                con.getMetaData()
                        .getImportedKeys(con.getCatalog(), null, actualTable(con, table))) {
            while (keys.next())
                if (column.equalsIgnoreCase(keys.getString("FKCOLUMN_NAME")))
                    names.add(keys.getString("FK_NAME"));
        }
        for (String name : names)
            execute(
                    con,
                    "ALTER TABLE "
                            + table
                            + (isMySql(con) ? " DROP FOREIGN KEY " : " DROP CONSTRAINT ")
                            + quote(name));
    }

    private static String quote(String identifier) {
        return "`" + identifier.replace("`", "``") + "`";
    }

    private static String actualTable(Connection con, String table) throws SQLException {
        try (ResultSet rows =
                con.getMetaData().getTables(con.getCatalog(), null, "%", new String[] {"TABLE"})) {
            while (rows.next())
                if (table.equalsIgnoreCase(rows.getString("TABLE_NAME")))
                    return rows.getString("TABLE_NAME");
        }
        return null;
    }

    static boolean hasTable(Connection con, String table) throws SQLException {
        return actualTable(con, table) != null;
    }

    private static boolean hasColumn(Connection con, String table, String column)
            throws SQLException {
        try (ResultSet rows = con.getMetaData().getColumns(con.getCatalog(), null, "%", "%")) {
            while (rows.next())
                if (table.equalsIgnoreCase(rows.getString("TABLE_NAME"))
                        && column.equalsIgnoreCase(rows.getString("COLUMN_NAME")))
                    return true;
        }
        return false;
    }

    private static boolean isMySql(Connection con) throws SQLException {
        return con.getMetaData().getDatabaseProductName().equalsIgnoreCase("MySQL");
    }

    private static void execute(Connection con, String sql) throws SQLException {
        try (Statement statement = con.createStatement()) {
            statement.execute(sql);
        }
    }
}
