package project;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ProjectDetailServlet")
public class ProjectDetailServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Proje konusunu GET parametresi olarak alıyoruz.
        String projectTopic = request.getParameter("projectTopic");
        if (projectTopic == null || projectTopic.trim().isEmpty()) {
            response.sendRedirect("project.jsp");
            return;
        }
        
        // DAO'dan proje detaylarını getiriyoruz.
        ProjectDAO dao = new ProjectDAO();
        Project project = dao.getProjectByTopic(projectTopic);
        
        if (project == null) {
            request.setAttribute("errorMessage", "Proje bulunamadı!");
            request.getRequestDispatcher("project.jsp").forward(request, response);
            return;
        }
        
        // Proje nesnesini request attribute olarak ekleyip detay JSP sayfasına yönlendiriyoruz.
        request.setAttribute("project", project);
        request.getRequestDispatcher("detayProject.jsp").forward(request, response);
    }
}
