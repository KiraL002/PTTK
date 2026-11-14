package vn.garaman.model;


public class Supplier3 implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private String name = "";
    private String taxCode = "";
    private String address = "";
    private String phone = "";
    private String email = "";
    private ImportReceipt3[] importReceipts = new ImportReceipt3[0];

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getTaxCode() { return taxCode; }
    public void setTaxCode(String taxCode) { this.taxCode = taxCode; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public ImportReceipt3[] getImportReceipts() { return importReceipts; }
    public void setImportReceipts(ImportReceipt3[] importReceipts) { this.importReceipts = importReceipts == null ? new ImportReceipt3[0] : importReceipts; }
}
