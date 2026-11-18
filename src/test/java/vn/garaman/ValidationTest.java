package vn.garaman;

import org.junit.Test;
import static org.junit.Assert.*;
import vn.garaman.util.*;

public class ValidationTest {
    @Test
    public void dateValidationRejectsMissingImpossibleAndReversedDates() {
        for (String[] values :
                new String[][] {
                    {null, null},
                    {"2026-02-30", "2026-03-01"},
                    {"2026-09-01", "2026-08-31"},
                    {"0001-01-01", "2026-01-01"},
                    {"29/02/2026", "01/03/2026"},
                    {"01/09/2026", "31/08/2026"},
                    {"1/08/2026", "31/08/2026"}
                }) {
            assertThrows(IllegalArgumentException.class, () -> Period.parse(values[0], values[1]));
        }
        assertEquals(
                "2026-09-01 00:00:00.0",
                Period.parse("2026-08-31", "2026-08-31").getUntilTimestamp().toString());
    }

    @Test
    public void vietnameseDatesUseDayBeforeMonthAndPreserveIsoLinks() {
        Period period = Period.parse(" 29/02/2024 ", "2024-03-01");
        assertEquals("2024-02-29 00:00:00.0", period.getFromTimestamp().toString());
        assertEquals("2024-03-02 00:00:00.0", period.getUntilTimestamp().toString());
        assertEquals("2026-09-01", Period.parse("01/09/2026", "01/09/2026").getStartDate().toString());
    }

    @Test
    public void searchRejectsMarkupEmptyAndTooLongInput() {
        assertNotNull(SearchText.validate(""));
        assertNotNull(SearchText.validate("<script>alert(1)</script>"));
        assertNotNull(SearchText.validate("a".repeat(101)));
        assertNull(SearchText.validate("Dầu máy SAE 5W-30"));
        assertEquals("son phu gam", SearchText.normalize("SƠN PHỦ GẦM"));
    }

    @Test
    public void passwordHashIsSaltedAndMalformedHashesFailClosed() {
        String hash = PasswordHasher.hash("GaraMan@123");
        assertNotEquals(hash, PasswordHasher.hash("GaraMan@123"));
        assertTrue(PasswordHasher.verify("GaraMan@123", hash));
        assertFalse(PasswordHasher.verify("wrong", hash));
        assertFalse(PasswordHasher.verify("anything", "plain-text"));
    }
}
