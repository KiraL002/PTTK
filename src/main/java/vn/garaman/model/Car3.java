package vn.garaman.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class Car3 implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private String licensePlate = "";
    private String brand = "";
    private String model = "";
    private Integer year;
    private Invoice3[] invoices = new Invoice3[0];

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getLicensePlate() { return licensePlate; }
    public void setLicensePlate(String licensePlate) { this.licensePlate = licensePlate; }
    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }
    public String getModel() { return model; }
    public void setModel(String model) { this.model = model; }
    public Integer getYear() { return year; }
    public void setYear(Integer year) { this.year = year; }
    public Invoice3[] getInvoices() { return invoices.clone(); }
    public void setInvoices(Invoice3[] invoices) { this.invoices = invoices == null ? new Invoice3[0] : invoices.clone(); }
}
