package vn.garaman.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class SalesStaff3 extends Staff3 {
    private static final long serialVersionUID = 1L;
    private Invoice3[] invoices = new Invoice3[0];

    public Invoice3[] getInvoices() { return invoices.clone(); }
    public void setInvoices(Invoice3[] invoices) { this.invoices = invoices == null ? new Invoice3[0] : invoices.clone(); }
}
