<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="java.util.List, project.Project" %>

<%
    /* --- Oturum & request verileri --- */
    String userName       = (String) session.getAttribute("userName");
    if (userName == null) {          // giriş kontrolü
        response.sendRedirect("index2.jsp?error=loginfirst&return=profile.jsp");
        return;
    }
    String email                = (String) request.getAttribute("email");
    List<Project> userProjects  = (List<Project>) request.getAttribute("userProjects");
    String successMessage       = (String) request.getAttribute("successMessage");
    String errorMessage         = (String) request.getAttribute("errorMessage");
%>

<!DOCTYPE html>
<html lang="tr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title><%= userName %> - Profilim</title>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
  <style>
    :root {
      --primary-color: #4361ee;
      --secondary-color: #3f37c9;
      --success-color: #4cc9f0;
      --error-color: #f72585;
      --light-gray: #f8f9fa;
      --dark-gray: #6c757d;
      --white: #ffffff;
      --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }
    
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    
    body {
      font-family: 'Roboto', sans-serif;
      background-color: #f5f7fa;
      color: #333;
      line-height: 1.6;
    }
    
    .container {
      max-width: 1200px;
      margin: 2rem auto;
      padding: 0 20px;
    }
    
    h1 {
      color: var(--primary-color);
      margin-bottom: 2rem;
      font-weight: 500;
      text-align: center;
    }
    
    h2 {
      color: var(--secondary-color);
      margin-bottom: 1.5rem;
      font-weight: 500;
      font-size: 1.5rem;
      border-bottom: 2px solid var(--light-gray);
      padding-bottom: 0.5rem;
    }
    
    .profile-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
      gap: 2rem;
      margin-top: 2rem;
    }
    
    .card {
      background: var(--white);
      border-radius: 10px;
      padding: 1.5rem;
      box-shadow: var(--shadow);
      transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    
    .card:hover {
      transform: translateY(-5px);
      box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
    }
    
    .info-table {
      width: 100%;
      border-collapse: collapse;
    }
    
    .info-table tr:not(:last-child) {
      border-bottom: 1px solid var(--light-gray);
    }
    
    .info-table th, .info-table td {
      padding: 12px 0;
      text-align: left;
    }
    
    .info-table th {
      color: var(--dark-gray);
      font-weight: 400;
      width: 40%;
    }
    
    .info-table td {
      font-weight: 500;
    }
    
    .projects-list {
      list-style-type: none;
    }
    
    .projects-list li {
      padding: 12px 0;
      border-bottom: 1px solid var(--light-gray);
      display: flex;
      align-items: center;
    }
    
    .projects-list li:before {
      content: "•";
      color: var(--primary-color);
      font-size: 1.5rem;
      margin-right: 10px;
    }
    
    .password-form {
      margin-top: 1.5rem;
    }
    
    .form-group {
      margin-bottom: 1.2rem;
    }
    
    label {
      display: block;
      margin-bottom: 0.5rem;
      color: var(--dark-gray);
      font-weight: 400;
    }
    
    input[type="password"] {
      width: 100%;
      padding: 12px;
      border: 1px solid #ddd;
      border-radius: 5px;
      font-size: 1rem;
      transition: border 0.3s ease;
    }
    
    input[type="password"]:focus {
      outline: none;
      border-color: var(--primary-color);
    }
    
    button {
      background-color: var(--primary-color);
      color: white;
      border: none;
      padding: 12px 20px;
      border-radius: 5px;
      cursor: pointer;
      font-size: 1rem;
      font-weight: 500;
      transition: background-color 0.3s ease;
      width: 100%;
    }
    
    button:hover {
      background-color: var(--secondary-color);
    }
    
    .alert {
      padding: 15px;
      margin-bottom: 2rem;
      border-radius: 5px;
      font-weight: 500;
    }
    
    .alert-success {
      background-color: rgba(76, 201, 240, 0.2);
      color: #0a9396;
      border-left: 4px solid var(--success-color);
    }
    
    .alert-error {
      background-color: rgba(247, 37, 133, 0.2);
      color: #ae2012;
      border-left: 4px solid var(--error-color);
    }
    
    @media (max-width: 768px) {
      .profile-grid {
        grid-template-columns: 1fr;
      }
    }
  </style>
</head>

<body>
  <div class="container">
    <h1>Hoş Geldiniz, <span style="color: var(--secondary-color);"><%= userName %></span></h1>

    <% if (successMessage != null) { %>
      <div class="alert alert-success"><%= successMessage %></div>
    <% } else if (errorMessage != null) { %>
      <div class="alert alert-error"><%= errorMessage %></div>
    <% } %>

    <div class="profile-grid">
      <!-- PROFİL BİLGİLERİ -->
      <div class="card">
        <h2><i class="fas fa-user-circle" style="margin-right: 10px;"></i>Profil Bilgileri</h2>
        <table class="info-table">
          <tr><th>Kullanıcı Adı:</th><td><%= userName %></td></tr>
          <tr><th>E-Posta:</th><td><%= email == null ? "—" : email %></td></tr>
        </table>
      </div>

      <!-- YÜKLEDİĞİNİZ PROJELER -->
      <div class="card">
        <h2><i class="fas fa-project-diagram" style="margin-right: 10px;"></i>Projeleriniz</h2>
        <ul class="projects-list">
          <% if (userProjects != null && !userProjects.isEmpty()) {
                 for (Project p : userProjects) { %>
              <li><%= p.getProjectTopic() %></li>
          <% } } else { %>
              <li>Henüz proje yüklemediniz.</li>
          <% } %>
        </ul>
      </div>

      <!-- ŞİFRE GÜNCELLE -->
      <div class="card">
        <h2><i class="fas fa-key" style="margin-right: 10px;"></i>Şifre Güncelle</h2>
        <form action="ProfileServlet" method="post" class="password-form">
          <div class="form-group">
            <label for="oldPassword">Eski Şifre:</label>
            <input type="password" id="oldPassword" name="oldPassword" required>
          </div>
          <div class="form-group">
            <label for="newPassword">Yeni Şifre:</label>
            <input type="password" id="newPassword" name="newPassword" required>
          </div>
          <div class="form-group">
            <label for="confirmPassword">Yeni Şifre (Tekrar):</label>
            <input type="password" id="confirmPassword" name="confirmPassword" required>
          </div>
          <button type="submit">Şifreyi Güncelle</button>
        </form>
      </div>
    </div>
  </div>
  
  <!-- Font Awesome for icons -->
  <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
</body>
</html>