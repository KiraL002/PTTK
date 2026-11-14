package vn.garaman.dao;

import java.sql.*;
import vn.garaman.model.Manager3;
import vn.garaman.util.PasswordHasher;

public class MemberDAO3 extends DAO3 {
    public MemberDAO3(Connection con) { super(con); }
    public Manager3 authenticateManager(String username, String password) throws SQLException {
        try (PreparedStatement statement = prepare("SELECT m.*,s.position FROM tblMember3 m JOIN tblStaff3 s ON s.tblMember3id=m.id JOIN tblManager3 g ON g.tblMember3id=s.tblMember3id WHERE LOWER(m.username)=LOWER(?)")) {
            statement.setString(1, username);
            try (ResultSet rows = statement.executeQuery()) {
                if (rows.next() && PasswordHasher.verify(password, rows.getString("password")))
                    return ModelMapper.staff(rows, new Manager3());
            }
        }
        return null;
    }
}
