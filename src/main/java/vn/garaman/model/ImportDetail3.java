package vn.garaman.model;

import java.math.BigDecimal;

public class ImportDetail3 implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private BigDecimal quantity = BigDecimal.ZERO;
    private BigDecimal importPrice = BigDecimal.ZERO;
    private SparePart3 sparePart;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public BigDecimal getQuantity() { return quantity; }
    public void setQuantity(BigDecimal quantity) { this.quantity = quantity == null ? BigDecimal.ZERO : quantity; }
    public BigDecimal getImportPrice() { return importPrice; }
    public void setImportPrice(BigDecimal importPrice) { this.importPrice = importPrice == null ? BigDecimal.ZERO : importPrice; }
    public SparePart3 getSparePart() { return sparePart; }
    public void setSparePart(SparePart3 sparePart) { this.sparePart = sparePart; }
}
