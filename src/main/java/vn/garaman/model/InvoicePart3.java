package vn.garaman.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class InvoicePart3 implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private BigDecimal quantity = BigDecimal.ZERO;
    private BigDecimal price = BigDecimal.ZERO;
    private SparePart3 sparePart;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public BigDecimal getQuantity() { return quantity; }
    public void setQuantity(BigDecimal quantity) { this.quantity = quantity == null ? BigDecimal.ZERO : quantity; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price == null ? BigDecimal.ZERO : price; }
    public SparePart3 getSparePart() { return sparePart; }
    public void setSparePart(SparePart3 sparePart) { this.sparePart = sparePart; }

    public BigDecimal getLineTotal() { return price.multiply(quantity); }
}
