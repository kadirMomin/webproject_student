<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="java.util.*, project.Project, project.ProjectDAO" %>
<%
    // Oturum kontrolü
    String user = (String) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("index2.jsp?error=loginfirst&return=report.jsp");
        return;
    }

    ProjectDAO dao = new ProjectDAO();
    int totalProjects = dao.getTotalProjectCount();
    Map<String,Integer> statusCounts  = dao.getProjectCountByStatus();
    Map<String,Integer> advisorCounts = dao.getProjectCountByAdvisor();
    List<Project> recentProjects      = dao.getRecentProjects(5);

    int publishedCount   = statusCounts.getOrDefault("yes",0);
    int unpublishedCount = statusCounts.getOrDefault("no",0);
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Proje Raporları - ProjectHub</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

  <style>
    body{font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif;background:#f8f9fa;margin:0;color:#333;}

    /* HEADER (aramasız) */
    header{background:#2c3e50;padding:15px 30px;box-shadow:0 2px 10px rgba(0,0,0,.1);position:sticky;top:0;z-index:1000;}
      .header-container{display:flex;align-items:center;max-width:1400px;margin:0 auto;flex-wrap:wrap;width:100%;}
      .logo-container{display:flex;align-items:center;margin-right:30px;}
        #logo{width:40px;height:40px;margin-right:10px;}
        .brand{color:#fff;font-size:1.5rem;font-weight:600;text-decoration:none;}

      .nav-container{display:flex;align-items:center;flex-grow:1;justify-content:flex-end;flex-wrap:wrap;}
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
        .nav-links{flex-direction:column;align-items:stretch;}
        .nav-item{margin:5px 0;}
        .dropdown-menu{position:static;box-shadow:none;width:100%;display:none;}
        .dropdown:hover .dropdown-menu{display:block;}
        .mobile-menu-btn{display:block;position:absolute;right:20px;top:20px;}
      }

    /* RAPOR KAPSAYICISI */
    .report-container{max-width:1200px;margin:20px auto;background:#fff;border-radius:6px;box-shadow:0 0 10px rgba(0,0,0,.1);padding:20px;}
    .charts-container{display:flex;flex-wrap:wrap;gap:30px;justify-content:center;margin-bottom:30px;}
    .chart-card{width:250px;text-align:center;} .chart-card canvas{max-width:100%;height:auto;}

    .advisor-list{margin-top:20px;}
    .advisor-item{display:flex;justify-content:space-between;padding:10px;border-bottom:1px solid #eee;}

    table{width:100%;border-collapse:collapse;table-layout:auto;margin-top:20px;}
    table th,table td{border:1px solid #ddd;padding:10px 12px;text-align:left;min-width:80px;}
    table th{background:#4caf50;color:#fff;position:sticky;top:0;}
    table tr:nth-child(even){background:#f9f9f9;} table tr:hover{background:#f1f1f1;}

    footer{ background:#343a40; padding:4px 8px; text-align:center; position:fixed; bottom:0; width:100%; color:#fff; font-size:14px;}
  </style>
</head>

<body>
<!-- HEADER -->
<header>
  <div class="header-container">
    <div class="logo-container">
      <img id="logo" src="1.png" alt="Logo">
      <a href="insert.jsp" class="brand">ProjectHub</a>
    </div>

    <button class="mobile-menu-btn" id="mobileMenuBtn"><i class="fas fa-bars"></i></button>

    <div class="nav-container" id="navContainer">
      <ul class="nav-links">
        <li class="nav-item"><a href="insert.jsp" class="nav-link"><i class="fas fa-home"></i><span>Home</span></a></li>

        <li class="nav-item dropdown">
          <a href="#" class="nav-link"><i class="fas fa-project-diagram"></i><span>Projects</span><i class="fas fa-chevron-down" style="margin-left:5px;font-size:12px;"></i></a>
          <div class="dropdown-menu">
            <a href="project.jsp"  class="dropdown-item">Project List</a>
            <a href="report.jsp"   class="dropdown-item">Project Reports</a>
          </div>
        </li>

        <li class="nav-item"><a href="upload.jsp" class="nav-link"><i class="fas fa-upload"></i><span>Upload</span></a></li>
        <li class="nav-item"><a href="FAQs.jsp"   class="nav-link"><i class="fas fa-question-circle"></i><span>FAQs</span></a></li>

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

<!-- RAPORLAR -->
<div class="report-container">
  <div class="charts-container">
    <div class="chart-card"><canvas id="chartTotal"></canvas><h3>Toplam Proje</h3></div>
    <div class="chart-card"><canvas id="chartPublished"></canvas><h3>Yayınlanan Proje</h3></div>
    <div class="chart-card"><canvas id="chartUnpublished"></canvas><h3>Yayınlanmayan Proje</h3></div>
  </div>

  <hr>

  <p><strong>Toplam Proje Sayısı:</strong> <%= totalProjects %></p>
  <p><strong>Yayınlanan Proje Sayısı:</strong> <%= publishedCount %></p>
  <p><strong>Yayınlanmayan Proje Sayısı:</strong> <%= unpublishedCount %></p>

  <h2 style="margin-top:30px;">Danışmanlara Göre Proje Dağılımı</h2>
  <div class="advisor-list">
    <% for(Map.Entry<String,Integer> e : advisorCounts.entrySet()){ %>
      <div class="advisor-item"><span><%= e.getKey() %></span><span><%= e.getValue() %> proje</span></div>
    <% } %>
  </div>

  <h2 style="margin-top:30px;">Son Eklenen 5 Proje</h2>
  <table>
    <thead><tr><th>Proje Adı</th><th>Eklenme Tarihi</th><th>Danışman</th></tr></thead>
    <tbody>
      <% for(Project p : recentProjects){ %>
        <tr>
          <td><%= p.getProjectTopic() %></td>
          <td><%= p.getUploadStartDate() %></td>
          <td><%= p.getAdvisorName() %></td>
        </tr>
      <% } %>
    </tbody>
  </table>
</div>

  <!-- comment <footer><p>&copy; 2025 ProjectHub. All rights reserved.</p></footer>-->

<!-- JS -->
<script>
/* Mobil menü */
document.getElementById('mobileMenuBtn').addEventListener('click',()=>document.getElementById('navContainer').classList.toggle('active'));

/* Chart.js */
function donut(id,val,color,hover){
  var ctx=document.getElementById(id).getContext('2d');
  new Chart(ctx,{type:'doughnut',
    data:{labels:[''],datasets:[{data:[val],backgroundColor:[color],hoverBackgroundColor:[hover]}]},
    options:{responsive:true,cutout:'70%',plugins:{tooltip:{enabled:false},legend:{display:false},
      title:{display:true,text:val+' Adet',color:'#333',font:{size:18}}}}});
}
donut('chartTotal',<%= totalProjects %> ,'#4caf50','#66bb6a');
donut('chartPublished',<%= publishedCount %> ,'#007bff','#3399ff');
donut('chartUnpublished',<%= unpublishedCount %> ,'#e91e63','#ec407a');

/* Dil preference (eğer kullanıyorsanız) */
document.addEventListener('DOMContentLoaded',()=>{
  var lang=localStorage.getItem('language')||'en';
  document.querySelectorAll('[data-lang]').forEach(function(el){
    el.style.display=(el.getAttribute('data-lang')===lang)?'block':'none';
  });
});
</script>
</body>
</html>
