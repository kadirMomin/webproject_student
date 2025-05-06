package course;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/CourseSelectServlet")
public class CourseSelectServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String user = (String) req.getSession().getAttribute("user");
        int courseId = Integer.parseInt(req.getParameter("id"));
        new CourseDAO().selectCourse(user, courseId); // approved=0
        resp.sendRedirect("courses.jsp?info=waiting"); // “onay bekliyor” mesajı isterseniz
    }
}
