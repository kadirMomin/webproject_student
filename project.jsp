<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.*, project.Project, project.ProjectDAO" %>

<%
    // Kullanıcının oturum açıp açmadığını kontrol ediyoruz.
    String user = (String) session.getAttribute("user");
    if (user == null) {
        // Oturum açılmamışsa, login sayfasına yönlendiriyoruz.
        // Burada "return" parametresini project.jsp olarak belirtiyoruz.
        response.sendRedirect("index2.jsp?error=loginfirst&return=project.jsp");
        return;
    }
%>
  
<!DOCTYPE html> 
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Getting Started - Your Platform Name</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f2f2f2;
      padding: 20px;
    }
    header {
      background-color: #343a40;
      padding: 20px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      flex-wrap: wrap;
    }
    h1 {
      margin: 0;
      color: #fff;
      font-size: 24px;
      flex: 1;
      text-align: center;
    }
    #logo {
      width: 150px;
      margin-right: 20px;
    }
    nav {
      display: flex;
      align-items: center;
      gap: 20px;
      flex-wrap: wrap;
    }
    nav a {
      color: #fff;
      text-decoration: none;
      font-size: 16px;
      padding: 8px 12px;
      border-radius: 5px;
      transition: background-color 0.3s ease;
    }
    nav a:hover {
      background-color: #95c11e;
      color: #000;
    }
    #search-bar {
      display: flex;
      align-items: center;
      gap: 10px;
    }
    #search-input {
      padding: 10px;
      font-size: 16px;
      border: 1px solid #ccc;
      border-radius: 5px;
      background-color: #fff;
      color: #000;
      width: 200px;
    }
    #search-button {
      padding: 10px 15px;
      font-size: 16px;
      background-color: #007bff;
      color: #fff;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      transition: background-color 0.3s ease;
    }
    #search-button:hover {
      background-color: #0056b3;
    }
    /* Container: sol tarafa hizalanmış */
    #getting-started-container {
      max-width: 1200px;
      margin: 20px 0;  /* Sağ-sol margin sıfır */
      padding: 20px;
      background-color: #fff;
      border-radius: 6px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
      text-align: left;
    }
    /* Tabloyu container’ın soluna yaslamak için margin sol sıfır */
    #getting-started-container table {
      width: 100%;
      margin: 20px 0 20px 0; /* Tüm kenarlarda 20px üst-alt, 0 sol-sağ */
      border-collapse: collapse;
      background-color: transparent; /* Container'ın beyazı görünür */
    }
    /* Tüm hücrelere beyaz arka plan */
    #getting-started-container th,
    #getting-started-container td {
      background-color: #fff;
      border: 1px solid black;
      padding: 25px;
      text-align: left;
      min-width: 150px;
    }
    #getting-started-container th {
      background-color: #4caf50;
      color: white;
    }
    .btn {
      padding: 5px 10px;
      border-radius: 5px;
      font-size: 14px;
      text-decoration: none;
      color: white;
    }
    .btn-info {
      background-color: #17a2b8;
    }
    .btn-info:hover {
      background-color: #138496;
    }
    a {
      color: #007bff;
      text-decoration: none;
    }
    a:hover {
      text-decoration: underline;
    }
    footer {
      background-color: #343a40;
      padding: 10px;
      text-align: center;
      position: fixed;
      bottom: 0;
      width: 100%;
      color: #fff;
    }
  </style>
</head>
<body>
  <header>
    <img id="logo" src="1.png" alt="Logo">
    <h1>Getting Started</h1>
    <nav>
      <div id="search-bar">
        <input type="text" id="search-input" placeholder="Search projects...">
        <button id="search-button">Search</button>
      </div>
      <a href="insert.jsp">HOME</a>
      <a href="project.jsp">Projects</a>
      <a href="upload.jsp">UPLOAD</a>
      <a href="FAQs.jsp">FAQs</a>
      <a href="index2.jsp">SIGN UP OR SIGN IN</a>
    </nav>
  </header>
  <div id="getting-started-container">
    <table>
      <thead>
        <tr>
          <th>Proje Konusu</th>
          <th>Yüklenen Zamanı</th>
          <th>Ders Adı</th>
          <th>Danışman Adı</th>
          <th>GitHub Link</th>
          <th>Proje Açıklaması</th>
          <th>İşlemler</th>
        </tr>
      </thead>
      <tbody>
        <%
            // Servlet'ten gönderilen "projectList" attribute'unu kontrol edelim
            List<Project> projectList = (List<Project>) request.getAttribute("projectList");
            if (projectList == null) {
                projectList = new ProjectDAO().getAllProjects();
            }
            
            if (projectList != null && !projectList.isEmpty()) {
                for (Project p : projectList) {
                    // "Yüklenen Zamanı" sütununda StartDate / EndDate şeklinde göstereceğiz
                    String zamanStr = p.getUploadStartDate() + " / " + p.getUploadEndDate();
        %>
        <tr>
          <td><%= p.getProjectTopic() %></td>
          <td><%= zamanStr %></td>
          <td><%= p.getCourseName() %></td>
          <td><%= p.getAdvisorName() %></td>
          <td><a href="<%= p.getGithubLink() %>" target="_blank">GitHub Link</a></td>
          <td><%= p.getProjectDescription() %></td>
          <td>
            <form action="ProjectDetailServlet" method="get" style="margin:0;">
              <!-- Burada benzersiz bir parametre kullanmalısınız. Örneğin, proje konusu veya id -->
              <input type="hidden" name="projectTopic" value="<%= p.getProjectTopic() %>">
              <button type="submit" class="btn btn-info">Detay Göster</button>
            </form>
          </td>
        </tr>
        <%
                }
            } else {
        %>
        <tr>
          <td colspan="7">Kayıt bulunamadı!</td>
        </tr>
        <%
            }
        %>
      </tbody>
    </table>
  </div>
  <footer>
    <p>&copy; 2025 Your Platform Name. All rights reserved.</p>
  </footer>
      
       <!-- Sayfa yüklendiğinde localStorage'dan dili kontrol eden ve uygulayan JavaScript kodu -->
  <script>
    document.addEventListener('DOMContentLoaded', () => {
        // Eğer localStorage'da dil seçimi varsa onu al, yoksa varsayılan olarak "en" kullan.
        const savedLanguage = localStorage.getItem('language') || 'en';
        changeLanguage(savedLanguage);
    });
    
    function changeLanguage(lang) {
        document.querySelectorAll('[data-lang]').forEach(element => {
            if (element.getAttribute('data-lang') === lang) {
                element.style.display = 'block';
            } else {
                element.style.display = 'none';
            }
        });
    }
  </script>
</body>
</html>
