package vn.garaman.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public abstract class DAO3 {
    protected final Connection con;
    protected static final String INVOICE_TOTAL =
            "(COALESCE((SELECT SUM(ds.quantity * ds.price) FROM tblInvoiceService3 ds WHERE ds.tblInvoice3id = i.id),0)"
                    + " + COALESCE((SELECT SUM(dp.quantity * dp.price) FROM tblInvoicePart3 dp WHERE dp.tblInvoice3id = i.id),0))";

    protected DAO3(Connection con) {
        this.con = con;
    }

    protected PreparedStatement prepare(String sql) throws SQLException {
        PreparedStatement statement = con.prepareStatement(sql);
        statement.setQueryTimeout(10);
        return statement;
    }
}
