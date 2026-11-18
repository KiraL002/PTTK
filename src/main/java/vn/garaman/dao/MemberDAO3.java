package vn.garaman.dao;

import java.sql.*;
import vn.garaman.model.Manager3;
import vn.garaman.util.PasswordHasher;

public class MemberDAO3 extends DAO3 {
    public MemberDAO3(Connection con) {
        super(con);
    }

    public Manager3 authenticateManager(String username, String password) throws SQLException {
        try (PreparedStatement statement =
                prepare(
                        "SELECT m.* FROM tblMember3 m WHERE LOWER(m.username)=LOWER(?) AND m.role='MANAGER'")) {
            statement.setString(1, username);
            try (ResultSet rows = statement.executeQuery()) {
                if (rows.next() && PasswordHasher.verify(password, rows.getString("password")))
                    return ModelMapper.staff(rows, new Manager3());
            }
        }
        return null;
    }
}
