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

    /* ========== 1) Ders listesi (öğrenciye özel) ========= */
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

    /* ========== 2) Ders seç / sil / sorun bildir ========= */
    public boolean selectCourse(String user, int courseId) {
        String sql = "INSERT IGNORE INTO user_course (userName, courseId) VALUES (?,?)";
        try (Connection c = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement s = c.prepareStatement(sql)) {
            s.setString(1, user);
            s.setInt(2, courseId);
            return s.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean deleteCourse(String user, int courseId) {
        String sql = "DELETE FROM user_course WHERE userName=? AND courseId=?";
        try (Connection c = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement s = c.prepareStatement(sql)) {
            s.setString(1, user);
            s.setInt(2, courseId);
            return s.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean reportIssue(String user, int courseId, String msg) {
        String sql = "INSERT INTO course_issue (userName, courseId, message) VALUES (?,?,?)";
        try (Connection c = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement s = c.prepareStatement(sql)) {
            s.setString(1, user);
            s.setInt(2, courseId);
            s.setString(3, msg);
            return s.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    /* =====================================================
       3)  ---  TÜM DERS SEÇİMLERİ  (Admin ekranı)  ---
       ===================================================== */

    /**  Tek bir satırı temsil eden immutable sınıf  */
    public static class CourseSelection {
        public final String userName;
        public final String courseName;
        public final String instructor;

        public CourseSelection(String userName, String courseName, String instructor) {
            this.userName   = userName;
            this.courseName = courseName;
            this.instructor = instructor;
        }
        public String getUserName()   { return userName; }
        public String getCourseName() { return courseName; }
        public String getInstructor() { return instructor; }
    }

    /**  Kullanıcı-ders eşleştirmelerini getirir  */
    public List<CourseSelection> getAllSelections() {
        List<CourseSelection> list = new ArrayList<>();

        String sql =
          "SELECT uc.userName, c.name AS courseName, c.instructor " +
          "FROM user_course uc " +
          "JOIN course c ON c.id = uc.courseId " +
          "ORDER BY uc.userName, c.name";

        try (Connection c = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement s = c.prepareStatement(sql);
             ResultSet r = s.executeQuery()) {

            while (r.next()) {
                list.add(new CourseSelection(
                        r.getString("userName"),
                        r.getString("courseName"),
                        r.getString("instructor")));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
    
    /* =========== BEKLEYEN DERS SEÇİMLERİ =========== */
public static class PendingSel{
    private final int recId;          // user_course.id
    private final String userName, courseName, instructor;
    public PendingSel(int id,String u,String c,String i){
        recId=id; userName=u; courseName=c; instructor=i;
    }
    public int getRecId(){return recId;}
    public String getUserName(){return userName;}
    public String getCourseName(){return courseName;}
    public String getInstructor(){return instructor;}
}

public List<PendingSel> getPendingSelections(){
    List<PendingSel> list=new ArrayList<>();
    String sql="SELECT uc.id,uc.userName,c.name,c.instructor "+
               "FROM user_course uc JOIN course c ON c.id=uc.courseId "+
               "WHERE uc.approved=0";
    try(Connection c=DriverManager.getConnection(JDBC_URL,JDBC_USER,JDBC_PASS);
        PreparedStatement s=c.prepareStatement(sql);
        ResultSet r=s.executeQuery()){
        while(r.next())
          list.add(new PendingSel(r.getInt(1),r.getString(2),r.getString(3),r.getString(4)));
    }catch(SQLException e){e.printStackTrace();}
    return list;
}

/* onayla / reddet */
public void approveSelection(int recId,boolean approve){
    String sql = approve ?
        "UPDATE user_course SET approved=1 WHERE id=?"
      : "DELETE FROM user_course WHERE id=?";
    try(Connection c=DriverManager.getConnection(JDBC_URL,JDBC_USER,JDBC_PASS);
        PreparedStatement s=c.prepareStatement(sql)){
        s.setInt(1,recId); s.executeUpdate();
    }catch(SQLException e){e.printStackTrace();}
}

}
