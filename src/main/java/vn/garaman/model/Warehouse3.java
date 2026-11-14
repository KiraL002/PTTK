package vn.garaman.model;


public class Warehouse3 implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private String name = "";
    private Integer capacity;
    private String description = "";
    private ImportReceipt3[] importReceipts = new ImportReceipt3[0];

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public Integer getCapacity() { return capacity; }
    public void setCapacity(Integer capacity) { this.capacity = capacity; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public ImportReceipt3[] getImportReceipts() { return importReceipts; }
    public void setImportReceipts(ImportReceipt3[] importReceipts) { this.importReceipts = importReceipts == null ? new ImportReceipt3[0] : importReceipts; }
}
