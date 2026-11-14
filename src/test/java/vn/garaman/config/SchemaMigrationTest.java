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
    @Before public void legacyDatabase() throws Exception {
        con=DriverManager.getConnection("jdbc:h2:mem:"+UUID.randomUUID()+";MODE=MySQL;DATABASE_TO_LOWER=TRUE","sa","");
        Database.executeResource(con,"/legacy-schema.sql");
        try(PreparedStatement statement=con.prepareStatement("INSERT INTO tblMember3(id,fullName,username,password,phone,position) VALUES (1,'Existing manager','admin',?,'0123456789','MANAGER')")) {
            statement.setString(1,PasswordHasher.hash("ExistingPassword123"));statement.executeUpdate();
        }
        Database.executeResource(con,"/legacy-seed.sql");
    }
    @After public void close() throws Exception { con.close(); }

    @Test public void upgradePreservesCredentialsInvoicesAndStock() throws Exception {
        assertTrue(SchemaMigration.isLegacy(con));
        SchemaMigration.upgrade(con);
        assertFalse(SchemaMigration.isLegacy(con));
        assertNotNull(new MemberDAO3(con).authenticateManager("admin","ExistingPassword123"));
        CustomerStatistics3[] rows=new CustomerStatisticsDAO3(con).getStatistics(LocalDate.of(2026,8,1),LocalDate.of(2026,8,31));
        assertEquals(3,rows.length);assertEquals(0,new java.math.BigDecimal("15000000").compareTo(rows[0].getTotalRevenue()));
        assertEquals(0,new java.math.BigDecimal("179").compareTo(new SparePartDAO3(con).getPartDetail(17).getStockQty()));
        assertNotNull(new InvoiceDAO3(con).getSalesStaffByInvoice(15));
        assertEquals(2,new InvoiceDAO3(con).getInvoiceDetail(15,8,LocalDate.of(2026,8,1),LocalDate.of(2026,8,31)).getInvoiceServices().length);
    }
    @Test public void resumedUpgradeDoesNotDuplicateRolesOrBusinessData() throws Exception {
        SchemaMigration.upgrade(con);SchemaMigration.upgrade(con);
        try(Statement statement=con.createStatement();ResultSet rows=statement.executeQuery("SELECT COUNT(*) FROM tblStaff3")) { rows.next();assertEquals(3,rows.getInt(1)); }
        try(Statement statement=con.createStatement();ResultSet rows=statement.executeQuery("SELECT COUNT(*) FROM tblInvoice3")) { rows.next();assertEquals(7,rows.getInt(1)); }
    }
    @Test public void upgradedForeignKeysEnforceTheDesignedStaffRoles() throws Exception {
        SchemaMigration.upgrade(con);
        assertThrows(SQLException.class,()->con.createStatement().executeUpdate("UPDATE tblInvoice3 SET tblSalesStaff3id=3 WHERE id=15"));
        assertThrows(SQLException.class,()->con.createStatement().executeUpdate("UPDATE tblImportReceipt3 SET tblWarehouseStaff3id=2 WHERE id=1"));
    }
}
