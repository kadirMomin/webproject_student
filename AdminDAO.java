package admin;

import java.sql.*;
import java.util.Optional;

public class AdminDAO {

    /* --- DB ayarları --- */
    private static final String JDBC_URL  = "jdbc:mysql://localhost:3306/login";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASS = "";

    static {
        try { Class.forName("com.mysql.cj.jdbc.Driver"); }
        catch (ClassNotFoundException e) { e.printStackTrace(); }
    }

    /* ========== 1) Kayıt ========== */
    public boolean register(Admin a) {
        String sql = "INSERT INTO admin (fullName,email,password) VALUES (?,?,?)";
        try (Connection c = DriverManager.getConnection(JDBC_URL,JDBC_USER,JDBC_PASS);
             PreparedStatement s = c.prepareStatement(sql)) {

            s.setString(1, a.getFullName());
            s.setString(2, a.getEmail());
            s.setString(3, a.getPassword());
            return s.executeUpdate() > 0;

        } catch (SQLIntegrityConstraintViolationException dup) {
            // email UNIQUE; kayıt zaten varsa false döndür
            return false;
        } catch (SQLException e) {
            e.printStackTrace(); return false;
        }
    }

    /* ========== 2) Giriş ========== */
    public boolean login(String email, String password) {
        String sql = "SELECT 1 FROM admin WHERE email=? AND password=? LIMIT 1";
        try (Connection c = DriverManager.getConnection(JDBC_URL,JDBC_USER,JDBC_PASS);
             PreparedStatement s = c.prepareStatement(sql)) {

            s.setString(1, email);
            s.setString(2, password);
            try (ResultSet r = s.executeQuery()) { return r.next(); }

        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    /* ========== 3) Email ile Admin getir ========== */
    public Optional<Admin> findByEmail(String email){
        String sql = "SELECT * FROM admin WHERE email=? LIMIT 1";
        try (Connection c = DriverManager.getConnection(JDBC_URL,JDBC_USER,JDBC_PASS);
             PreparedStatement s = c.prepareStatement(sql)) {

            s.setString(1, email);
            try (ResultSet r = s.executeQuery()) {
                if (r.next())
                    return Optional.of(new Admin(
                        r.getInt("id"),
                        r.getString("fullName"),
                        r.getString("email"),
                        r.getString("password")));
            }
        } catch (SQLException e){ e.printStackTrace(); }
        return Optional.empty();
    }
}
