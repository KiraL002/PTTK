package vn.garaman.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class ServicePart3 implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private BigDecimal quantity = BigDecimal.ZERO;
    private SparePart3 sparePart;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public BigDecimal getQuantity() { return quantity; }
    public void setQuantity(BigDecimal quantity) { this.quantity = quantity == null ? BigDecimal.ZERO : quantity; }
    public SparePart3 getSparePart() { return sparePart; }
    public void setSparePart(SparePart3 sparePart) { this.sparePart = sparePart; }
}
