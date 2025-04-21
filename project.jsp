<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="java.util.*, project.Project, project.ProjectDAO" %>
<%
    String user = (String) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("index2.jsp?error=loginfirst&return=project.jsp");
        return;
    }
    ProjectDAO projectDAO = new ProjectDAO();
    List<Project> projectList = (List<Project>) request.getAttribute("projectList");
    if (projectList == null) {
        projectList = projectDAO.getAllProjects();
    }
    int totalProjects = projectDAO.getTotalProjectCount();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Getting Started - Your Platform Name</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

  <style>
    /* ——— GLOBAL ——— */
    body{font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif;background:#f8f9fa;margin:0;color:#333;}

    /* ——— HEADER ——— */
    header{background:#2c3e50;padding:15px 30px;box-shadow:0 2px 10px rgba(0,0,0,.1);position:sticky;top:0;z-index:1000;}
      .header-container{display:flex;align-items:center;max-width:1400px;margin:0 auto;flex-wrap:wrap;width:100%;}
      .logo-container{display:flex;align-items:center;margin-right:30px;}
        #logo{width:40px;height:40px;margin-right:10px;}
        .brand{color:#fff;font-size:1.5rem;font-weight:600;text-decoration:none;}

      .nav-container{display:flex;align-items:center;flex-grow:1;justify-content:space-between;flex-wrap:wrap;}
      .search-container{display:flex;gap:10px;flex-grow:1;max-width:650px;margin:0 20px;}
        .search-box{display:flex;flex:1 1 0;}
          .search-input{flex:1;padding:10px 15px;border:none;border-radius:4px 0 0 4px;font-size:14px;outline:none;}
          .search-button{padding:0 15px;border:none;border-radius:0 4px 4px 0;cursor:pointer;color:#fff;transition:background .3s;}
          #search-button{background:#3498db;} #search-button:hover{background:#2980b9;}
          #advisor-search-button{background:#17a2b8;} #advisor-search-button:hover{background:#138496;}

      .nav-links{display:flex;align-items:center;list-style:none;margin:0;padding:0;}
        .nav-item{margin-left:15px;position:relative;}
        .nav-link{color:#ecf0f1;text-decoration:none;padding:8px 12px;border-radius:4px;font-size:15px;font-weight:500;display:flex;align-items:center;transition:background .3s;}
        .nav-link:hover{background:rgba(255,255,255,.1);color:#fff;}

      .dropdown-menu{position:absolute;right:0;background:#fff;min-width:200px;box-shadow:0 8px 16px rgba(0,0,0,.1);border-radius:4px;padding:10px 0;display:none;z-index:1000;}
      .dropdown:hover .dropdown-menu{display:block;}
      .dropdown-item{display:block;padding:10px 20px;color:#333;text-decoration:none;transition:background .3s;}
      .dropdown-item:hover{background:#f8f9fa;color:#2c3e50;}

      .user-profile{display:flex;align-items:center;cursor:pointer;}
      .user-avatar{width:32px;height:32px;border-radius:50%;margin-right:8px;background:#3498db;color:#fff;display:flex;align-items:center;justify-content:center;font-weight:bold;}

      .mobile-menu-btn{display:none;background:none;border:none;color:#fff;font-size:20px;cursor:pointer;}
      @media(max-width:992px){
        .header-container{flex-direction:column;align-items:stretch;}
        .nav-container{flex-direction:column;align-items:stretch;margin-top:15px;display:none;}
        .nav-container.active{display:flex;}
        .search-container{max-width:100%;flex-direction:column;}
        .search-box{flex:1;width:100%;}
        .nav-links{flex-direction:column;align-items:stretch;}
        .nav-item{margin:5px 0;}
        .dropdown-menu{position:static;box-shadow:none;width:100%;display:none;}
        .dropdown:hover .dropdown-menu{display:block;}
        .mobile-menu-btn{display:block;position:absolute;right:20px;top:20px;}
      }

    /* ——— TABLE & ETC. (DEĞİŞMEDİ) ——— */
    #getting-started-container{max-width:95%;margin:20px auto;padding:15px;background:#fff;border-radius:6px;box-shadow:0 0 10px rgba(0,0,0,.1);overflow-x:auto;}
    #getting-started-container table{width:100%;margin:10px 0;border-collapse:collapse;table-layout:auto;}
    #getting-started-container th,#getting-started-container td{background:#fff;border:1px solid #ddd;padding:10px 12px;text-align:left;min-width:80px;}
    #getting-started-container th{background:#4caf50;color:#fff;position:sticky;top:0;}

    .btn{padding:5px 10px;border-radius:5px;font-size:14px;text-decoration:none;color:#fff;}
    .btn-info{background:#17a2b8;}.btn-info:hover{background:#138496;}
    a{color:#007bff;text-decoration:none;} a:hover{text-decoration:underline;}

    footer{ background:#343a40; padding:4px 8px; text-align:center; position:fixed; bottom:0; width:100%; color:#fff; font-size:14px;} 
   .project-count{background:#4caf50;color:#fff;padding:8px 15px;border-radius:5px;margin-bottom:15px;display:inline-block;font-weight:bold;}
  </style>
</head>

<body>
<!-- ——— HEADER ——— -->
<header>
  <div class="header-container">
    <div class="logo-container">
      <img id="logo" src="1.png" alt="Logo">
      <a href="insert.jsp" class="brand">ProjectHub</a>
    </div>

    <button class="mobile-menu-btn" id="mobileMenuBtn"><i class="fas fa-bars"></i></button>

    <div class="nav-container" id="navContainer">

      <!-- Arama alanları -->
      <div class="search-container">
        <div class="search-box" id="search-bar">
          <input type="text" class="search-input" id="search-input" placeholder="Search projects...">
          <button class="search-button" id="search-button"><i class="fas fa-search"></i></button>
          <ul id="suggestions"></ul>
        </div>
        <div class="search-box" id="advisor-search-bar">
          <input type="text" class="search-input" id="advisor-search-input" placeholder="Search by advisor...">
          <button class="search-button" id="advisor-search-button"><i class="fas fa-user"></i></button>
        </div>
      </div>

      <!-- Navigasyon -->
      <ul class="nav-links">
        <li class="nav-item"><a href="insert.jsp" class="nav-link"><i class="fas fa-home"></i><span>Home</span></a></li>

        <li class="nav-item dropdown">
          <a href="#" class="nav-link"><i class="fas fa-project-diagram"></i><span>Projects</span><i class="fas fa-chevron-down" style="margin-left:5px;font-size:12px;"></i></a>
          <div class="dropdown-menu">
            <a href="project.jsp" class="dropdown-item">Project List</a>
            <a href="report.jsp" class="dropdown-item">Project Reports</a>
          </div>
        </li>

        <li class="nav-item"><a href="upload.jsp" class="nav-link"><i class="fas fa-upload"></i><span>Upload</span></a></li>
        <li class="nav-item"><a href="FAQs.jsp" class="nav-link"><i class="fas fa-question-circle"></i><span>FAQs</span></a></li>

        <li class="nav-item dropdown">
          <div class="user-profile nav-link">
            <div class="user-avatar"><%= user != null ? user.charAt(0) : 'U' %></div><span>Account</span><i class="fas fa-chevron-down" style="margin-left:5px;font-size:12px;"></i>
          </div>
          <div class="dropdown-menu">
            <a href="LogoutServlet" class="dropdown-item"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
          </div>
        </li>
      </ul>
    </div>
  </div>
</header>

<!-- ——— İÇERİK ——— -->
<div id="getting-started-container">
  <div class="project-count">Toplam Proje Sayısı: <%= totalProjects %></div>
  <table id="projects-table">
    <thead>
      <tr>
        <th>Proje Konusu</th><th>Yüklenen Zamanı</th><th>Ders Adı</th><th>Danışman Adı</th>
        <th>GitHub Link</th><th>Kütüphane Linki</th><th>Publish Durumu</th><th>Ödül Sayısı (1‑5)</th><th>İşlemler</th>
      </tr>
    </thead>
    <tbody id="projects-body">
      <% for(Project p : projectList){
           String zamanStr = p.getUploadStartDate()+" / "+p.getUploadEndDate(); %>
      <tr>
        <td><%=p.getProjectTopic()%></td>
        <td><%=zamanStr%></td>
        <td><%=p.getCourseName()%></td>
        <td><%=p.getAdvisorName()%></td>
        <td><a href="<%=p.getGithubLink()%>" target="_blank">GitHub Link</a></td>
        <td><a href="<%=p.getLibraryLink()%>" target="_blank"><%=p.getLibraryLink()%></a></td>
        <td><%=p.getProjectPublished().equalsIgnoreCase("yes")?"Evet":"Hayır"%></td>
        <td><%=p.getProjectAwards()%></td>
        <td>
          <form action="ProjectDetailServlet" method="get" style="margin:0;">
            <input type="hidden" name="projectTopic" value="<%=p.getProjectTopic()%>">
            <button type="submit" class="btn btn-info">Detay Göster</button>
          </form>
        </td>
      </tr>
      <% } %>
    </tbody>
  </table>
</div>

<footer><p>&copy; 2025 ProjectHub. All rights reserved.</p></footer>

<!-- ——— JAVASCRIPT ——— -->
<script>
/* Mobil menü */
document.getElementById('mobileMenuBtn').addEventListener('click',()=>document.getElementById('navContainer').classList.toggle('active'));

/* Danışman araması */
document.getElementById('advisor-search-button').addEventListener('click',function(){
  const term=document.getElementById('advisor-search-input').value.trim();
  if(!term) return;
  fetch('ProjectAdvisorSearchServlet?term='+encodeURIComponent(term))
    .then(r=>r.json())
    .then(d=>renderRows(d,true))
    .catch(()=>projectsBody.innerHTML='<tr><td colspan="9" style="text-align:center;color:red;">Error occurred!</td></tr>');
});
document.getElementById('advisor-search-input').addEventListener('keypress',e=>{
  if(e.key==='Enter') document.getElementById('advisor-search-button').click();
});

/* Proje araması */
const searchButton=document.getElementById('search-button'),
      searchInput=document.getElementById('search-input'),
      projectsBody=document.getElementById('projects-body');
searchButton.addEventListener('click',()=>{
  const term=searchInput.value.trim();
  if(!term) return;
  fetch('ProjectSearchResultsServlet?term='+encodeURIComponent(term))
    .then(r=>r.json())
    .then(d=>renderRows(d,false))
    .catch(()=>projectsBody.innerHTML='<tr><td colspan="9" style="text-align:center;color:red;">Hata oluştu!</td></tr>');
});

/* Sonuçları tabloya ekle — template literal YOK! */
function renderRows(data,isAdvisor){
  projectsBody.innerHTML='';
  if(data.length){
    data.forEach(function(p){
      var row =
        '<tr>'+
          '<td>'+(p.projectTopic || '')+'</td>'+
          '<td>'+ (p.uploadStartDate || '')+' / '+(p.uploadEndDate || '') +'</td>'+
          '<td>'+(p.courseName || '')+'</td>'+
          '<td>'+(p.advisorName || '')+'</td>'+
          '<td><a href="'+(p.githubLink || '#')+'" target="_blank">GitHub Link</a></td>'+
          '<td><a href="'+(p.libraryLink || '#')+'" target="_blank">'+(p.libraryLink || '')+'</a></td>'+
          '<td>'+ ( (p.projectPublished && p.projectPublished.toLowerCase()==='yes') ? 'Evet' : 'Hayır' ) +'</td>'+
          '<td>'+(p.projectAwards || '')+'</td>'+
          '<td>'+
            '<form action="ProjectDetailServlet" method="get" style="margin:0;">'+
              '<input type="hidden" name="projectTopic" value="'+(p.projectTopic || '')+'">'+
              '<button type="submit" class="btn btn-info">Detay Göster</button>'+
            '</form>'+
          '</td>'+
        '</tr>';
      projectsBody.insertAdjacentHTML('beforeend',row);
    });
  }else{
    var msg=isAdvisor?'No records found for this advisor!':'Kayıt bulunamadı!';
    projectsBody.innerHTML='<tr><td colspan="9" style="text-align:center;">'+msg+'</td></tr>';
  }
}

/* Dil tercihi */
document.addEventListener('DOMContentLoaded',()=>{
  var lang=localStorage.getItem('language')||'en';
  changeLanguage(lang);
});
function changeLanguage(lang){
  document.querySelectorAll('[data-lang]').forEach(function(el){
    el.style.display=(el.getAttribute('data-lang')===lang)?'block':'none';
  });
}
</script>
</body>
</html>
