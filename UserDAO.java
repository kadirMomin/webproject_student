package project;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {
    // Veritabanı bağlantı bilgileri
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/login";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASS = "";
    
    // Sürücüyü yükleme (sınıf yüklendiğinde çalışır)
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver bulunamadı.");
            e.printStackTrace();
        }
    }
    
    // Kullanıcı kayıt (sign up) metodu
    public boolean signUp(User user) {
        String sql = "INSERT INTO loginandregister (UserName, email, password) VALUES (?, ?, ?)";
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, user.getUserName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            
            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;
        } catch (SQLException e) {
            System.err.println("Kayıt oluşturulurken hata oluştu:");
            e.printStackTrace();
            return false;
        }
    }
    
    // Kullanıcı giriş (sign in) metodu - EMAIL ile kontrol
    public boolean signIn(String email, String password) {
        String sql = "SELECT * FROM loginandregister WHERE email = ? AND password = ?";
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            stmt.setString(2, password);
            
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            System.err.println("Giriş yapılırken hata oluştu:");
            e.printStackTrace();
            return false;
        }
    }
    
    // --- Yeni Eklenti ---
    // Email'e göre UserName bilgisini getirir.
    public String getUserNameByEmail(String email) {
        String sql = "SELECT UserName FROM loginandregister WHERE email = ?";
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("UserName");
                }
            }
        } catch (SQLException e) {
            System.err.println("UserName getirirken hata oluştu:");
            e.printStackTrace();
        }
        return null;
    }
    
    /** Kullanıcı adıyla e-postayı getirir */
    public String getEmailByUserName(String userName) {
        String sql = "SELECT email FROM loginandregister WHERE UserName = ?";
        try (Connection c = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement s = c.prepareStatement(sql)) {
            s.setString(1, userName);
            try (ResultSet r = s.executeQuery()) {
                if (r.next()) return r.getString("email");
            }
        } catch(SQLException e) { e.printStackTrace(); }
        return null;
    }

    /**  
     * Eski şifre kontrolü yapıp, eşleşiyorsa yeni şifreyi günceller  
     * @return true = başarıyla güncellendi, false = hata veya eski şifre uyuşmadı  
     */
    public boolean updatePassword(String userName, String oldPwd, String newPwd) {
        String checkSql = "SELECT 1 FROM loginandregister WHERE UserName = ? AND password = ?";
        String updateSql = "UPDATE loginandregister SET password = ? WHERE UserName = ?";
        try (Connection c = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement checkStmt = c.prepareStatement(checkSql)) {
            checkStmt.setString(1, userName);
            checkStmt.setString(2, oldPwd);
            try (ResultSet r = checkStmt.executeQuery()) {
                if (!r.next()) {
                    // Eski şifre yanlış
                    return false;
                }
            }
            try (PreparedStatement updStmt = c.prepareStatement(updateSql)) {
                updStmt.setString(1, newPwd);
                updStmt.setString(2, userName);
                return updStmt.executeUpdate() > 0;
            }
        } catch(SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
