package vn.garaman.config;

import java.sql.*;
import java.time.LocalDate;
import java.util.UUID;
import org.junit.*;
import static org.junit.Assert.*;
import vn.garaman.dao.*;
import vn.garaman.model.CustomerStatistics3;
import vn.garaman.util.PasswordHasher;

public class SchemaMigrationTest {
    private Connection con;

    @Before
    public void legacyDatabase() throws Exception {
        con =
                DriverManager.getConnection(
                        "jdbc:h2:mem:" + UUID.randomUUID() + ";MODE=MySQL;DATABASE_TO_LOWER=TRUE",
                        "sa",
                        "");
        Database.executeResource(con, "/legacy-schema.sql");
        try (PreparedStatement statement =
                con.prepareStatement(
                        "INSERT INTO tblMember3(id,fullName,username,password,phone,position) VALUES (1,'Existing manager','admin',?,'0123456789','MANAGER')")) {
            statement.setString(1, PasswordHasher.hash("ExistingPassword123"));
            statement.executeUpdate();
        }
        Database.executeResource(con, "/legacy-seed.sql");
    }

    @After
    public void close() throws Exception {
        con.close();
    }

    @Test
    public void upgradePreservesCredentialsInvoicesAndStock() throws Exception {
        assertTrue(SchemaMigration.isLegacy(con));
        SchemaMigration.upgrade(con);
        assertFalse(SchemaMigration.isLegacy(con));
        assertNotNull(new MemberDAO3(con).authenticateManager("admin", "ExistingPassword123"));
        CustomerStatistics3[] rows =
                new CustomerStatisticsDAO3(con)
                        .getStatistics(LocalDate.of(2026, 8, 1), LocalDate.of(2026, 8, 31));
        assertEquals(3, rows.length);
        assertEquals(0, new java.math.BigDecimal("15000000").compareTo(rows[0].getTotalRevenue()));
        assertEquals(
                0,
                new java.math.BigDecimal("179")
                        .compareTo(new SparePartDAO3(con).getPartDetail(17).getStockQty()));
        assertNotNull(new InvoiceDAO3(con).getSalesStaffByInvoice(15));
        assertEquals(
                2,
                new InvoiceDAO3(con)
                        .getInvoiceDetail(
                                15, 8, LocalDate.of(2026, 8, 1), LocalDate.of(2026, 8, 31))
                        .getInvoiceServices()
                        .length);
    }

    @Test
    public void resumedUpgradeDoesNotDuplicateRolesOrBusinessData() throws Exception {
        SchemaMigration.upgrade(con);
        SchemaMigration.upgrade(con);
        try (Statement statement = con.createStatement();
                ResultSet rows =
                        statement.executeQuery(
                                "SELECT COUNT(*) FROM tblMember3 WHERE role IS NOT NULL")) {
            rows.next();
            assertEquals(3, rows.getInt(1));
        }
        try (Statement statement = con.createStatement();
                ResultSet rows = statement.executeQuery("SELECT COUNT(*) FROM tblInvoice3")) {
            rows.next();
            assertEquals(7, rows.getInt(1));
        }
    }

    @Test
    public void upgradedForeignKeysReferenceMemberAndRoleLookupRejectsWrongStaff()
            throws Exception {
        SchemaMigration.upgrade(con);
        assertThrows(
                SQLException.class,
                () ->
                        con.createStatement()
                                .executeUpdate(
                                        "UPDATE tblInvoice3 SET tblMember3id=999 WHERE id=15"));
        assertThrows(
                SQLException.class,
                () ->
                        con.createStatement()
                                .executeUpdate(
                                        "UPDATE tblImportReceipt3 SET tblMember3id=999 WHERE id=1"));
        con.createStatement().executeUpdate("UPDATE tblInvoice3 SET tblMember3id=3 WHERE id=15");
        assertNull(new InvoiceDAO3(con).getSalesStaffByInvoice(15));
    }

