package project;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class ProjectDAO {

    /* ---------- Veritabanı bilgileri ---------- */
    private static final String JDBC_URL  = "jdbc:mysql://localhost:3306/upload";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASS = "";

    static {
        try { Class.forName("com.mysql.cj.jdbc.Driver"); }
        catch (ClassNotFoundException e) { e.printStackTrace(); }
    }

    /* =====================================================
       INSERT  ( id AUTO_INCREMENT olduğu için SET etmiyoruz )
       ===================================================== */
    public boolean insertProject(Project p) {

        /* Aynı konu + tarih var mı? */
        String check = "SELECT COUNT(*) FROM uploadfile "
                     + "WHERE projectTopic=? AND uploadStartDate=? AND uploadEndDate=?";

        try (Connection c = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement s = c.prepareStatement(check)) {

            s.setString(1, p.getProjectTopic());
            s.setDate  (2, p.getUploadStartDate());
            s.setDate  (3, p.getUploadEndDate());

            try (ResultSet r = s.executeQuery()) {
                if (r.next() && r.getInt(1) > 0) return false; // kayıt var
            }
        } catch (SQLException e) { e.printStackTrace(); return false; }

        /* Ekleme */
        String sql = "INSERT INTO uploadfile "
                   + "(projectTopic, uploadStartDate, uploadEndDate, "
                   +  "courseName, advisorName, uploaderName, "
                   +  "githubLink, libraryLink, "
                   +  "projectDescription, projectImage, projectFile, "
                   +  "projectPublished, publishLink, projectAwards) "
                   + "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)"; // 14 değer!

        try (Connection c = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement s = c.prepareStatement(sql)) {

            s.setString(1,  p.getProjectTopic());
            s.setDate  (2,  p.getUploadStartDate());
            s.setDate  (3,  p.getUploadEndDate());
            s.setString(4,  p.getCourseName());
            s.setString(5,  p.getAdvisorName());
            s.setString(6,  p.getUploaderName());          // yeni sütun
            s.setString(7,  p.getGithubLink());
            s.setString(8,  p.getLibraryLink());
            s.setString(9,  p.getProjectDescription());
            s.setString(10, p.getProjectImage());
            s.setString(11, p.getProjectFile());
            s.setString(12, p.getProjectPublished());
            s.setString(13, p.getPublishLink());
            s.setString(14, p.getProjectAwards());

            return s.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    /* =====================================================
       TÜM PROJELER
       ===================================================== */
    public List<Project> getAllProjects() {
        List<Project> list = new ArrayList<>();

        String sql = "SELECT id, projectTopic, uploadStartDate, uploadEndDate, "
                   + "courseName, advisorName, uploaderName, "
                   + "githubLink, libraryLink, "
                   + "projectDescription, projectImage, projectFile, "
                   + "projectPublished, publishLink, projectAwards "
                   + "FROM uploadfile";

        try (Connection c = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement s = c.prepareStatement(sql);
             ResultSet r = s.executeQuery()) {

            while (r.next()) list.add(mapRowToProject(r));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /* =====================================================
       TEK PROJE (id ile)
       ===================================================== */
    public Project getProjectById(int id) {
        String sql = "SELECT id, projectTopic, uploadStartDate, uploadEndDate, "
                   + "courseName, advisorName, uploaderName, "
                   + "githubLink, libraryLink, "
                   + "projectDescription, projectImage, projectFile, "
                   + "projectPublished, publishLink, projectAwards "
                   + "FROM uploadfile WHERE id = ?";

        try (Connection c = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement s = c.prepareStatement(sql)) {

            s.setInt(1, id);
            try (ResultSet r = s.executeQuery()) {
                if (r.next()) return mapRowToProject(r);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    /* =====================================================
       TEK PROJE (KONUYA göre)
       ===================================================== */
    public Project getProjectByTopic(String topic) {
        String sql = "SELECT id, projectTopic, uploadStartDate, uploadEndDate, "
                   + "courseName, advisorName, uploaderName, "
                   + "githubLink, libraryLink, "
                   + "projectDescription, projectImage, projectFile, "
                   + "projectPublished, publishLink, projectAwards "
                   + "FROM uploadfile WHERE projectTopic = ? LIMIT 1";

        try (Connection c = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement s = c.prepareStatement(sql)) {

            s.setString(1, topic);
            try (ResultSet r = s.executeQuery()) {
                if (r.next()) return mapRowToProject(r);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    /* =====================================================
       PROJECT TOPIC autocomplete listesi
       ===================================================== */
    public List<String> searchProjectTopics(String term) {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT projectTopic FROM uploadfile WHERE projectTopic LIKE ?";

        try (Connection c = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement s = c.prepareStatement(sql)) {

            s.setString(1, "%" + term + "%");
            try (ResultSet r = s.executeQuery()) {
                while (r.next()) list.add(r.getString(1));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /* =====================================================
       PROJE ARAMA (LIKE)
       ===================================================== */
    public List<Project> searchProjects(String term) {
        List<Project> list = new ArrayList<>();
        String sql = "SELECT id, projectTopic, uploadStartDate, uploadEndDate, "
                   + "courseName, advisorName, uploaderName, "
                   + "githubLink, libraryLink, "
                   + "projectDescription, projectImage, projectFile, "
                   + "projectPublished, publishLink, projectAwards "
                   + "FROM uploadfile "
                   + "WHERE projectTopic LIKE ? "
                   + "ORDER BY (projectTopic LIKE ?) DESC, projectTopic";

        try (Connection c = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement s = c.prepareStatement(sql)) {

            String like = "%" + term + "%";
            s.setString(1, like);
            s.setString(2, term + "%");

            try (ResultSet r = s.executeQuery()) {
                while (r.next()) list.add(mapRowToProject(r));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /* =====================================================
       SIMILAR TOPICS (autocomplete, LIMIT 5)
       ===================================================== */
    public List<String> getSimilarProjectTopics(String term) {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT projectTopic FROM uploadfile "
                   + "WHERE projectTopic LIKE ? LIMIT 5";

        try (Connection c = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement s = c.prepareStatement(sql)) {

            s.setString(1, "%" + term + "%");
            try (ResultSet r = s.executeQuery()) {
                while (r.next()) list.add(r.getString(1));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /* =====================================================
       TOPLAM PROJE SAYISI
       ===================================================== */
    public int getTotalProjectCount() {
        String sql = "SELECT COUNT(*) AS total FROM uploadfile";
        try (Connection c = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement s = c.prepareStatement(sql);
             ResultSet r = s.executeQuery()) {

            if (r.next()) return r.getInt("total");
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    /* =====================================================
       PUBLISH DURUMU DAĞILIMI
       ===================================================== */
    public Map<String, Integer> getProjectCountByStatus() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT projectPublished, COUNT(*) AS cnt "
                   + "FROM uploadfile GROUP BY projectPublished";

        try (Connection c = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement s = c.prepareStatement(sql);
             ResultSet r = s.executeQuery()) {

            while (r.next())
                map.put(r.getString("projectPublished"), r.getInt("cnt"));
        } catch (SQLException e) { e.printStackTrace(); }
        return map;
    }

    /* =====================================================
       DANIŞMANA GÖRE PROJE SAYISI
       ===================================================== */
    public Map<String, Integer> getProjectCountByAdvisor() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT advisorName, COUNT(*) AS cnt "
                   + "FROM uploadfile GROUP BY advisorName ORDER BY cnt DESC";

        try (Connection c = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement s = c.prepareStatement(sql);
             ResultSet r = s.executeQuery()) {

            while (r.next())
                map.put(r.getString("advisorName"), r.getInt("cnt"));
        } catch (SQLException e) { e.printStackTrace(); }
        return map;
    }

    /* =====================================================
       SON EKLENEN PROJELER
       ===================================================== */
    public List<Project> getRecentProjects(int limit) {
        List<Project> list = new ArrayList<>();
        String sql = "SELECT id, projectTopic, uploadStartDate, uploadEndDate, "
                   + "courseName, advisorName, uploaderName, "
                   + "githubLink, libraryLink, "
                   + "projectDescription, projectImage, projectFile, "
                   + "projectPublished, publishLink, projectAwards "
                   + "FROM uploadfile ORDER BY uploadStartDate DESC LIMIT ?";

        try (Connection c = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement s = c.prepareStatement(sql)) {

            s.setInt(1, limit);
            try (ResultSet r = s.executeQuery()) {
                while (r.next()) list.add(mapRowToProject(r));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /* =====================================================
       DANIŞMAN ARAMASI
       ===================================================== */
    public List<Project> searchProjectsByAdvisor(String advisor) {
        List<Project> list = new ArrayList<>();
        String sql = "SELECT id, projectTopic, uploadStartDate, uploadEndDate, "
                   + "courseName, advisorName, uploaderName, "
                   + "githubLink, libraryLink, "
                   + "projectDescription, projectImage, projectFile, "
                   + "projectPublished, publishLink, projectAwards "
                   + "FROM uploadfile WHERE advisorName LIKE ? ORDER BY advisorName";

        try (Connection c = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement s = c.prepareStatement(sql)) {

            s.setString(1, "%" + advisor + "%");
            try (ResultSet r = s.executeQuery()) {
                while (r.next()) list.add(mapRowToProject(r));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /* =====================================================
       BELİRLİ KULLANICIYA AİT PROJELER
       ===================================================== */
    public List<Project> getProjectsByUserName(String userName) {
        List<Project> list = new ArrayList<>();
        String sql = "SELECT * FROM uploadfile WHERE uploaderName = ? "
                   + "ORDER BY uploadStartDate DESC";
        try (Connection c = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement s = c.prepareStatement(sql)) {

            s.setString(1, userName);
            try (ResultSet r = s.executeQuery()) {
                while (r.next()) list.add(mapRowToProject(r));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /* =====================================================
       Row → Project
       ===================================================== */
    private Project mapRowToProject(ResultSet r) throws SQLException {

        int    id        = r.getInt   ("id");
        String topic     = r.getString("projectTopic");
        Date   start     = r.getDate  ("uploadStartDate");
        Date   end       = r.getDate  ("uploadEndDate");
        String course    = r.getString("courseName");
        String advisor   = r.getString("advisorName");
        String uploader  = r.getString("uploaderName");
        String github    = r.getString("githubLink");
        String library   = r.getString("libraryLink");
        String desc      = r.getString("projectDescription");
        String img       = r.getString("projectImage");
        String file      = r.getString("projectFile");
        String published = r.getString("projectPublished");
        String pubLink   = r.getString("publishLink");
        String awards    = r.getString("projectAwards");

        return new Project(id, topic, start, end,
                           course, advisor, uploader,
                           github, library,
                           desc, img, file,
                           published, pubLink, awards);
    }
}
