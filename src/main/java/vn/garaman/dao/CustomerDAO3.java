package vn.garaman.dao;

import java.sql.*;
import vn.garaman.model.Customer3;

public class CustomerDAO3 extends DAO3 {
    public CustomerDAO3(Connection con) {
        super(con);
    }

    public Customer3 getCustomerById(int customerId) throws SQLException {
        try (PreparedStatement statement = prepare("SELECT * FROM tblCustomer3 WHERE id=?")) {
            statement.setInt(1, customerId);
            try (ResultSet rows = statement.executeQuery()) {
                return rows.next() ? ModelMapper.customer(rows, new Customer3()) : null;
            }
        }
    }
}
