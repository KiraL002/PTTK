package vn.garaman.model;


public class WarehouseStaff3 extends Staff3 {
    private static final long serialVersionUID = 1L;
    private ImportReceipt3[] importReceipts = new ImportReceipt3[0];

    public ImportReceipt3[] getImportReceipts() { return importReceipts; }
    public void setImportReceipts(ImportReceipt3[] importReceipts) { this.importReceipts = importReceipts == null ? new ImportReceipt3[0] : importReceipts; }
}
