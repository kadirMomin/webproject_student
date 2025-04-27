package project;

import java.io.*;
import java.util.List;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

@WebServlet("/ProjectServlet")
@MultipartConfig
public class ProjectServlet extends HttpServlet {

    private static final String UPLOAD_DIR_IMG = "uploads";        // resimler
    private static final String UPLOAD_DIR_ZIP = "uploads/zips";   // ZIP’ler

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");

        /* Form alanları */
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

        /* Link zorunlu kontrolü */
        if("yes".equalsIgnoreCase(projectPublished) &&
           (publishLink==null || publishLink.isBlank())){
            req.setAttribute("errorMessage","Publish linki girmelisiniz!");
            req.getRequestDispatcher("upload.jsp").forward(req,res);
            return;
        }

        /* ---------- Dosyaları kaydet ---------- */
        String appPath = req.getServletContext().getRealPath("");

        /* Resim */
        Part   imagePart   = req.getPart("projectImage");
        String imageName   = extractFileName(imagePart);
        File   imgDir      = new File(appPath, UPLOAD_DIR_IMG);
        if(!imgDir.exists()) imgDir.mkdirs();
        imagePart.write(new File(imgDir, imageName).getAbsolutePath());

        /* ZIP (projectFile) */
        Part   zipPart     = req.getPart("projectZip");
        String zipName     = extractFileName(zipPart);
        File   zipDir      = new File(appPath, UPLOAD_DIR_ZIP);
        if(!zipDir.exists()) zipDir.mkdirs();
        zipPart.write(new File(zipDir, zipName).getAbsolutePath());

        /* ---------- Model ---------- */
        Project pr = new Project(projectTopic, uploadStartDate, uploadEndDate,
                                 courseName, advisorName,
                                 githubLink, libraryLink,
                                 projectDescription, imageName, zipName,   // ← ZIP adı
                                 projectPublished, publishLink, projectAwards);

        /* ---------- DAO işlemleri ---------- */
        ProjectDAO dao = new ProjectDAO();
        if(!dao.insertProject(pr)){
            req.setAttribute("errorMessage","Aynı proje zaten kayıtlı!");
            req.getRequestDispatcher("upload.jsp").forward(req,res);
            return;
        }

        List<Project> list = dao.getAllProjects();
        req.setAttribute("projectList", list);
        req.getRequestDispatcher("project.jsp").forward(req,res);
    }

    /* Yardımcı metotlar */
    private String readFormField(Part part) throws IOException{
        if(part==null){ return null; }
        try(BufferedReader br = new BufferedReader(
                new InputStreamReader(part.getInputStream(),"UTF-8"))){
            StringBuilder sb = new StringBuilder(); String line;
            while((line=br.readLine())!=null){ sb.append(line); }
            return sb.toString();
        }
    }
    private String extractFileName(Part part){
        for(String cd : part.getHeader("content-disposition").split(";")){
            if(cd.trim().startsWith("filename")){
                return cd.substring(cd.indexOf('=')+2, cd.length()-1);
            }
        }
        return "";
    }
}
