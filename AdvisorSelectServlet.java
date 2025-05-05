package advisor;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/AdvisorSelectServlet")
public class AdvisorSelectServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String user = (String) req.getSession().getAttribute("user");
        int advisorId = Integer.parseInt(req.getParameter("id"));

        new AdvisorDAO().selectAdvisor(user, advisorId);

        resp.sendRedirect("courses.jsp");
    }
}
