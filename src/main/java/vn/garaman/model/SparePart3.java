package vn.garaman.model;

import java.math.BigDecimal;

public class SparePart3 implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private String name = "";
    private BigDecimal stockQty = BigDecimal.ZERO;
    private BigDecimal sellingPrice = BigDecimal.ZERO;
    private String description = "";
    private String unit = "";
    private String specification = "";
    private String applicableCar = "";
    private int warranty;
    private String status = "";

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public BigDecimal getStockQty() {
        return stockQty;
    }

    public void setStockQty(BigDecimal stockQty) {
        this.stockQty = stockQty == null ? BigDecimal.ZERO : stockQty;
    }

    public BigDecimal getSellingPrice() {
        return sellingPrice;
    }

    public void setSellingPrice(BigDecimal sellingPrice) {
        this.sellingPrice = sellingPrice == null ? BigDecimal.ZERO : sellingPrice;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public String getSpecification() {
        return specification;
    }

    public void setSpecification(String specification) {
        this.specification = specification;
    }

    public String getApplicableCar() {
        return applicableCar;
    }

    public void setApplicableCar(String applicableCar) {
        this.applicableCar = applicableCar;
    }

    public int getWarranty() {
        return warranty;
    }

    public void setWarranty(int warranty) {
        this.warranty = warranty;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCode() {
        return String.format("PT%02d", id);
    }

    public boolean isInStock() {
        return stockQty.signum() > 0;
    }
}
