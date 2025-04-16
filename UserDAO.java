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
}
