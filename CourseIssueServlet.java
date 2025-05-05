package course;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/CourseIssueServlet")
public class CourseIssueServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String user     = (String) req.getSession().getAttribute("user");
        int    courseId = Integer.parseInt(req.getParameter("id"));
        String message  = req.getParameter("msg");     // <input name=\"msg\">

        new CourseDAO().reportIssue(user, courseId, message);

        resp.sendRedirect("courses.jsp");
    }

    /* Butona GET ile gittiyseniz basitçe POST’a yönlendirelim */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doPost(req, resp);
    }
}
