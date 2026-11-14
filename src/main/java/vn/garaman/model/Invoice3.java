package vn.garaman.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class Invoice3 implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private LocalDateTime createdDate;
    private LocalDateTime paymentDate;
    private BigDecimal totalAmount = BigDecimal.ZERO;
    private String status = "";
    private String requestDescription = "";
    private String paymentMethod = "";
    private InvoiceService3[] invoiceServices = new InvoiceService3[0];
    private InvoicePart3[] invoiceParts = new InvoicePart3[0];

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public LocalDateTime getCreatedDate() { return createdDate; }
    public void setCreatedDate(LocalDateTime createdDate) { this.createdDate = createdDate; }
    public LocalDateTime getPaymentDate() { return paymentDate; }
    public void setPaymentDate(LocalDateTime paymentDate) { this.paymentDate = paymentDate; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount == null ? BigDecimal.ZERO : totalAmount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getRequestDescription() { return requestDescription; }
    public void setRequestDescription(String requestDescription) { this.requestDescription = requestDescription; }
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    public InvoiceService3[] getInvoiceServices() { return invoiceServices.clone(); }
    public void setInvoiceServices(InvoiceService3[] invoiceServices) { this.invoiceServices = invoiceServices == null ? new InvoiceService3[0] : invoiceServices.clone(); }
    public InvoicePart3[] getInvoiceParts() { return invoiceParts.clone(); }
    public void setInvoiceParts(InvoicePart3[] invoiceParts) { this.invoiceParts = invoiceParts == null ? new InvoicePart3[0] : invoiceParts.clone(); }

    public String getCode() { return String.format("HD%03d", id); }
    public BigDecimal getServiceTotal() { BigDecimal total = BigDecimal.ZERO; for (InvoiceService3 row : invoiceServices) total = total.add(row.getLineTotal()); return total; }
    public BigDecimal getPartTotal() { BigDecimal total = BigDecimal.ZERO; for (InvoicePart3 row : invoiceParts) total = total.add(row.getLineTotal()); return total; }
}
