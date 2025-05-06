package project;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/ProjectApproveServlet")
public class ProjectApproveServlet extends HttpServlet {

    private static final String JDBC_URL  = "jdbc:mysql://localhost:3306/upload";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASS = "";

    static { try{Class.forName("com.mysql.cj.jdbc.Driver");}catch(Exception ignored){} }

    @Override protected void doGet(HttpServletRequest req,HttpServletResponse resp)
            throws ServletException,IOException {

        int id = Integer.parseInt(req.getParameter("id"));
        String sql = "UPDATE uploadfile SET projectPublished='yes' WHERE id=?";

        try(Connection c=DriverManager.getConnection(JDBC_URL,JDBC_USER,JDBC_PASS);
            PreparedStatement s=c.prepareStatement(sql)){
            s.setInt(1,id);
            s.executeUpdate();
        }catch(SQLException e){e.printStackTrace();}

        resp.sendRedirect("admin.jsp?view=pending");   // kaldığı liste
    }
}
