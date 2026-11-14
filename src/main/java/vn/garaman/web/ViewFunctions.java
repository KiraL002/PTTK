package vn.garaman.web;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

public final class ViewFunctions {
    private ViewFunctions() { }

    public static String money(Object value) { return number(value, 2); }
    public static String quantity(Object value) { return number(value, 3); }
    private static String number(Object value, int decimals) {
        NumberFormat format = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
        format.setMaximumFractionDigits(decimals);
        return format.format(value instanceof Number ? value : BigDecimal.ZERO);
    }

    public static String date(Object value) {
        if (value instanceof LocalDate) return ((LocalDate) value).format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        if (value instanceof LocalDateTime) return ((LocalDateTime) value).format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
        return "—";
    }
}
