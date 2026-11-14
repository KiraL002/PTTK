package vn.garaman.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class InvoiceService3 implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private int quantity;
    private BigDecimal price = BigDecimal.ZERO;
    private String technician = "";
    private String workStatus = "";
    private Service3 service;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price == null ? BigDecimal.ZERO : price; }
    public String getTechnician() { return technician; }
    public void setTechnician(String technician) { this.technician = technician; }
    public String getWorkStatus() { return workStatus; }
    public void setWorkStatus(String workStatus) { this.workStatus = workStatus; }
    public Service3 getService() { return service; }
    public void setService(Service3 service) { this.service = service; }

    public BigDecimal getLineTotal() { return price.multiply(BigDecimal.valueOf(quantity)); }
}
