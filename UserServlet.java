package project;

import advisor.AdvisorDAO;
import course.CourseDAO;
import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *  • /signup  →  kayıt  <br>
 *  • /signin  →  giriş  <br>
 *  Başarılı girişten sonra:
 *    - onaylı ders + danışman VAR  → upload.jsp
 *    - eksik / onaysız                → courses.jsp
 *    - URL'de return=? parametresi    → önce o sayfa
 */
@WebServlet(urlPatterns = {"/UserServlet"})
public class UserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        /* ——— Türkçe karakter ——— */
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");   // signup | signin
        UserDAO  uDao = new UserDAO();

        /* =====================================================
           1)  KAYIT  (sign-up)
           ===================================================== */
        if ("signup".equals(action)) {

            String username = request.getParameter("username");
            String email    = request.getParameter("email");
            String password = request.getParameter("password");

            User user = new User(username, email, password);
            if (uDao.signUp(user)) {
                response.sendRedirect("index2.jsp?show=signin");   // kayıt → giriş sekmesi
            } else {
                response.sendRedirect("index2.jsp?error=signup");
            }

        /* =====================================================
           2)  GİRİŞ  (sign-in)
           ===================================================== */
        } else if ("signin".equals(action)) {

            String email    = request.getParameter("email");     // kullanıcı artık e-posta
            String password = request.getParameter("password");

            if (uDao.signIn(email, password)) {

                /* —— oturum bilgileri —— */
                String userName = uDao.getUserNameByEmail(email);
                HttpSession ses = request.getSession(true);
                ses.setAttribute("user"    , email);     // kimlik: e-posta
                ses.setAttribute("userName", userName);  // ekrana göstermek için

                /* —— yönlendirme kararı —— */
                String returnPage = request.getParameter("return");   // ?return=… varsa

                if (returnPage != null && !returnPage.isEmpty()) {

                    response.sendRedirect(returnPage);

                } else {

                    CourseDAO  cDao = new CourseDAO();
                    AdvisorDAO aDao = new AdvisorDAO();

                    boolean okCourse  = cDao.hasApprovedCourse(email);  // onaylı ders
                    boolean okAdvisor = aDao.hasAdvisor      (email);  // danışman seçilmiş

                    if (okCourse && okAdvisor) {
                        response.sendRedirect("upload.jsp");   // her şey hazır
                    } else {
                        response.sendRedirect("courses.jsp");  // önce seçim / onay süreci
                    }
                }

            } else {
                response.sendRedirect("index2.jsp?error=signin");
            }

        /* =====================================================
           3)  Geçersiz “action”
           ===================================================== */
        } else {
            response.sendRedirect("index2.jsp");
        }
    }

    /* GET istekleri için ana sayfaya yönlendiriyoruz */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("index2.jsp");
    }
}
