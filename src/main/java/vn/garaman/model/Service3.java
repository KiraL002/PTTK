package vn.garaman.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class Service3 implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private String name = "";
    private BigDecimal price = BigDecimal.ZERO;
    private Integer duration;
    private String description = "";
    private String category = "";
    private String applicableCar = "";
    private int warranty;
    private String status = "";
    private ServicePart3[] serviceParts = new ServicePart3[0];

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price == null ? BigDecimal.ZERO : price; }
    public Integer getDuration() { return duration; }
    public void setDuration(Integer duration) { this.duration = duration; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getApplicableCar() { return applicableCar; }
    public void setApplicableCar(String applicableCar) { this.applicableCar = applicableCar; }
    public int getWarranty() { return warranty; }
    public void setWarranty(int warranty) { this.warranty = warranty; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public ServicePart3[] getServiceParts() { return serviceParts.clone(); }
    public void setServiceParts(ServicePart3[] serviceParts) { this.serviceParts = serviceParts == null ? new ServicePart3[0] : serviceParts.clone(); }

    public String getCode() { return String.format("DV%02d", id); }
}
