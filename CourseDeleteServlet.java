package course;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/CourseDeleteServlet")
public class CourseDeleteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String user = (String) req.getSession().getAttribute("user");
        int courseId = Integer.parseInt(req.getParameter("id"));

        new CourseDAO().deleteCourse(user, courseId);

        resp.sendRedirect("courses.jsp");
    }
}
