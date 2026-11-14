package vn.garaman.config;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.util.Enumeration;
import vn.garaman.util.PasswordHasher;

/** One database per web application; each request owns and closes its JDBC connection. */
public final class Database {
    private static String url;
    private static String user;
    private static String password;
    private static Connection anchor;
    private Database() { }

    public static synchronized void start() throws SQLException {
        if (anchor != null) return;
        String defaultUrl = "jdbc:mysql://127.0.0.1:3306/garaman3?connectionTimeZone=Asia/Ho_Chi_Minh&characterEncoding=UTF-8";
        url = setting("garaman.db.url", "GARAMAN_DB_URL", defaultUrl);
        if (url.isBlank()) url = defaultUrl;
        boolean embedded = url.startsWith("jdbc:h2:");
        if (!embedded && !url.startsWith("jdbc:mysql:")) throw new SQLException("Chỉ hỗ trợ JDBC H2 hoặc MySQL.");
        user = setting("garaman.db.user", "GARAMAN_DB_USER", embedded ? "sa" : "garaman");
        if (user.isBlank()) user = embedded ? "sa" : "garaman";
        password = setting("garaman.db.password", "GARAMAN_DB_PASSWORD", "");
        if (!embedded && user.isEmpty()) throw new SQLException("Cần cấu hình GARAMAN_DB_USER cho MySQL.");
        try { Class.forName(embedded ? "org.h2.Driver" : "com.mysql.cj.jdbc.Driver"); }
        catch (ClassNotFoundException ex) { throw new SQLException("Thiếu JDBC driver.", ex); }
        DriverManager.setLoginTimeout(10);
        Connection opened = DriverManager.getConnection(url, user, password);
        try {
            if (SchemaMigration.isLegacy(opened)) {
                if (!Boolean.parseBoolean(setting("garaman.db.migrate", "GARAMAN_DB_MIGRATE", "false")))
                    throw new SQLException("CSDL đang dùng cấu trúc cũ. Sao lưu trước, rồi bật GARAMAN_DB_MIGRATE=true để đồng bộ bản thiết kế.");
                SchemaMigration.upgrade(opened);
            }
            boolean create = Boolean.parseBoolean(setting("garaman.db.init", "GARAMAN_DB_INIT", Boolean.toString(embedded)));
            boolean seed = Boolean.parseBoolean(setting("garaman.db.seed", "GARAMAN_SEED_DEMO", Boolean.toString(embedded)));
            initialize(opened, create, seed,
                    setting("garaman.admin.username", "GARAMAN_ADMIN_USERNAME", "admin"),
                    setting("garaman.admin.password", "GARAMAN_ADMIN_PASSWORD", "GaraMan@123"));
            anchor = opened;
        } catch (SQLException | RuntimeException ex) { opened.close(); throw ex; }
    }

    public static Connection open() throws SQLException {
        if (anchor == null) throw new SQLException("CSDL chưa được khởi tạo.");
        return DriverManager.getConnection(url, user, password);
    }

    public static String getBackend() {
        if (url == null) return "unknown";
        return url.startsWith("jdbc:mysql:") ? "mysql" : "h2";
    }

    public static void initialize(Connection connection, boolean create, boolean seed, String adminName, String adminPassword) throws SQLException {
        if (create) executeResource(connection, "/schema.sql");
        if (!hasTable(connection, "tblMember3")) throw new SQLException("Chưa có cấu trúc CSDL GaraMan; hãy nhập schema.sql hoặc bật GARAMAN_DB_INIT.");
        if (!seed || count(connection, "tblMember3") != 0 || count(connection, "tblCustomer3") != 0
                || count(connection, "tblService3") != 0 || count(connection, "tblInvoice3") != 0) return;
        if (adminName == null || !adminName.matches("[A-Za-z0-9_.-]{1,50}") || adminPassword == null
                || adminPassword.length() < 8 || adminPassword.length() > 256)
            throw new SQLException("Tài khoản ban đầu cần tên hợp lệ và mật khẩu từ 8 đến 256 ký tự.");
        boolean originalAutoCommit = connection.getAutoCommit();
        connection.setAutoCommit(false);
        try {
            try (PreparedStatement statement = connection.prepareStatement(
                    "INSERT INTO tblMember3(id,fullName,username,password,phone) VALUES (1,?,?,?,?)")) {
                statement.setString(1, "Quản lí GaraMan");
                statement.setString(2, adminName);
                statement.setString(3, PasswordHasher.hash(adminPassword));
                statement.setString(4, "02430000000");
                statement.executeUpdate();
            }
            try (Statement statement = connection.createStatement()) {
                statement.executeUpdate("INSERT INTO tblStaff3(tblMember3id,position) VALUES (1,'MANAGER')");
                statement.executeUpdate("INSERT INTO tblManager3(tblMember3id) VALUES (1)");
            }
            executeResource(connection, "/seed.sql");
            connection.commit();
        } catch (SQLException | RuntimeException ex) { connection.rollback(); throw ex; }
        finally { connection.setAutoCommit(originalAutoCommit); }
    }

    private static boolean hasTable(Connection connection, String name) throws SQLException {
        try (ResultSet rows = connection.getMetaData().getTables(connection.getCatalog(), null, "%", new String[]{"TABLE"})) {
            while (rows.next()) if (name.equalsIgnoreCase(rows.getString("TABLE_NAME"))) return true;
        }
        return false;
    }

    private static long count(Connection connection, String table) throws SQLException {
        try (Statement statement = connection.createStatement(); ResultSet rows = statement.executeQuery("SELECT COUNT(*) FROM " + table)) {
            rows.next(); return rows.getLong(1);
        }
    }

    static void executeResource(Connection connection, String name) throws SQLException {
        String text;
        try (InputStream input = Database.class.getResourceAsStream(name)) {
            if (input == null) throw new SQLException("Thiếu tài nguyên khởi tạo CSDL.");
            text = new String(input.readAllBytes(), StandardCharsets.UTF_8);
        } catch (IOException ex) { throw new SQLException("Không đọc được tài nguyên CSDL.", ex); }
        StringBuilder sql = new StringBuilder();
        boolean quoted = false;
        boolean comment = false;
        try (Statement statement = connection.createStatement()) {
            for (int i = 0; i < text.length(); i++) {
                char c = text.charAt(i);
                if (comment) { if (c == '\n') { comment = false; sql.append(' '); } continue; }
                if (!quoted && c == '-' && i + 1 < text.length() && text.charAt(i + 1) == '-') { comment = true; i++; continue; }
                if (c == '\'') quoted = !quoted;
                if (c == ';' && !quoted) { if (!sql.toString().isBlank()) statement.execute(sql.toString()); sql.setLength(0); }
                else sql.append(c);
            }
            if (!sql.toString().isBlank()) statement.execute(sql.toString());
        }
    }

    private static String setting(String property, String environment, String fallback) {
        String value = System.getProperty(property);
        if (value == null) value = System.getenv(environment);
        return value == null ? fallback : value;
    }

    public static synchronized void stop() {
        if (anchor != null) try { anchor.close(); } catch (SQLException ignored) { } finally { anchor = null; }
        Enumeration<Driver> drivers = DriverManager.getDrivers();
        while (drivers.hasMoreElements()) {
            Driver driver = drivers.nextElement();
            if (driver.getClass().getClassLoader() == Database.class.getClassLoader())
                try { DriverManager.deregisterDriver(driver); } catch (SQLException ignored) { }
        }
    }
}