    @Test
    public void splitRoleTablesMergeWithoutChangingAccountsOrInvoiceOwners() throws Exception {
        loadSplitRoleDatabase();
        SchemaMigration.upgrade(con);
        assertFalse(SchemaMigration.isLegacy(con));
        assertNotNull(new MemberDAO3(con).authenticateManager("admin", "ExistingPassword123"));
        assertEquals("SALES", new InvoiceDAO3(con).getSalesStaffByInvoice(15).getPosition());
        try (Statement statement = con.createStatement();
                ResultSet rows =
                        statement.executeQuery(
                                "SELECT tblMember3id FROM tblInvoice3 WHERE id=15")) {
            assertTrue(rows.next());
            assertEquals(2, rows.getInt(1));
        }
        int tableCount = 0;
        try (ResultSet rows =
                con.getMetaData().getTables(con.getCatalog(), null, "%", new String[] {"TABLE"})) {
            while (rows.next())
                if (rows.getString("TABLE_NAME").toLowerCase().startsWith("tbl"))
                    tableCount++;
        }
        assertEquals(15, tableCount);
        SchemaMigration.upgrade(con);
        assertEquals(
                3,
                new CustomerStatisticsDAO3(con)
                        .getStatistics(LocalDate.of(2026, 8, 1), LocalDate.of(2026, 8, 31))
                        .length);
    }

    @Test
    public void splitRoleMigrationResumesAfterOwnerColumnWasRenamed() throws Exception {
        loadSplitRoleDatabase();
        con.createStatement().execute("ALTER TABLE tblInvoice3 DROP CONSTRAINT fk_invoice3_staff");
        con.createStatement()
                .execute("ALTER TABLE tblInvoice3 RENAME COLUMN tblSalesStaff3id TO tblMember3id");
        SchemaMigration.upgrade(con);
        assertNotNull(new InvoiceDAO3(con).getSalesStaffByInvoice(15));
        assertFalse(SchemaMigration.isLegacy(con));
    }

    @Test
    public void conflictingRolesStopBeforeDeletingOrChangingTables() throws Exception {
        loadSplitRoleDatabase();
        con.createStatement().executeUpdate("INSERT INTO tblManager3(tblMember3id) VALUES (2)");
        assertThrows(SQLException.class, () -> SchemaMigration.upgrade(con));
        try (Statement statement = con.createStatement();
                ResultSet rows = statement.executeQuery("SELECT COUNT(*) FROM tblSalesStaff3")) {
            rows.next();
            assertEquals(1, rows.getInt(1));
        }
        assertTrue(SchemaMigration.isLegacy(con));
    }

    @Test
    public void unknownPositionStopsRatherThanDiscardingIt() throws Exception {
        con.createStatement()
                .executeUpdate("UPDATE tblMember3 SET position='CUSTOM_JOB' WHERE id=2");
        assertThrows(SQLException.class, () -> SchemaMigration.upgrade(con));
        try (Statement statement = con.createStatement();
                ResultSet rows =
                        statement.executeQuery("SELECT position FROM tblMember3 WHERE id=2")) {
            rows.next();
            assertEquals("CUSTOM_JOB", rows.getString(1));
        }
    }

    private void loadSplitRoleDatabase() throws Exception {
        con.close();
        con =
                DriverManager.getConnection(
                        "jdbc:h2:mem:" + UUID.randomUUID() + ";MODE=MySQL;DATABASE_TO_LOWER=TRUE",
                        "sa",
                        "");
        Database.executeResource(con, "/split-role-schema.sql");
        try (PreparedStatement statement =
                con.prepareStatement(
                        "INSERT INTO tblMember3(id,fullName,username,password,phone) VALUES (1,'Existing manager','admin',?,'0123456789')")) {
            statement.setString(1, PasswordHasher.hash("ExistingPassword123"));
            statement.executeUpdate();
        }
        con.createStatement()
                .executeUpdate("INSERT INTO tblStaff3(tblMember3id,position) VALUES (1,'MANAGER')");
        con.createStatement().executeUpdate("INSERT INTO tblManager3(tblMember3id) VALUES (1)");
        Database.executeResource(con, "/split-role-seed.sql");
    }
}
