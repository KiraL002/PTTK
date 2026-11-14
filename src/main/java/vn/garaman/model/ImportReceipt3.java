package vn.garaman.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class ImportReceipt3 implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private LocalDateTime importDate;
    private BigDecimal totalAmount = BigDecimal.ZERO;
    private String status = "";
    private ImportDetail3[] importDetails = new ImportDetail3[0];

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public LocalDateTime getImportDate() { return importDate; }
    public void setImportDate(LocalDateTime importDate) { this.importDate = importDate; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount == null ? BigDecimal.ZERO : totalAmount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public ImportDetail3[] getImportDetails() { return importDetails; }
    public void setImportDetails(ImportDetail3[] importDetails) { this.importDetails = importDetails == null ? new ImportDetail3[0] : importDetails; }
}
