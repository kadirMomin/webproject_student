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

    // Dosyaların kaydedileceği klasör (uygulamanın context dizininde "uploads" klasörü oluşturulacak)
    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Karakter kodlamasını ayarla
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // --- Proje ekleme işlemi ---
        // Multipart formdaki text alanlarını getPart() ile okuyalım.
        String projectTopic = readFormField(request.getPart("projectTopic"));
        String courseName = readFormField(request.getPart("courseName"));
        String advisorName = readFormField(request.getPart("advisorName"));
        String githubLink = readFormField(request.getPart("githubLink"));
        String projectDescription = readFormField(request.getPart("projectDescription"));

        // Tarih alanları: form <input type="date"> kullanıyor; veriler "yyyy-MM-dd" formatında gönderilir.
        String startDateStr = readFormField(request.getPart("uploadStartDate"));
        String endDateStr = readFormField(request.getPart("uploadEndDate"));

        // Null kontrolü
        if (projectTopic == null || projectTopic.trim().isEmpty()) {
            throw new ServletException("Proje konusu boş bırakılamaz!");
        }
        if (startDateStr == null || startDateStr.trim().isEmpty()) {
            throw new ServletException("Yükleme Başlangıç Tarihi boş bırakılamaz!");
        }
        if (endDateStr == null || endDateStr.trim().isEmpty()) {
            throw new ServletException("Yükleme Bitiş Tarihi boş bırakılamaz!");
        }

        // Tarih dönüşümü: java.sql.Date.valueOf() kullanarak
        java.sql.Date uploadStartDate;
        java.sql.Date uploadEndDate;
        try {
            uploadStartDate = java.sql.Date.valueOf(startDateStr);
            uploadEndDate = java.sql.Date.valueOf(endDateStr);
        } catch (IllegalArgumentException e) {
            throw new ServletException("Tarih formatı hatalı: " + e.getMessage());
        }

        // Proje resmini (image) işleyelim:
        Part imagePart = request.getPart("projectImage");
        String fileName = extractFileName(imagePart);
        // Uygulama dizininden uploads klasörünün yolunu alalım
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadPath = applicationPath + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        // Dosyayı uploads klasörüne kaydedelim
        imagePart.write(uploadPath + File.separator + fileName);
        String projectImage = fileName;

        // Project nesnesini oluşturun (tüm alanları içerecek şekilde)
        Project project = new Project(projectTopic, uploadStartDate, uploadEndDate,
                courseName, advisorName, githubLink, projectDescription, projectImage);

        // DAO aracılığıyla veritabanına ekleme yapın
        ProjectDAO dao = new ProjectDAO();
        boolean inserted = dao.insertProject(project);
        if (!inserted) {
            // Duplicate durumunda hata mesajını set edip kullanıcıyı upload.jsp'ye yönlendiriyoruz.
            request.setAttribute("errorMessage", "Aynı proje konusu, başlangıç ve bitiş tarihleri ile kayıt mevcut. Lütfen farklı tarih veya proje konusu giriniz.");
            request.getRequestDispatcher("upload.jsp").forward(request, response);
            return;
        }

        // --- Proje Listeleme İşlemi ---
        // Kayıt eklenmiş olsun veya olmasın, güncel listeyi çekelim
        List<Project> projectList = dao.getAllProjects();
        request.setAttribute("projectList", projectList);
        // Listeleme sayfası olarak project.jsp'ye yönlendiriyoruz.
        request.getRequestDispatcher("project.jsp").forward(request, response);
    }

    // Yardımcı metot: Bir Part'tan metin değeri okur.
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

    // Yardımcı metot: Part içinden dosya adını çıkarır.
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
