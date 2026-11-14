package vn.garaman;
import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.util.UUID;
import org.junit.*;
import static org.junit.Assert.*;
import vn.garaman.config.Database;
import vn.garaman.dao.*;
import vn.garaman.model.*;

public class DataAccessTest {
    private Connection con;
    private final LocalDate start=LocalDate.of(2026,8,1),end=LocalDate.of(2026,8,31);
    @Before public void setup() throws Exception {
        con=DriverManager.getConnection("jdbc:h2:mem:"+UUID.randomUUID()+";MODE=MySQL;DATABASE_TO_LOWER=TRUE","sa","");
        Database.initialize(con,true,true,"admin","GaraMan@123");
    }
    @After public void close() throws Exception {con.close();}
    private void money(String expected,BigDecimal actual) {assertEquals(0,new BigDecimal(expected).compareTo(actual));}
    @Test public void aggregatesPaidInvoicesWithoutMultiplyingDetailRows() throws Exception {
        CustomerStatistics3[] rows=new CustomerStatisticsDAO3(con).getStatistics(start,end);
        assertEquals(3,rows.length);assertEquals(8,rows[0].getId());assertEquals(2,rows[0].getVisitCount());money("15000000",rows[0].getTotalRevenue());
        BigDecimal total=BigDecimal.ZERO;int count=0;for(CustomerStatistics3 r:rows){total=total.add(r.getTotalRevenue());count+=r.getVisitCount();}
        money("28500000",total);assertEquals(6,count);
    }
    @Test public void detailTotalsUseHistoricalPricesAndIncludeBothLists() throws Exception {
        con.createStatement().executeUpdate("UPDATE tblService3 SET price=999999,status='INACTIVE' WHERE id=1");
        con.createStatement().executeUpdate("UPDATE tblSparePart3 SET sellingPrice=1,status='INACTIVE' WHERE id=17");
        Invoice3 invoice=new InvoiceDAO3(con).getInvoiceDetail(15,8,start,end);
        assertEquals(2,invoice.getInvoiceServices().length);assertEquals(2,invoice.getInvoiceParts().length);
        money("7500000",invoice.getServiceTotal());money("2500000",invoice.getPartTotal());money("10000000",invoice.getTotalAmount());
    }
    @Test public void detailRejectsWrongCustomerPeriodAndUnpaidInvoice() throws Exception {
        InvoiceDAO3 dao=new InvoiceDAO3(con);
        assertNull(dao.getInvoiceDetail(15,12,start,end));assertNull(dao.getInvoiceDetail(15,8,LocalDate.of(2026,9,1),LocalDate.of(2026,9,30)));
        assertNull(dao.getInvoiceDetail(99,8,start,end));assertNull(dao.getInvoiceDetail(999,8,start,end));
    }
    @Test public void dateBoundsIncludeLastSecondAndExcludeFollowingMidnight() throws Exception {
        con.createStatement().executeUpdate("UPDATE tblInvoice3 SET paymentDate='2026-08-31 23:59:59' WHERE id=15");
        con.createStatement().executeUpdate("UPDATE tblInvoice3 SET paymentDate='2026-09-01 00:00:00' WHERE id=42");
        Invoice3[] rows=new InvoiceDAO3(con).getInvoiceList(8,LocalDate.of(2026,8,31),end);
        assertEquals(1,rows.length);assertEquals(15,rows[0].getId());
    }
    @Test public void searchSupportsVietnameseAndHidesInactiveCatalog() throws Exception {
        ServiceDAO3 services=new ServiceDAO3(con);SparePartDAO3 parts=new SparePartDAO3(con);
        assertEquals(2,services.searchService("son phu gam").length);assertEquals(1,parts.searchPart("SƠN PHỦ GẦM").length);
        assertNull(services.getServiceDetail(4));assertNull(parts.getPartDetail(18));assertEquals(0,services.searchService("zzzzzz").length);
        assertEquals(1,services.getServiceDetail(1).getServiceParts().length);
    }
    @Test public void stockReflectsReceivedImportsAndConsumedInvoiceParts() throws Exception {
        SparePartDAO3 dao=new SparePartDAO3(con);money("179",dao.getPartDetail(17).getStockQty());
        con.createStatement().executeUpdate("UPDATE tblInvoice3 SET status='CANCELLED' WHERE id=15");
        money("183",dao.getPartDetail(17).getStockQty());
    }
    @Test public void fractionQuantitiesStayExact() throws Exception {
        con.createStatement().executeUpdate("UPDATE tblInvoicePart3 SET quantity=1.125 WHERE tblInvoice3id=11");
        money("562500",new InvoiceDAO3(con).getInvoiceDetail(11,5,start,end).getTotalAmount());
    }
    @Test public void lookupReturnsCarsForOnlyRequestedInvoices() throws Exception {
        InvoiceDAO3 dao=new InvoiceDAO3(con);Invoice3[] rows=dao.getInvoiceList(8,start,end);
        assertEquals(2,dao.getCarsByInvoices(rows).size());assertEquals("30A-123.45",dao.getCarsByInvoices(rows).get(15).getLicensePlate());
        assertTrue(dao.getCarsByInvoices(new Invoice3[0]).isEmpty());assertNotNull(dao.getSalesStaffByInvoice(15));
    }
    @Test public void onlyCorrectManagerCredentialsAuthenticate() throws Exception {
        MemberDAO3 dao=new MemberDAO3(con);assertNotNull(dao.authenticateManager("ADMIN","GaraMan@123"));
        assertNull(dao.authenticateManager("admin","wrong"));assertNull(dao.authenticateManager("sales","!disabled!"));
        assertNull(dao.authenticateManager("' OR 1=1 --","GaraMan@123"));
    }
    @Test public void startingAgainDoesNotResetExistingData() throws Exception {
        con.createStatement().executeUpdate("UPDATE tblService3 SET price=123 WHERE id=1");
        Database.initialize(con,true,true,"other","OtherPass123");money("123",new ServiceDAO3(con).getServiceDetail(1).getPrice());
        assertNotNull(new MemberDAO3(con).authenticateManager("admin","GaraMan@123"));
    }
    @Test public void periodWithNoPaymentsHasEmptyResult() throws Exception {
        assertEquals(0,new CustomerStatisticsDAO3(con).getStatistics(LocalDate.of(2027,1,1),LocalDate.of(2027,1,31)).length);
    }
}
