package advisor;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/AdvisorDeleteServlet")
public class AdvisorDeleteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req,HttpServletResponse resp)
            throws ServletException,IOException {

        /* —— 1) Parametreler —— */
        String user      = (String) req.getSession().getAttribute("user"); // öğrenci kurs sayfasından geliyorsa
        String idParam   = req.getParameter("id");
        int advisorId    = (idParam!=null && !idParam.isBlank()) ? Integer.parseInt(idParam) : -1;

        /* —— 2) Veritabanından sil —— */
        if(advisorId>0){
            try (java.sql.Connection  c = java.sql.DriverManager.getConnection(
                         "jdbc:mysql://localhost:3306/upload","root","");          // ► kendi ayarlarınız
                 java.sql.PreparedStatement s = c.prepareStatement(
                         "DELETE FROM user_advisor WHERE userName=? AND advisorId=?")){
                s.setString(1,user);
                s.setInt   (2,advisorId);
                s.executeUpdate();
            } catch (Exception e){ e.printStackTrace(); }
        }

        /* —— 3) Aynı sayfaya geri dön —— */
        String back = req.getHeader("referer");          // geldiği URL
        if(back==null || back.isBlank()) back = "courses.jsp";
        resp.sendRedirect(back);
    }
}
