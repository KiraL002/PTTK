package vn.garaman.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class CustomerStatistics3 extends Customer3 {
    private static final long serialVersionUID = 1L;
    private BigDecimal totalRevenue = BigDecimal.ZERO;
    private int visitCount;

    public BigDecimal getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(BigDecimal totalRevenue) { this.totalRevenue = totalRevenue == null ? BigDecimal.ZERO : totalRevenue; }
    public int getVisitCount() { return visitCount; }
    public void setVisitCount(int visitCount) { this.visitCount = visitCount; }
}
