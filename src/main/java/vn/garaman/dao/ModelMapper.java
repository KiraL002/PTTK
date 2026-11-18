package vn.garaman.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import vn.garaman.model.*;

final class ModelMapper {
    private ModelMapper() {}

    static Service3 service(ResultSet row) throws SQLException {
        Service3 value = new Service3();
        value.setId(row.getInt("id"));
        value.setName(row.getString("name"));
        value.setPrice(row.getBigDecimal("price"));
        Number duration = (Number) row.getObject("duration");
        value.setDuration(duration == null ? null : duration.intValue());
        value.setDescription(row.getString("description"));
        value.setCategory(row.getString("category"));
        value.setApplicableCar(row.getString("applicableCar"));
        value.setWarranty(row.getInt("warranty"));
        value.setStatus(row.getString("status"));
        return value;
    }

    static SparePart3 part(ResultSet row) throws SQLException {
        SparePart3 value = new SparePart3();
        value.setId(row.getInt("id"));
        value.setName(row.getString("name"));
        value.setSellingPrice(row.getBigDecimal("sellingPrice"));
        value.setStockQty(row.getBigDecimal("stockQty"));
        value.setDescription(row.getString("description"));
        value.setUnit(row.getString("unit"));
        value.setSpecification(row.getString("specification"));
        value.setApplicableCar(row.getString("applicableCar"));
        value.setWarranty(row.getInt("warranty"));
        value.setStatus(row.getString("status"));
        return value;
    }

    static <T extends Customer3> T customer(ResultSet row, T value) throws SQLException {
        value.setId(row.getInt("id"));
        value.setFullName(row.getString("fullName"));
        value.setAddress(row.getString("address"));
        value.setPhone(row.getString("phone"));
        value.setCustomerType(row.getString("customerType"));
        return value;
    }

    static Car3 car(ResultSet row) throws SQLException {
        Car3 value = new Car3();
        value.setId(row.getInt("id"));
        value.setLicensePlate(row.getString("licensePlate"));
        value.setBrand(row.getString("brand"));
        value.setModel(row.getString("model"));
        Number year = (Number) row.getObject("year");
        value.setYear(year == null ? null : year.intValue());
        return value;
    }

    static Invoice3 invoice(ResultSet row) throws SQLException {
        Invoice3 value = new Invoice3();
        value.setId(row.getInt("id"));
        Timestamp created = row.getTimestamp("createdDate"), paid = row.getTimestamp("paymentDate");
        value.setCreatedDate(created == null ? null : created.toLocalDateTime());
        value.setPaymentDate(paid == null ? null : paid.toLocalDateTime());
        value.setStatus(row.getString("status"));
        value.setRequestDescription(row.getString("requestDescription"));
        value.setPaymentMethod(row.getString("paymentMethod"));
        return value;
    }

    static <T extends Staff3> T staff(ResultSet row, T value) throws SQLException {
        value.setId(row.getInt("id"));
        value.setFullName(row.getString("fullName"));
        value.setAddress(row.getString("address"));
        value.setUsername(row.getString("username"));
        value.setPhone(row.getString("phone"));
        value.setEmail(row.getString("email"));
        // The database discriminator maps to the existing Staff3 position property.
        value.setPosition(row.getString("role"));
        return value;
    }
}
