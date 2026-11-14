package vn.garaman.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class Customer3 implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private String fullName = "";
    private String address = "";
    private String phone = "";
    private String customerType = "";
    private Car3[] cars = new Car3[0];
    private Appointment3[] appointments = new Appointment3[0];
    private Invoice3[] invoices = new Invoice3[0];

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getCustomerType() { return customerType; }
    public void setCustomerType(String customerType) { this.customerType = customerType; }
    public Car3[] getCars() { return cars.clone(); }
    public void setCars(Car3[] cars) { this.cars = cars == null ? new Car3[0] : cars.clone(); }
    public Appointment3[] getAppointments() { return appointments.clone(); }
    public void setAppointments(Appointment3[] appointments) { this.appointments = appointments == null ? new Appointment3[0] : appointments.clone(); }
    public Invoice3[] getInvoices() { return invoices.clone(); }
    public void setInvoices(Invoice3[] invoices) { this.invoices = invoices == null ? new Invoice3[0] : invoices.clone(); }

    public String getCode() { return String.format("KH%02d", id); }
}
