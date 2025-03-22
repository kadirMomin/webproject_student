package project;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProjectDAO {

    // Veritabanı bağlantı bilgileri
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/upload";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASS = "";

    // JDBC sürücüsünü yükleme (sınıf yüklendiğinde çalışır)
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver bulunamadı.");
            e.printStackTrace();
        }
    }

    public boolean insertProject(Project project) {
        // Aynı proje konusu için hem başlangıç hem bitiş tarihleri aynı ise duplicate olarak kabul edelim.
        String checkSql = "SELECT COUNT(*) FROM uploadfile WHERE projectTopic = ? AND uploadStartDate = ? AND uploadEndDate = ?";
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS); PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {

            checkStmt.setString(1, project.getProjectTopic());
            checkStmt.setDate(2, project.getUploadStartDate());
            checkStmt.setDate(3, project.getUploadEndDate());
            try (ResultSet rs = checkStmt.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    // Aynı proje konusu ile aynı tarih kombinasyonu zaten mevcutsa ekleme yapma.
                    System.out.println("Aynı proje konusu ile aynı başlangıç ve bitiş tarihleri zaten mevcut!");
                    return false;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        // Kayıt kontrolü geçerse ekleme işlemini gerçekleştir.
        String sql = "INSERT INTO uploadfile (projectTopic, uploadStartDate, uploadEndDate, courseName, advisorName, githubLink, projectDescription, projectImage) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, project.getProjectTopic());
            stmt.setDate(2, project.getUploadStartDate());
            stmt.setDate(3, project.getUploadEndDate());
            stmt.setString(4, project.getCourseName());
            stmt.setString(5, project.getAdvisorName());
            stmt.setString(6, project.getGithubLink());
            stmt.setString(7, project.getProjectDescription());
            stmt.setString(8, project.getProjectImage());

            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Veritabanındaki tüm projeleri listeleyen metod
    public List<Project> getAllProjects() {
        List<Project> projects = new ArrayList<>();
        String sql = "SELECT projectTopic, uploadStartDate, uploadEndDate, courseName, advisorName, githubLink, projectDescription, projectImage FROM uploadfile";

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                System.out.println("Kayıt bulundu: " + rs.getString("projectTopic"));
                String projectTopic = rs.getString("projectTopic");
                java.sql.Date uploadStartDate = rs.getDate("uploadStartDate");
                java.sql.Date uploadEndDate = rs.getDate("uploadEndDate");
                String courseName = rs.getString("courseName");
                String advisorName = rs.getString("advisorName");
                String githubLink = rs.getString("githubLink");
                String projectDescription = rs.getString("projectDescription");
                String projectImage = rs.getString("projectImage");

                Project project = new Project(projectTopic, uploadStartDate, uploadEndDate,
                        courseName, advisorName, githubLink, projectDescription, projectImage);
                projects.add(project);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return projects;
    }

}
