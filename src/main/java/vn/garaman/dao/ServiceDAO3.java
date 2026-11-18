package vn.garaman.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import vn.garaman.model.Service3;
import vn.garaman.model.ServicePart3;
import vn.garaman.util.SearchText;

public class ServiceDAO3 extends DAO3 {
    public ServiceDAO3(Connection con) {
        super(con);
    }

    public Service3[] searchService(String keyword) throws SQLException {
        String normalizedKeyword = SearchText.normalize(keyword);
        List<Service3> result = new ArrayList<>();
        try (PreparedStatement statement =
                prepare("SELECT * FROM tblService3 WHERE status=? ORDER BY name,id")) {
            statement.setString(1, "ACTIVE");
            try (ResultSet rows = statement.executeQuery()) {
                // Normalize in Java to preserve identical Vietnamese accent-insensitive matching on
                // both databases.
                while (rows.next())
                    if (SearchText.normalize(rows.getString("name")).contains(normalizedKeyword))
                        result.add(ModelMapper.service(rows));
            }
        }
        return result.toArray(new Service3[0]);
    }

    public Service3 getServiceDetail(int serviceId) throws SQLException {
        Service3 service;
        try (PreparedStatement statement =
                prepare("SELECT * FROM tblService3 WHERE id=? AND status=?")) {
            statement.setInt(1, serviceId);
            statement.setString(2, "ACTIVE");
            try (ResultSet rows = statement.executeQuery()) {
                service = rows.next() ? ModelMapper.service(rows) : null;
            }
        }
        if (service == null)
            return null;
        List<ServicePart3> parts = new ArrayList<>();
        String sql =
                "SELECT p.*, "
                        + SparePartDAO3.STOCK
                        + " AS stockQty, sp.id AS relationId, sp.quantity AS requiredQty "
                        + "FROM tblServicePart3 sp JOIN tblSparePart3 p ON p.id=sp.tblSparePart3id WHERE sp.tblService3id=? AND p.status=? ORDER BY sp.id";
        try (PreparedStatement statement = prepare(sql)) {
            statement.setInt(1, serviceId);
            statement.setString(2, "ACTIVE");
            try (ResultSet rows = statement.executeQuery()) {
                while (rows.next()) {
                    ServicePart3 part = new ServicePart3();
                    part.setId(rows.getInt("relationId"));
                    part.setQuantity(rows.getBigDecimal("requiredQty"));
                    part.setSparePart(ModelMapper.part(rows));
                    parts.add(part);
                }
            }
        }
        service.setServiceParts(parts.toArray(new ServicePart3[0]));
        return service;
    }
}
