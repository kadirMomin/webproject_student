import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/UserServlet"})
public class UserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Türkçe karakter desteği
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");
        UserDAO dao = new UserDAO();
        
        if ("signup".equals(action)) {
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            User user = new User(username, email, password);
            if (dao.signUp(user)) {
                response.sendRedirect("index2.jsp?show=signin");
            } else {
                response.sendRedirect("index2.jsp?error=signup");
            }
        } else if ("signin".equals(action)) {
            String email = request.getParameter("email"); // username yerine email alınıyor
            String password = request.getParameter("password");

            if (dao.signIn(email, password)) {
                // --- Yeni Eklenti ---
                // Email doğrulaması başarılı ise, ilgili UserName'i session'a ekleyelim.
                String userName = dao.getUserNameByEmail(email);
                request.getSession().setAttribute("user", email);
                request.getSession().setAttribute("userName", userName);
                
                String returnPage = request.getParameter("return");
                if (returnPage != null && !returnPage.isEmpty()) {
                    response.sendRedirect(returnPage);
                } else {
                    response.sendRedirect("upload.jsp");
                }
            } else {
                response.sendRedirect("index2.jsp?error=signin");
            }
        } else {
            response.sendRedirect("index2.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("index2.jsp");
    }
}
