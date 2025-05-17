package project;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/ProjectApproveServlet")
public class ProjectApproveServlet extends HttpServlet {

    // Veritabanı bağlantı bilgileri
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/upload";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASS = "";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        // 1. Proje ID'sini al
        int projectId;
        try {
            projectId = Integer.parseInt(req.getParameter("id"));
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Geçersiz proje ID");
            return;
        }

        // 2. Veritabanı bağlantısı ve güncelleme
        String sql = "UPDATE uploadfile SET projectPublished='yes' WHERE id=?";
        
        try (Connection c = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement s = c.prepareStatement(sql)) {
            
            s.setInt(1, projectId);
            int affectedRows = s.executeUpdate();
            
            if (affectedRows == 0) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Proje bulunamadı");
                return;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Veritabanı hatası");
            return;
        }

        // 3. Onay bekleyen projeler listesine geri dön
        resp.sendRedirect("admin.jsp?view=pending");
    }
}