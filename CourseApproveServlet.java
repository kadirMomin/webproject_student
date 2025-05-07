package course;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/CourseApproveServlet")
public class CourseApproveServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String act   = req.getParameter("act");      // "ok" → onay,  "del" → sil
        int    recId = Integer.parseInt(req.getParameter("id"));

        CourseDAO dao = new CourseDAO();
        dao.approveSelection(recId, "ok".equalsIgnoreCase(act));

        resp.sendRedirect("admin.jsp?view=pendingcourse");
    }
}
