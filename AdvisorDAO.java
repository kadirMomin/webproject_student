package advisor;

import java.sql.*;
import java.util.*;

public class AdvisorDAO {

    private static final String JDBC_URL  = "jdbc:mysql://localhost:3306/upload";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASS = "";

    static {
        try { Class.forName("com.mysql.cj.jdbc.Driver"); }
        catch (ClassNotFoundException e) { e.printStackTrace(); }
    }

    /* ========== 1) Liste ========= */
    public List<Advisor> getAllAdvisors() {
        List<Advisor> list = new ArrayList<>();
        String sql = "SELECT id, name FROM advisor ORDER BY id";

        try (Connection c = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement s = c.prepareStatement(sql);
             ResultSet r = s.executeQuery()) {

            while (r.next())
                list.add(new Advisor(r.getInt("id"), r.getString("name")));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /* ========== 2) Öğrenciye danışman ata ========= */
    public boolean selectAdvisor(String userName, int advisorId) {
        String sql = "INSERT IGNORE INTO user_advisor (userName, advisorId) VALUES (?,?)";
        try (Connection c = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement s = c.prepareStatement(sql)) {

            s.setString(1, userName);
            s.setInt   (2, advisorId);
            return s.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}
