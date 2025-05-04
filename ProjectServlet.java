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
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/ProjectServlet")
@MultipartConfig
public class ProjectServlet extends HttpServlet {

    private static final String UPLOAD_DIR_IMG = "uploads";        // resimler
    private static final String UPLOAD_DIR_ZIP = "uploads/zips";   // ZIP dosyaları

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");

        /* -------------------------------------------------
           1) Oturumdan kullanıcı adını al (uploaderName)
           ------------------------------------------------- */
        HttpSession session = req.getSession(false);
        String userName = (session != null)
                ? (String) session.getAttribute("userName")
                : null;            // null kalması olağan dışı bir durumdur

        /* -------------------------------------------------
           2) Form alanlarını oku
           ------------------------------------------------- */
        String projectTopic       = readFormField(req.getPart("projectTopic"));
        String courseName         = readFormField(req.getPart("courseName"));
        String advisorName        = readFormField(req.getPart("advisorName"));
        String githubLink         = readFormField(req.getPart("githubLink"));
        String libraryLink        = readFormField(req.getPart("libraryLink"));
        String projectDescription = readFormField(req.getPart("projectDescription"));

        String projectPublished   = readFormField(req.getPart("projectPublished"));
        String publishLink        = readFormField(req.getPart("publishLink"));
        String projectAwards      = readFormField(req.getPart("projectAwards"));

        String startDateStr       = readFormField(req.getPart("uploadStartDate"));
        String endDateStr         = readFormField(req.getPart("uploadEndDate"));

        java.sql.Date uploadStartDate = java.sql.Date.valueOf(startDateStr);
        java.sql.Date uploadEndDate   = java.sql.Date.valueOf(endDateStr);

        /* Yayın linki zorunlu mu? */
        if ("yes".equalsIgnoreCase(projectPublished) &&
            (publishLink == null || publishLink.isBlank())) {
            req.setAttribute("errorMessage", "Publish linki girmelisiniz!");
            req.getRequestDispatcher("upload.jsp").forward(req, res);
            return;
        }

        /* -------------------------------------------------
           3) Dosyaları sunucuya kaydet
           ------------------------------------------------- */
        String appPath = req.getServletContext().getRealPath("");

        /* Görsel dosyası */
        Part   imagePart = req.getPart("projectImage");
        String imageName = extractFileName(imagePart);
        File   imgDir    = new File(appPath, UPLOAD_DIR_IMG);
        if (!imgDir.exists()) imgDir.mkdirs();
        imagePart.write(new File(imgDir, imageName).getAbsolutePath());

        /* ZIP dosyası */
        Part   zipPart = req.getPart("projectZip");
        String zipName = extractFileName(zipPart);
        File   zipDir  = new File(appPath, UPLOAD_DIR_ZIP);
        if (!zipDir.exists()) zipDir.mkdirs();
        zipPart.write(new File(zipDir, zipName).getAbsolutePath());

        /* -------------------------------------------------
           4) Model nesnesi
           -------------------------------------------------
           Project sınıfınızda aşağıdaki sıra ile **14 parametreli**
           bir constructor bulunmalıdır. Sırayı farklı tutuyorsanız
           bu çağrıyı kendi constructor'ınıza göre düzenleyin.
           ------------------------------------------------- */
        Project pr = new Project(
                projectTopic, uploadStartDate, uploadEndDate,
                courseName, advisorName, userName,          // uploaderName EKLENDİ
                githubLink, libraryLink,
                projectDescription, imageName, zipName,
                projectPublished, publishLink, projectAwards
        );
       
    // ← yalnızca bu satır

        /* -------------------------------------------------
           5) Veritabanına ekle
           ------------------------------------------------- */
        ProjectDAO dao = new ProjectDAO();
        if (!dao.insertProject(pr)) {
            req.setAttribute("errorMessage", "Aynı proje zaten kayıtlı!");
            req.getRequestDispatcher("upload.jsp").forward(req, res);
            return;
        }

        /* -------------------------------------------------
           6) Listeyi yenile ve project.jsp'ye yönlendir
           ------------------------------------------------- */
        List<Project> list = dao.getAllProjects();
        req.setAttribute("projectList", list);
        req.getRequestDispatcher("project.jsp").forward(req, res);
    }

    /* =====================================================
       Yardımcı metotlar
       ===================================================== */
    /** Multipart form alanını String olarak okur */
    private String readFormField(Part part) throws IOException {
        if (part == null) return null;
        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(part.getInputStream(), "UTF-8"))) {
            StringBuilder sb = new StringBuilder(); String line;
            while ((line = br.readLine()) != null)
                sb.append(line);
            return sb.toString();
        }
    }

    /** Tarayıcının gönderdiği dosya adını çeker */
    private String extractFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename"))
                return cd.substring(cd.indexOf('=') + 2, cd.length() - 1);
        }
        return "";
    }
}
