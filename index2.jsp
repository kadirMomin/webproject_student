<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <script src="https://kit.fontawesome.com/64d58efce2.js" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="style2.css" />
    <title>Sign in & Sign up Form</title>
  </head>
  <body>
    <div class="container">
      <div class="forms-container">
        <div class="signin-signup">
          <!-- Sign in Form -->
          <form action="UserServlet" method="post" class="sign-in-form">
            <h2 class="title">Sign in</h2>
            <!-- Gizli alanla formun türünü belirtiyoruz -->
            <input type="hidden" name="action" value="signin" />
            <!-- Eğer URL'de return parametresi varsa, formda saklayalım -->
            <input type="hidden" name="return" value="<%= request.getParameter("return") != null ? request.getParameter("return") : "" %>" />
            <% if("signin".equals(request.getParameter("error"))) { %>
              <div style="color: red; margin-bottom: 10px;">Böyle kayıt yoktur.</div>
            <% } %>
            <div class="input-field">
              <i class="fas fa-envelope"></i>
              <!-- Burada "username" yerine "email" kullanıyoruz -->
              <input type="email" name="email" placeholder="Email" required />
            </div>
            <div class="input-field">
              <i class="fas fa-lock"></i>
              <input type="password" name="password" placeholder="Password" required />
            </div>
            <input type="submit" value="Login" class="btn solid" />
            <p class="social-text">Or Sign in with social platforms</p>
            <div class="social-media">
              <a href="#" class="social-icon">
                <i class="fab fa-facebook-f"></i>
              </a>
              <a href="#" class="social-icon">
                <i class="fab fa-twitter"></i>
              </a>
              <a href="#" class="social-icon">
                <i class="fab fa-google"></i>
              </a>
              <a href="#" class="social-icon">
                <i class="fab fa-linkedin-in"></i>
              </a>
            </div>
          </form>
          <!-- Sign up Form -->
          <form action="UserServlet" method="post" class="sign-up-form">
            <h2 class="title">Sign up</h2>
            <input type="hidden" name="action" value="signup" />
            <div class="input-field">
              <i class="fas fa-user"></i>
              <input type="text" name="username" placeholder="Username" required />
            </div>
            <div class="input-field">
              <i class="fas fa-envelope"></i>
              <input type="email" name="email" placeholder="Email" required />
            </div>
            <div class="input-field">
              <i class="fas fa-lock"></i>
              <input type="password" name="password" placeholder="Password" required />
            </div>
            <input type="submit" class="btn" value="Sign up" />
            <p class="social-text">Or Sign up with social platforms</p>
            <div class="social-media">
              <a href="#" class="social-icon">
                <i class="fab fa-facebook-f"></i>
              </a>
              <a href="#" class="social-icon">
                <i class="fab fa-twitter"></i>
              </a>
              <a href="#" class="social-icon">
                <i class="fab fa-google"></i>
              </a>
              <a href="#" class="social-icon">
                <i class="fab fa-linkedin-in"></i>
              </a>
            </div>
          </form>
        </div>
      </div>
      <div class="panels-container">
        <div class="panel left-panel">
          <div class="content">
            <h3>New here?</h3>
            <p>Don't have an account yet? Sign up and get access to all our services.</p>
            <button class="btn transparent" id="sign-up-btn">Sign up</button>
          </div>
        </div>
        <div class="panel right-panel">
          <div class="content">
            <h3>One of us?</h3>
            <p>Already made an account here? Sign in and get access to all our services.</p>
            <button class="btn transparent" id="sign-in-btn">Sign in</button>
          </div>
        </div>
      </div>
    </div>
    <script src="app.js"></script>
  </body>
</html>
