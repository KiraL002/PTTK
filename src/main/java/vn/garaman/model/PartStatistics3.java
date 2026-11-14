package vn.garaman.model;

import java.math.BigDecimal;

public class PartStatistics3 extends SparePart3 {
    private static final long serialVersionUID = 1L;
    private BigDecimal importQty = BigDecimal.ZERO;
    private BigDecimal exportQty = BigDecimal.ZERO;
    private BigDecimal totalRevenue = BigDecimal.ZERO;

    public BigDecimal getImportQty() { return importQty; }
    public void setImportQty(BigDecimal importQty) { this.importQty = importQty == null ? BigDecimal.ZERO : importQty; }
    public BigDecimal getExportQty() { return exportQty; }
    public void setExportQty(BigDecimal exportQty) { this.exportQty = exportQty == null ? BigDecimal.ZERO : exportQty; }
    public BigDecimal getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(BigDecimal totalRevenue) { this.totalRevenue = totalRevenue == null ? BigDecimal.ZERO : totalRevenue; }
}
