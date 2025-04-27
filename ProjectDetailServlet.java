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

        ProjectDAO dao = new ProjectDAO();
        Project project = null;

        /* 1)  Öncelik : id parametresi (tekil) */
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int pid = Integer.parseInt(idParam);
                project = dao.getProjectById(pid);
            } catch (NumberFormatException ignore) {
                /* Geçersiz id => topic’e düş */
            }
        }

        /* 2)  Eski davranış için geri-dönük uyumluluk : projectTopic */
        if (project == null) {
            String projectTopic = request.getParameter("projectTopic");
            if (projectTopic != null && !projectTopic.trim().isEmpty()) {
                project = dao.getProjectByTopic(projectTopic);
            }
        }

        /* 3)  Kayıt bulunamadıysa listeye geri dön */
        if (project == null) {
            request.setAttribute("errorMessage", "Proje bulunamadı!");
            request.getRequestDispatcher("project.jsp").forward(request, response);
            return;
        }

        /* 4)  Bulunduysa detay sayfasına ilet */
        request.setAttribute("project", project);
        request.getRequestDispatcher("detayProject.jsp")  // JSP dosyanızın adı buysa
               .forward(request, response);
    }
}
