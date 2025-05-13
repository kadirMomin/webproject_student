package admin;

import java.io.IOException;
import java.util.Optional;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String act = req.getParameter("action");          // login | register | logout
        AdminDAO dao = new AdminDAO();

        /* ---------- ÇIKIŞ ---------- */
        if ("logout".equalsIgnoreCase(act)) {
            req.getSession().invalidate();
            resp.sendRedirect("combined.jsp?logout");
            return;
        }

        /* ---------- KAYIT ---------- */
        if ("register".equalsIgnoreCase(act)) {
            String full = req.getParameter("fullName");
            String mail = req.getParameter("email");
            String pwd  = req.getParameter("password");

            boolean ok = dao.register(new Admin(full, mail, pwd));
            resp.sendRedirect(ok ? "combined.jsp?registerSuccess"
                                 : "combined.jsp?registerError");
            return;
        }

        /* ---------- GİRİŞ ---------- */
        if ("login".equalsIgnoreCase(act)) {
            String mail = req.getParameter("email");
            String pwd  = req.getParameter("password");

            if (dao.login(mail, pwd)) {
                /* oturumu oluştur ve ad-soyadı çek */
                HttpSession ses = req.getSession(true);
                ses.setAttribute("admin", mail);

                Optional<Admin> adm = dao.findByEmail(mail);
                ses.setAttribute("adminName",
                                 adm.map(Admin::getFullName).orElse("Admin"));

                resp.sendRedirect("admin.jsp");           // yönetici paneli
            } else {
                resp.sendRedirect("combined.jsp?loginError");
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.sendRedirect("combined.jsp");
    }
}
