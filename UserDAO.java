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
    
    // Kullanıcı giriş (sign in) metodu
    public boolean signIn(String userName, String password) {
        String sql = "SELECT * FROM loginandregister WHERE UserName = ? AND password = ?";
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, userName);
            stmt.setString(2, password);
            
            ResultSet rs = stmt.executeQuery();
            return rs.next(); // Eğer sonuç varsa, kullanıcı bilgileri doğru demektir.
        } catch (SQLException e) {
            System.err.println("Giriş yapılırken hata oluştu:");
            e.printStackTrace();
            return false;
        }
    }
}
