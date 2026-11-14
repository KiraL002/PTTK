package vn.garaman.util;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

/** Inclusive calendar dates, translated into an exclusive upper SQL timestamp. */
public final class Period {
    private final LocalDate startDate;
    private final LocalDate endDate;

    public Period(LocalDate startDate, LocalDate endDate) {
        if (startDate == null || endDate == null || startDate.getYear() < 1900 || endDate.getYear() > 9998 || startDate.isAfter(endDate))
            throw new IllegalArgumentException("Ngày kết thúc phải từ ngày bắt đầu trở đi, trong khoảng năm 1900–9998.");
        this.startDate = startDate;
        this.endDate = endDate;
    }

    public static Period parse(String startDate, String endDate) {
        if (startDate == null || endDate == null || !startDate.matches("\\d{4}-\\d{2}-\\d{2}") || !endDate.matches("\\d{4}-\\d{2}-\\d{2}"))
            throw new IllegalArgumentException("Vui lòng chọn đầy đủ ngày bắt đầu và ngày kết thúc hợp lệ.");
        try { return new Period(LocalDate.parse(startDate), LocalDate.parse(endDate)); }
        catch (DateTimeParseException ex) { throw new IllegalArgumentException("Ngày thống kê không hợp lệ."); }
    }

    public LocalDate getStartDate() { return startDate; }
    public LocalDate getEndDate() { return endDate; }
    public Timestamp getFromTimestamp() { return Timestamp.valueOf(startDate.atStartOfDay()); }
    public Timestamp getUntilTimestamp() { return Timestamp.valueOf(endDate.plusDays(1).atStartOfDay()); }
}
