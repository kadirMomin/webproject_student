package project;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {

    private final UserDAO    userDao    = new UserDAO();
    private final ProjectDAO projectDao = new ProjectDAO();

    /* =====================================================
       PROFİL SAYFASINI GETİR
       ===================================================== */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userName") == null) {
            resp.sendRedirect("index2.jsp?error=loginfirst&return=profile.jsp");
            return;
        }

        String userName = (String) session.getAttribute("userName");

        /* Kullanıcı bilgileri + projeleri al */
        String email = userDao.getEmailByUserName(userName);
        List<Project> userProjects = projectDao.getProjectsByUserName(userName);

        /* JSP’ye aktar */
        req.setAttribute("email",        email);
        req.setAttribute("userProjects", userProjects);

        req.getRequestDispatcher("profile.jsp").forward(req, resp);
    }

    /* =====================================================
       ŞİFREYİ GÜNCELLE
       ===================================================== */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userName") == null) {
            resp.sendRedirect("index2.jsp?error=loginfirst&return=profile.jsp");
            return;
        }

        String userName = (String) session.getAttribute("userName");
        String oldPwd   = req.getParameter("oldPassword");
        String newPwd   = req.getParameter("newPassword");
        String confirm  = req.getParameter("confirmPassword");

        /* 1) Yeni şifre alanları uyuşuyor mu? */
        if (newPwd == null || !newPwd.equals(confirm)) {
            req.setAttribute("errorMessage", "Yeni şifreler eşleşmiyor!");
            doGet(req, resp);          // tekrar profile.jsp göster
            return;
        }

        /* 2) Veritabanında güncellemeyi dene */
        boolean ok = userDao.updatePassword(userName, oldPwd, newPwd);

        if (ok) {
            /* --- BAŞARILI: project.jsp’ye yönlendir --- */
            resp.sendRedirect(req.getContextPath() + "/project.jsp?pwd=updated");
        } else {
            /* --- HATALI: profile.jsp’de mesaj göster --- */
            req.setAttribute("errorMessage",
                    "Eski şifre hatalı veya güncelleme başarısız.");
            doGet(req, resp);
        }
    }
}
