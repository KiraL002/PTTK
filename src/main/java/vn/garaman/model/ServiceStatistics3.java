package vn.garaman.model;

import java.math.BigDecimal;

public class ServiceStatistics3 extends Service3 {
    private static final long serialVersionUID = 1L;
    private int usageCount;
    private BigDecimal totalRevenue = BigDecimal.ZERO;

    public int getUsageCount() { return usageCount; }
    public void setUsageCount(int usageCount) { this.usageCount = usageCount; }
    public BigDecimal getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(BigDecimal totalRevenue) { this.totalRevenue = totalRevenue == null ? BigDecimal.ZERO : totalRevenue; }
}
