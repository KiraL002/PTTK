package vn.garaman.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import vn.garaman.model.SparePart3;
import vn.garaman.util.SearchText;

public class SparePartDAO3 extends DAO3 {
    static final String STOCK =
            "(COALESCE((SELECT SUM(d.quantity) FROM tblImportDetail3 d JOIN tblImportReceipt3 r ON r.id=d.tblImportReceipt3id WHERE d.tblSparePart3id=p.id AND r.status='RECEIVED'),0)"
                    + " - COALESCE((SELECT SUM(d.quantity) FROM tblInvoicePart3 d JOIN tblInvoice3 i ON i.id=d.tblInvoice3id WHERE d.tblSparePart3id=p.id AND i.status<>'CANCELLED'),0))";

    public SparePartDAO3(Connection con) {
        super(con);
    }

    public SparePart3[] searchPart(String keyword) throws SQLException {
        String normalizedKeyword = SearchText.normalize(keyword);
        List<SparePart3> result = new ArrayList<>();
        try (PreparedStatement statement =
                prepare(
                        "SELECT p.*, "
                                + STOCK
                                + " AS stockQty FROM tblSparePart3 p WHERE p.status=? ORDER BY p.name,p.id")) {
            statement.setString(1, "ACTIVE");
            try (ResultSet rows = statement.executeQuery()) {
                while (rows.next())
                    if (SearchText.normalize(rows.getString("name")).contains(normalizedKeyword))
                        result.add(ModelMapper.part(rows));
            }
        }
        return result.toArray(new SparePart3[0]);
    }

    public SparePart3 getPartDetail(int partId) throws SQLException {
        try (PreparedStatement statement =
                prepare(
                        "SELECT p.*, "
                                + STOCK
                                + " AS stockQty FROM tblSparePart3 p WHERE p.id=? AND p.status=?")) {
            statement.setInt(1, partId);
            statement.setString(2, "ACTIVE");
            try (ResultSet rows = statement.executeQuery()) {
                return rows.next() ? ModelMapper.part(rows) : null;
            }
        }
    }
}
