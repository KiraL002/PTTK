package vn.garaman.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class Staff3 extends Member3 {
    private static final long serialVersionUID = 1L;
    private String position = "";

    public String getPosition() { return position; }
    public void setPosition(String position) { this.position = position; }
}
