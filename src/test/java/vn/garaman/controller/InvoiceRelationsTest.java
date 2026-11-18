package vn.garaman.controller;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;
import vn.garaman.config.Database;
import vn.garaman.model.*;
import vn.garaman.util.Period;

/** Exercises view preparation with real DAO queries and captures the forwarded JSP data. */
public class InvoiceRelationsTest {
    private Connection con;
    private Page page;

    @Before
    public void setup() throws Exception {
        con =
                DriverManager.getConnection(
                        "jdbc:h2:mem:" + UUID.randomUUID() + ";MODE=MySQL;DATABASE_TO_LOWER=TRUE",
                        "sa",
                        "");
        Database.initialize(con, true, true, "admin", "GaraMan@123");
        page = new Page();
    }

    @After
    public void close() throws Exception {
        con.close();
    }

    @Test
    public void visitsConnectCustomerInvoicesAndCarsUsedByTheTable() throws Exception {
        page.parameters.put("customerId", "2");
        invoke("showCustomerVisits");

        Customer3 customer = (Customer3) page.attributes.get("customer");
        Invoice3[] invoices = (Invoice3[]) page.attributes.get("invoices");
        assertEquals(2, invoices.length);
        assertArrayEquals(invoices, customer.getInvoices());
        for (Invoice3 invoice : invoices) {
            assertSame(customer, invoice.getCustomer());
            assertEquals("30A-123.45", invoice.getCar().getLicensePlate());
        }
        assertEquals(
                0,
                new BigDecimal("15000000")
                        .compareTo((BigDecimal) page.attributes.get("totalRevenue")));
        assertEquals("/WEB-INF/view/manager/customer-visits.jsp", page.forwarded);
    }

    @Test
    public void invoiceDetailIncludesCustomerCarAndStaff() throws Exception {
        page.parameters.put("customerId", "2");
        page.parameters.put("invoiceId", "2");
        invoke("showInvoiceDetail");

        Invoice3 invoice = (Invoice3) page.attributes.get("invoice");
        assertEquals(2, invoice.getCustomer().getId());
        assertEquals(2, invoice.getSalesStaff().getId());
        assertEquals("30A-123.45", invoice.getCar().getLicensePlate());
        assertEquals(2, invoice.getInvoiceServices().length);
        assertEquals(2, invoice.getInvoiceParts().length);
        assertEquals(0, new BigDecimal("10000000").compareTo(invoice.getTotalAmount()));
        assertEquals("/WEB-INF/view/manager/invoice-detail.jsp", page.forwarded);
    }

    @Test
    public void wrongCustomerCannotReceiveTheOtherCustomersInvoiceOrRelations() throws Exception {
        page.parameters.put("customerId", "3");
        page.parameters.put("invoiceId", "2");
        invoke("showInvoiceDetail");

        assertEquals(404, page.status);
        assertFalse(page.attributes.containsKey("invoice"));
        Customer3 customer = (Customer3) page.attributes.get("customer");
        assertEquals(3, customer.getId());
        for (Invoice3 invoice : customer.getInvoices()) {
            assertNotEquals(2, invoice.getId());
            assertSame(customer, invoice.getCustomer());
        }
        assertEquals("/WEB-INF/view/manager/customer-visits.jsp", page.forwarded);
    }

    private void invoke(String methodName) throws Exception {
        Method method =
                CustomerStatisticsServlet3.class.getDeclaredMethod(
                        methodName,
                        HttpServletRequest.class,
                        HttpServletResponse.class,
                        Connection.class,
                        Period.class);
        method.setAccessible(true);
        try {
            method.invoke(
                    new CustomerStatisticsServlet3(),
                    page.request,
                    page.response,
                    con,
                    new Period(LocalDate.of(2026, 8, 1), LocalDate.of(2026, 8, 31)));
        } catch (InvocationTargetException ex) {
            throw new AssertionError("View preparation failed", ex.getCause());
        }
    }

    private static final class Page {
        private final Map<String, String> parameters = new HashMap<>();
        private final Map<String, Object> attributes = new HashMap<>();
        private String forwarded;
        private int status = 200;
        private final HttpServletRequest request =
                (HttpServletRequest)
                        Proxy.newProxyInstance(
                                HttpServletRequest.class.getClassLoader(),
                                new Class<?>[] {HttpServletRequest.class},
                                (proxy, method, args) -> {
                                    switch (method.getName()) {
                                        case "getParameter":
                                            return parameters.get(args[0]);
                                        case "getAttribute":
                                            return attributes.get(args[0]);
                                        case "setAttribute":
                                            attributes.put((String) args[0], args[1]);
                                            return null;
                                        case "getRequestDispatcher":
                                            String path = (String) args[0];
                                            return new RequestDispatcher() {
                                                public void forward(
                                                        ServletRequest req, ServletResponse res) {
                                                    forwarded = path;
                                                }

                                                public void include(
                                                        ServletRequest req, ServletResponse res) {
                                                    throw new UnsupportedOperationException(
                                                            "include");
                                                }
                                            };
                                        default:
                                            throw new UnsupportedOperationException(
                                                    method.getName());
                                    }
                                });
        private final HttpServletResponse response =
                (HttpServletResponse)
                        Proxy.newProxyInstance(
                                HttpServletResponse.class.getClassLoader(),
                                new Class<?>[] {HttpServletResponse.class},
                                (proxy, method, args) -> {
                                    if (method.getName().equals("setStatus")) {
                                        status = (Integer) args[0];
                                        return null;
                                    }
                                    throw new UnsupportedOperationException(method.getName());
                                });
    }
}
