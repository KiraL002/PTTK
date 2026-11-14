package vn.garaman.dao;

import java.sql.*;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.ZoneId;
import java.util.*;
import vn.garaman.model.*;
import vn.garaman.util.Period;

public class InvoiceDAO3 extends DAO3 {
    public InvoiceDAO3(Connection con) { super(con); }

    public YearMonth getLatestPaidMonth() throws SQLException {
        try (PreparedStatement statement = prepare("SELECT MAX(paymentDate) FROM tblInvoice3 WHERE status='PAID'"); ResultSet rows = statement.executeQuery()) {
            rows.next(); Timestamp timestamp = rows.getTimestamp(1);
            return timestamp == null ? YearMonth.now(ZoneId.of("Asia/Ho_Chi_Minh")) : YearMonth.from(timestamp.toLocalDateTime());
        }
    }

    public Invoice3[] getInvoiceList(int customerId, LocalDate startDate, LocalDate endDate) throws SQLException {
        Period period = new Period(startDate, endDate);
        List<Invoice3> invoices = new ArrayList<>();
        String sql = "SELECT i.*, " + INVOICE_TOTAL + " AS totalAmount FROM tblInvoice3 i "
                + "WHERE i.tblCustomer3id=? AND i.status='PAID' AND i.paymentDate>=? AND i.paymentDate<? ORDER BY i.paymentDate,i.id";
        try (PreparedStatement statement = prepare(sql)) {
            statement.setInt(1, customerId); statement.setTimestamp(2, period.getFromTimestamp()); statement.setTimestamp(3, period.getUntilTimestamp());
            try (ResultSet rows = statement.executeQuery()) { while (rows.next()) invoices.add(ModelMapper.invoice(rows)); }
        }
        return invoices.toArray(new Invoice3[0]);
    }

    public Invoice3 getInvoiceDetail(int invoiceId, int customerId, LocalDate startDate, LocalDate endDate) throws SQLException {
        Period period = new Period(startDate, endDate);
        Invoice3 invoice;
        String sql = "SELECT i.*, " + INVOICE_TOTAL + " AS totalAmount FROM tblInvoice3 i "
                + "WHERE i.id=? AND i.tblCustomer3id=? AND i.status='PAID' AND i.paymentDate>=? AND i.paymentDate<?";
        try (PreparedStatement statement = prepare(sql)) {
            statement.setInt(1, invoiceId); statement.setInt(2, customerId);
            statement.setTimestamp(3, period.getFromTimestamp()); statement.setTimestamp(4, period.getUntilTimestamp());
            try (ResultSet rows = statement.executeQuery()) { invoice = rows.next() ? ModelMapper.invoice(rows) : null; }
        }
        if (invoice == null) return null;
        List<InvoiceService3> services = new ArrayList<>();
        try (PreparedStatement statement = prepare("SELECT s.*,d.id AS lineId,d.quantity AS lineQty,d.price AS linePrice,d.technician,d.workStatus "
                + "FROM tblInvoiceService3 d JOIN tblService3 s ON s.id=d.tblService3id WHERE d.tblInvoice3id=? ORDER BY d.id")) {
            statement.setInt(1, invoiceId);
            try (ResultSet rows = statement.executeQuery()) {
                while (rows.next()) {
                    InvoiceService3 item = new InvoiceService3(); item.setId(rows.getInt("lineId"));
                    item.setQuantity(rows.getInt("lineQty")); item.setPrice(rows.getBigDecimal("linePrice"));
                    item.setTechnician(rows.getString("technician")); item.setWorkStatus(rows.getString("workStatus"));
                    item.setService(ModelMapper.service(rows)); services.add(item);
                }
            }
        }
        List<InvoicePart3> parts = new ArrayList<>();
        try (PreparedStatement statement = prepare("SELECT p.*, " + SparePartDAO3.STOCK + " AS stockQty, d.id AS lineId,d.quantity AS lineQty,d.price AS linePrice "
                + "FROM tblInvoicePart3 d JOIN tblSparePart3 p ON p.id=d.tblSparePart3id WHERE d.tblInvoice3id=? ORDER BY d.id")) {
            statement.setInt(1, invoiceId);
            try (ResultSet rows = statement.executeQuery()) {
                while (rows.next()) {
                    InvoicePart3 item = new InvoicePart3(); item.setId(rows.getInt("lineId"));
                    item.setQuantity(rows.getBigDecimal("lineQty")); item.setPrice(rows.getBigDecimal("linePrice"));
                    item.setSparePart(ModelMapper.part(rows)); parts.add(item);
                }
            }
        }
        invoice.setInvoiceServices(services.toArray(new InvoiceService3[0])); invoice.setInvoiceParts(parts.toArray(new InvoicePart3[0]));
        invoice.setTotalAmount(invoice.getServiceTotal().add(invoice.getPartTotal())); return invoice;
    }

    public Map<Integer, Car3> getCarsByInvoices(Invoice3[] invoices) throws SQLException {
        Map<Integer, Car3> cars = new HashMap<>();
        for (int offset = 0; offset < invoices.length; offset += 250) {
            int length = Math.min(250, invoices.length - offset);
            String marks = String.join(",", Collections.nCopies(length, "?"));
            try (PreparedStatement statement = prepare("SELECT c.*,i.id AS invoiceId FROM tblCar3 c JOIN tblInvoice3 i ON i.tblCar3id=c.id WHERE i.id IN (" + marks + ")")) {
                for (int i = 0; i < length; i++) statement.setInt(i + 1, invoices[offset + i].getId());
                try (ResultSet rows = statement.executeQuery()) { while (rows.next()) cars.put(rows.getInt("invoiceId"), ModelMapper.car(rows)); }
            }
        }
        return cars;
    }

    public SalesStaff3 getSalesStaffByInvoice(int invoiceId) throws SQLException {
        try (PreparedStatement statement = prepare("SELECT m.*,s.position FROM tblMember3 m JOIN tblStaff3 s ON s.tblMember3id=m.id JOIN tblSalesStaff3 ss ON ss.tblMember3id=s.tblMember3id JOIN tblInvoice3 i ON i.tblSalesStaff3id=ss.tblMember3id WHERE i.id=?")) {
            statement.setInt(1, invoiceId);
            try (ResultSet rows = statement.executeQuery()) { return rows.next() ? ModelMapper.staff(rows, new SalesStaff3()) : null; }
        }
    }
}
