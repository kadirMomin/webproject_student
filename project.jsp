<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.*, project.Project, project.ProjectDAO" %>
<%
    String user = (String) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("index2.jsp?error=loginfirst&return=project.jsp");
        return;
    }
    
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
    /* DEĞİŞMEYEN TÜM CSS KURALLARI AYNEN KALIYOR */
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
    
    /* SADECE ŞU KISIMLARI DEĞİŞTİRİYORUZ */
    #getting-started-container {
      max-width: 95%; /* Ekranın %95'ini kullan (daha dar) */
      margin: 20px auto; /* Otomatik merkezleme */
      padding: 15px;
      background-color: #fff;
      border-radius: 6px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
      overflow-x: auto; /* Yatay kaydırma eklendi */
    }
    
    #getting-started-container table {
      width: 100%;
      margin: 10px 0;
      border-collapse: collapse;
      table-layout: auto; /* Hücreler içeriğe göre genişlesin */
    }
    
    #getting-started-container th,
    #getting-started-container td {
      background-color: #fff;
      border: 1px solid #ddd; /* Daha hafif bir border */
      padding: 10px 12px; /* Padding'i biraz azalttık */
      text-align: left;
      min-width: 80px; /* Minimum genişlik azaltıldı */
    }
    
    #getting-started-container th {
      background-color: #4caf50;
      color: white;
      position: sticky;
      top: 0;
    }
    
    /* Kalan CSS kuralları aynen kalıyor */
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
  <!-- HEADER VE NAV KISMI TAMAMEN AYNI -->
  <header>
    <img id="logo" src="1.png" alt="Logo">
    <h1>Getting Started</h1>
    <nav>
      <div id="search-bar">
        <input type="text" id="search-input" placeholder="Search projects...">
        <button id="search-button" type="button">Search</button>
        <ul id="suggestions"></ul>
      </div>
      <a href="insert.jsp">HOME</a>
      <a href="project.jsp">Projects</a>
      <a href="upload.jsp">UPLOAD</a>
      <a href="FAQs.jsp">FAQs</a>
      <a href="index2.jsp">SIGN UP OR SIGN IN</a>
    </nav>
  </header>
  
  <!-- TABLO KISMI (HTML YAPISI AYNI) -->
  <div id="getting-started-container">
    <table id="projects-table">
      <thead>
        <tr>
          <th>Proje Konusu</th>
          <th>Yüklenen Zamanı</th>
          <th>Ders Adı</th>
          <th>Danışman Adı</th>
          <th>GitHub Link</th>
          <th>Kütüphane Linki</th>
          <th>Publish Durumu</th>
          <th>Ödül Sayısı (1-5)</th>
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
          <td><a href="<%= p.getLibraryLink() %>" target="_blank"><%= p.getLibraryLink() %></a></td>
          <td><%= p.getProjectPublished().equalsIgnoreCase("yes") ? "Evet" : "Hayır" %></td>
          <td><%= p.getProjectAwards() %></td>
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
      
  <!-- JAVASCRIPT KODU TAMAMEN AYNI KALIYOR -->
  <script>
    const searchInput = document.getElementById('search-input');
    const suggestionsList = document.getElementById('suggestions');
    const searchButton = document.getElementById('search-button');
    const projectsBody = document.getElementById('projects-body');

    searchButton.addEventListener('click', function() {
      const term = searchInput.value.trim();
      if(term.length === 0) return;
      
      fetch('ProjectSearchResultsServlet?term=' + encodeURIComponent(term))
          .then(response => response.json())
          .then(data => {
              projectsBody.innerHTML = '';
              if(data.length > 0){
                  data.forEach(p => {
                      console.log("Gelen veri:", p);
                      const zamanStr = p.uploadStartDate + " / " + p.uploadEndDate;
                      const tr = document.createElement('tr');
                      const td1 = document.createElement('td');
                      td1.textContent = p.projectTopic || '';
                      const td2 = document.createElement('td');
                      td2.textContent = zamanStr || '';
                      const td3 = document.createElement('td');
                      td3.textContent = p.courseName || '';
                      const td4 = document.createElement('td');
                      td4.textContent = p.advisorName || '';
                      const td5 = document.createElement('td');
                      const link = document.createElement('a');
                      link.href = p.githubLink || '#';
                      link.target = '_blank';
                      link.textContent = 'GitHub Link';
                      td5.appendChild(link);
                      const td6 = document.createElement('td');
                      const libLink = document.createElement('a');
                      libLink.href = p.libraryLink || '#';
                      libLink.target = '_blank';
                      libLink.textContent = p.libraryLink || '';
                      td6.appendChild(libLink);
                      const td7 = document.createElement('td');
                      td7.textContent = (p.projectPublished && p.projectPublished.toLowerCase() === "yes") ? "Evet" : "Hayır";
                      const td8 = document.createElement('td');
                      td8.textContent = p.projectAwards || '';
                      const td9 = document.createElement('td');
                      const form = document.createElement('form');
                      form.action = 'ProjectDetailServlet';
                      form.method = 'get';
                      form.style.margin = '0';
                      const input = document.createElement('input');
                      input.type = 'hidden';
                      input.name = 'projectTopic';
                      input.value = p.projectTopic || '';
                      const button = document.createElement('button');
                      button.type = 'submit';
                      button.className = 'btn btn-info';
                      button.textContent = 'Detay Göster';
                      form.appendChild(input);
                      form.appendChild(button);
                      td9.appendChild(form);
                      tr.appendChild(td1);
                      tr.appendChild(td2);
                      tr.appendChild(td3);
                      tr.appendChild(td4);
                      tr.appendChild(td5);
                      tr.appendChild(td6);
                      tr.appendChild(td7);
                      tr.appendChild(td8);
                      tr.appendChild(td9);
                      projectsBody.appendChild(tr);
                  });
              } else {
                  projectsBody.innerHTML = '<tr><td colspan="9">Kayıt bulunamadı!</td></tr>';
              }
          })
          .catch(error => {
              console.error('Error:', error);
              projectsBody.innerHTML = '<tr><td colspan="9">Hata oluştu!</td></tr>';
          });
    });

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