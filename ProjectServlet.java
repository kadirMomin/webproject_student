package project;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/ProjectServlet")
@MultipartConfig
public class ProjectServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Metin alanlarını oku:
        String projectTopic = readFormField(request.getPart("projectTopic"));
        String courseName = readFormField(request.getPart("courseName"));
        String advisorName = readFormField(request.getPart("advisorName"));
        String githubLink = readFormField(request.getPart("githubLink"));
        String libraryLink = readFormField(request.getPart("libraryLink")); // Yeni: Kütüphane Linki
        String projectDescription = readFormField(request.getPart("projectDescription"));
        
        // Yeni eklenen alanlar:
        String projectPublished = readFormField(request.getPart("projectPublished"));
        String projectAwards = readFormField(request.getPart("projectAwards"));

        // Tarih alanları
        String startDateStr = readFormField(request.getPart("uploadStartDate"));
        String endDateStr = readFormField(request.getPart("uploadEndDate"));

        if (projectTopic == null || projectTopic.trim().isEmpty()) {
            throw new ServletException("Proje konusu boş bırakılamaz!");
        }
        if (startDateStr == null || startDateStr.trim().isEmpty()) {
            throw new ServletException("Yükleme Başlangıç Tarihi boş bırakılamaz!");
        }
        if (endDateStr == null || endDateStr.trim().isEmpty()) {
            throw new ServletException("Yükleme Bitiş Tarihi boş bırakılamaz!");
        }

        java.sql.Date uploadStartDate;
        java.sql.Date uploadEndDate;
        try {
            uploadStartDate = java.sql.Date.valueOf(startDateStr);
            uploadEndDate = java.sql.Date.valueOf(endDateStr);
        } catch (IllegalArgumentException e) {
            throw new ServletException("Tarih formatı hatalı: " + e.getMessage());
        }

        // Proje resmini işleme
        Part imagePart = request.getPart("projectImage");
        String fileName = extractFileName(imagePart);
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadPath = applicationPath + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        imagePart.write(uploadPath + File.separator + fileName);
        String projectImage = fileName;

        // Project nesnesini, yeni alanlar dahil olacak şekilde oluşturun.
        Project project = new Project(projectTopic, uploadStartDate, uploadEndDate,
                courseName, advisorName, githubLink, libraryLink, projectDescription, projectImage,
                projectPublished, projectAwards);

        // Veritabanına ekleme
        ProjectDAO dao = new ProjectDAO();
        boolean inserted = dao.insertProject(project);
        if (!inserted) {
            request.setAttribute("errorMessage", "Aynı proje konusu, başlangıç ve bitiş tarihleri ile kayıt mevcut. Lütfen farklı tarih veya proje konusu giriniz.");
            request.getRequestDispatcher("upload.jsp").forward(request, response);
            return;
        }

        // Proje listesini güncelle
        List<Project> projectList = dao.getAllProjects();
        request.setAttribute("projectList", projectList);
        request.getRequestDispatcher("project.jsp").forward(request, response);
    }

    private String readFormField(Part part) throws IOException {
        if (part == null) {
            return null;
        }
        BufferedReader reader = new BufferedReader(new InputStreamReader(part.getInputStream(), "UTF-8"));
        StringBuilder value = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            value.append(line);
        }
        return value.toString();
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf('=') + 2, s.length() - 1);
            }
        }
        return "";
    }
}
