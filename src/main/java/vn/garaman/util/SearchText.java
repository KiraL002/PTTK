package vn.garaman.util;

import java.text.Normalizer;
import java.util.Locale;

public final class SearchText {
    private SearchText() {}

    public static String clean(String text) {
        return text == null ? "" : text.strip().replaceAll("\\s+", " ");
    }

    public static String normalize(String text) {
        return Normalizer.normalize(clean(text), Normalizer.Form.NFD)
                .replaceAll("\\p{M}+", "")
                .replace('đ', 'd')
                .replace('Đ', 'D')
                .toLowerCase(Locale.ROOT);
    }

    public static String validate(String text) {
        if (clean(text).isEmpty())
            return "Vui lòng nhập tên dịch vụ hoặc phụ tùng cần tìm.";
        if (text.length() > 100)
            return "Từ khóa chỉ được tối đa 100 ký tự.";
        if (!text.matches("[\\p{L}\\p{N}\\p{M}\\s.,()+/\\-]+"))
            return "Từ khóa chỉ được chứa chữ, số, khoảng trắng và các dấu . , ( ) + / -.";
        return null;
    }
}
