package vn.garaman.model;

import java.math.BigDecimal;

public class SupplierStatistics3 extends Supplier3 {
    private static final long serialVersionUID = 1L;
    private int receiptCount;
    private BigDecimal totalValue = BigDecimal.ZERO;

    public int getReceiptCount() { return receiptCount; }
    public void setReceiptCount(int receiptCount) { this.receiptCount = receiptCount; }
    public BigDecimal getTotalValue() { return totalValue; }
    public void setTotalValue(BigDecimal totalValue) { this.totalValue = totalValue == null ? BigDecimal.ZERO : totalValue; }
}
