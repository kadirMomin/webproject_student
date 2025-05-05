package course;

import java.sql.*;
import java.util.*;

public class CourseDAO {

    /* ---------- Veritabanı ayarları ---------- */
    private static final String JDBC_URL  = "jdbc:mysql://localhost:3306/upload";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASS = "";

    static {
        try { Class.forName("com.mysql.cj.jdbc.Driver"); }
        catch (ClassNotFoundException e) { e.printStackTrace(); }
    }

    /* ========== 1) Listeleme ========= */
    public List<Course> getAllCourses(String userName) {
        List<Course> list = new ArrayList<>();

        String sql =
          "SELECT c.id, c.name, c.instructor, " +
          "       (SELECT COUNT(*) FROM user_course uc WHERE uc.courseId = c.id)          AS totalSel, " +
          "       EXISTS(SELECT 1 FROM user_course uc WHERE uc.courseId = c.id AND uc.userName = ?) AS sel " +
          "FROM course c ORDER BY c.id";

        try (Connection c = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement s = c.prepareStatement(sql)) {

            s.setString(1, userName);
            try (ResultSet r = s.executeQuery()) {
                while (r.next()) {
                    list.add(new Course(
                            r.getInt("id"),
                            r.getString("name"),
                            r.getString("instructor"),
                            r.getInt("totalSel"),
                            r.getBoolean("sel")));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /* ========== 2) Seç ========= */
    public boolean selectCourse(String userName, int courseId) {
        String sql = "INSERT IGNORE INTO user_course (userName, courseId) VALUES (?,?)";
        try (Connection c = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement s = c.prepareStatement(sql)) {

            s.setString(1, userName);
            s.setInt   (2, courseId);
            return s.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    /* ========== 3) Sil ========= */
    public boolean deleteCourse(String userName, int courseId) {
        String sql = "DELETE FROM user_course WHERE userName=? AND courseId=?";
        try (Connection c = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement s = c.prepareStatement(sql)) {

            s.setString(1, userName);
            s.setInt   (2, courseId);
            return s.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    /* ========== 4) Sorun bildir =========
       (issue tablosu henüz yoksa yorum satırı olarak bırakabilirsiniz) */
    public boolean reportIssue(String userName, int courseId, String msg) {
        String sql = "INSERT INTO course_issue (userName, courseId, message) VALUES (?,?,?)";
        try (Connection c = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement s = c.prepareStatement(sql)) {

            s.setString(1, userName);
            s.setInt   (2, courseId);
            s.setString(3, msg);
            return s.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}
