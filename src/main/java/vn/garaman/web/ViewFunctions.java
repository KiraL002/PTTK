package vn.garaman.web;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import vn.garaman.util.VietnameseFormats;

public final class ViewFunctions {
    private ViewFunctions() {}

    public static String money(Object value) {
        return number(value, 2);
    }

    public static String quantity(Object value) {
        return number(value, 3);
    }

    private static String number(Object value, int decimals) {
        NumberFormat format = NumberFormat.getNumberInstance(VietnameseFormats.LOCALE);
        format.setMaximumFractionDigits(decimals);
        return format.format(value instanceof Number ? value : BigDecimal.ZERO);
    }

    public static String date(Object value) {
        if (value instanceof LocalDate)
            return ((LocalDate) value).format(VietnameseFormats.DATE);
        if (value instanceof LocalDateTime)
            return ((LocalDateTime) value).format(VietnameseFormats.DATE_TIME);
        return "—";
    }

    public static String dateInput(Object value) {
        if (value instanceof LocalDate)
            return date(value);
        if (value instanceof String) {
            try {
                return date(VietnameseFormats.parseDate((String) value));
            } catch (DateTimeParseException ex) {
                // Keep invalid entries visible so that the manager can correct them.
                return (String) value;
            }
        }
        return "";
    }
}
