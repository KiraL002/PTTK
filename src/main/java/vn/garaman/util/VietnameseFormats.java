package vn.garaman.util;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.time.format.ResolverStyle;
import java.util.Locale;

public final class VietnameseFormats {
    public static final Locale LOCALE = Locale.forLanguageTag("vi-VN");
    public static final DateTimeFormatter DATE =
            DateTimeFormatter.ofPattern("dd/MM/uuuu", LOCALE).withResolverStyle(ResolverStyle.STRICT);
    public static final DateTimeFormatter DATE_TIME =
            DateTimeFormatter.ofPattern("dd/MM/uuuu HH:mm", LOCALE);

    private VietnameseFormats() {}

    public static LocalDate parseDate(String value) {
        String date = value.strip();
        if (date.length() != 10)
            throw new DateTimeParseException("Expected a date with a four-digit year", date, 0);
        // Existing report links use ISO dates.
        return date.matches("[0-9]{4}-[0-9]{2}-[0-9]{2}")
                ? LocalDate.parse(date)
                : LocalDate.parse(date, DATE);
    }
}
