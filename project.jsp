<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.*, project.Project, project.ProjectDAO" %>
<%
    // Kullanıcının oturum açıp açmadığını kontrol ediyoruz.
    String user = (String) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("index2.jsp?error=loginfirst&return=project.jsp");
        return;
    }
    
    // Sayfa ilk açıldığında tüm projeleri getiriyoruz.
    List<Project> projectList = (List<Project>) request.getAttribute("projectList");
    if (projectList == null) {
        projectList = new ProjectDAO().getAllProjects();
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
    /* Arama kutusu ve öneri listesi için ek CSS */
    #search-bar {
      display: flex;
      align-items: center;
      gap: 10px;
      position: relative;
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
    /* Öneri listesi stili */
    #suggestions {
      position: absolute;
      top: 40px;
      left: 0;
      background-color: #fff;
      border: 1px solid #ccc;
      width: 100%;
      list-style: none;
      padding: 0;
      margin: 0;
      z-index: 1000;
      display: none;
    }
    #suggestions li {
      padding: 8px;
      cursor: pointer;
    }
    #suggestions li:hover {
      background-color: #f2f2f2;
    }
    /* Container: sol tarafa hizalanmış */
    #getting-started-container {
      max-width: 1200px;
      margin: 20px 0;
      padding: 20px;
      background-color: #fff;
      border-radius: 6px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
      text-align: left;
    }
    #getting-started-container table {
      width: 100%;
      margin: 20px 0;
      border-collapse: collapse;
      background-color: transparent;
    }
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
        <ul id="suggestions"></ul>
      </div>
      <a href="insert.jsp">HOME</a>
      <a href="project.jsp">Projects</a>
      <a href="upload.jsp">UPLOAD</a>
      <a href="FAQs.jsp">FAQs</a>
      <a href="index2.jsp">SIGN UP OR SIGN IN</a>
    </nav>
  </header>
  
  <!-- Proje listesi bölümü -->
  <div id="getting-started-container">
    <table id="projects-table">
      <thead>
        <tr>
          <th>Proje Konusu</th>
          <th>Yüklenen Zamanı</th>
          <th>Ders Adı</th>
          <th>Danışman Adı</th>
          <th>GitHub Link</th>
          <th>İşlemler</th>
        </tr>
      </thead>
      <tbody id="projects-body">
        <% for(Project p : projectList) {
             String zamanStr = p.getUploadStartDate() + " / " + p.getUploadEndDate(); %>
        <tr>
          <td><%= p.getProjectTopic() %></td>
          <td><%= zamanStr %></td>
          <td><%= p.getCourseName() %></td>
          <td><%= p.getAdvisorName() %></td>
          <td><a href="<%= p.getGithubLink() %>" target="_blank">GitHub Link</a></td>
          <td>
            <form action="ProjectDetailServlet" method="get" style="margin:0;">
              <input type="hidden" name="projectTopic" value="<%= p.getProjectTopic() %>">
              <button type="submit" class="btn btn-info">Detay Göster</button>
            </form>
          </td>
        </tr>
        <% } %>
      </tbody>
    </table>
  </div>
  
  <footer>
    <p>&copy; 2025 Your Platform Name. All rights reserved.</p>
  </footer>
      
  <!-- JavaScript: Arama kutusu için AJAX ile öneri getirme ve arama sonuçlarını güncelleme -->
  <script>
    const searchInput = document.getElementById('search-input');
    const suggestionsList = document.getElementById('suggestions');
    const searchButton = document.getElementById('search-button');
    const projectsBody = document.getElementById('projects-body');

    // Öneri getirme (input değişiminde)
    searchInput.addEventListener('input', function() {
      const term = searchInput.value.trim();
      if(term.length === 0){
          suggestionsList.style.display = 'none';
          return;
      }
      fetch('ProjectSearchServlet?term=' + encodeURIComponent(term))
        .then(response => response.json())
        .then(data => {
          suggestionsList.innerHTML = '';
          if(data.length > 0){
            data.forEach(item => {
              const li = document.createElement('li');
              li.textContent = item;
              li.addEventListener('click', () => {
                searchInput.value = item;
                suggestionsList.style.display = 'none';
              });
              suggestionsList.appendChild(li);
            });
            suggestionsList.style.display = 'block';
          } else {
            suggestionsList.style.display = 'none';
          }
        })
        .catch(error => {
          console.error('Error fetching suggestions:', error);
          suggestionsList.style.display = 'none';
        });
    });

    // Arama butonuna tıklanınca arama sonuçlarını güncelle
    searchButton.addEventListener('click', function() {
      const term = searchInput.value.trim();
      if(term.length === 0) return;
      
      fetch('ProjectSearchResultsServlet?term=' + encodeURIComponent(term))
        .then(response => response.json())
        .then(data => {
          // Gelen JSON (List<Project>) üzerinden HTML satırlarını oluşturup tabloyu güncelleyin.
          projectsBody.innerHTML = '';
          if(data.length > 0){
            data.forEach(p => {
              // Zaman bilgisini oluşturma
              const zamanStr = p.uploadStartDate + " / " + p.uploadEndDate;
              // Yeni satır oluşturma
              const tr = document.createElement('tr');
              tr.innerHTML = `
                <td>${p.projectTopic}</td>
                <td>${zamanStr}</td>
                <td>${p.courseName}</td>
                <td>${p.advisorName}</td>
                <td><a href="${p.githubLink}" target="_blank">GitHub Link</a></td>
                <td>
                  <form action="ProjectDetailServlet" method="get" style="margin:0;">
                    <input type="hidden" name="projectTopic" value="${p.projectTopic}">
                    <button type="submit" class="btn btn-info">Detay Göster</button>
                  </form>
                </td>
              `;
              projectsBody.appendChild(tr);
            });
          } else {
            projectsBody.innerHTML = '<tr><td colspan="7">Kayıt bulunamadı!</td></tr>';
          }
        })
        .catch(error => console.error('Error fetching search results:', error));
    });

    // Dil değiştirme fonksiyonu (mevcut kodunuz)
    document.addEventListener('DOMContentLoaded', () => {
        const savedLanguage = localStorage.getItem('language') || 'en';
        changeLanguage(savedLanguage);
    });
    
    function changeLanguage(lang) {
        document.querySelectorAll('[data-lang]').forEach(element => {
            element.style.display = (element.getAttribute('data-lang') === lang) ? 'block' : 'none';
        });
    }
  </script>
</body>
</html>
