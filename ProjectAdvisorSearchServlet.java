package project;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.google.gson.Gson;

@WebServlet("/ProjectAdvisorSearchServlet")
public class ProjectAdvisorSearchServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String term = request.getParameter("term");
        ProjectDAO dao = new ProjectDAO();
        List<Project> projects = dao.searchProjectsByAdvisor(term);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        Gson gson = new Gson();
        String json = gson.toJson(projects);
        response.getWriter().write(json);
    }
}