package project;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/ProjectRejectServlet")
public class ProjectRejectServlet extends HttpServlet {

    private static final String JDBC_URL  = "jdbc:mysql://localhost:3306/upload";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASS = "";

    static { try{Class.forName("com.mysql.cj.jdbc.Driver");}catch(Exception ignored){} }

    @Override protected void doGet(HttpServletRequest req,HttpServletResponse resp)
            throws ServletException,IOException {

        int    id   = Integer.parseInt(req.getParameter("id"));
        String from = req.getParameter("from");          // pending | approved

        /* pending'den geliyorsa tamamen sil, approved'dan geliyorsa onayı kaldır */
        String sql = ("pending".equals(from))
                     ? "DELETE FROM uploadfile WHERE id=?"
                     : "UPDATE uploadfile SET projectPublished='no' WHERE id=?";

        try(Connection c=DriverManager.getConnection(JDBC_URL,JDBC_USER,JDBC_PASS);
            PreparedStatement s=c.prepareStatement(sql)){
            s.setInt(1,id);
            s.executeUpdate();
        }catch(SQLException e){e.printStackTrace();}

        resp.sendRedirect("admin.jsp?view="+from);
    }
}
