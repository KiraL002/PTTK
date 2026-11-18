package vn.garaman.model;

public class Garage3 implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private String name = "";
    private String address = "";
    private String phone = "";
    private String description = "";
    private Warehouse3[] warehouses = new Warehouse3[0];

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

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Warehouse3[] getWarehouses() {
        return warehouses;
    }

    public void setWarehouses(Warehouse3[] warehouses) {
        this.warehouses = warehouses == null ? new Warehouse3[0] : warehouses;
    }
}
