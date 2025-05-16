<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="java.util.*, java.net.URLEncoder,
                 project.Project, project.ProjectDAO" %>
<%
    /* ---------- Oturum ---------- */
    String user = (String) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("index2.jsp?error=loginfirst&return=report.jsp");
        return;
    }

    /* ---------- Veriler ---------- */
    ProjectDAO dao = new ProjectDAO();
    int  totalProjects  = dao.getTotalProjectCount();
    Map<String,Integer> statusCounts   = dao.getProjectCountByStatus();   // yes / no
    Map<String,Integer> advisorCounts  = dao.getProjectCountByAdvisor();  // danışman → adet
    List<Project> recentProjects       = dao.getRecentProjects(5);

    int publishedCount   = statusCounts.getOrDefault("yes",0);
    int unpublishedCount = statusCounts.getOrDefault("no",0);

    /* --- Konulara göre yayın / yayın dışı sayıları --- */
    Map<String,int[]> topicMap = new LinkedHashMap<>();
    for(Project p : dao.getAllProjects()){
        String t = p.getProjectTopic();
        topicMap.putIfAbsent(t,new int[2]);
        if("yes".equalsIgnoreCase(p.getProjectPublished()))
             topicMap.get(t)[0]++;   // yayınlanan
        else topicMap.get(t)[1]++;    // yayınlanmayan
    }
    StringBuilder lblSB = new StringBuilder("[");
    StringBuilder pubSB = new StringBuilder("[");
    StringBuilder unSB  = new StringBuilder("[");
    for(Iterator<Map.Entry<String,int[]>> it = topicMap.entrySet().iterator(); it.hasNext(); ){
        Map.Entry<String,int[]> e = it.next();
        lblSB.append("\"").append(e.getKey().replace("\"","\\\"")).append("\"");
        pubSB.append(e.getValue()[0]);
        unSB .append(e.getValue()[1]);
        if(it.hasNext()){ lblSB.append(","); pubSB.append(","); unSB.append(","); }
    }
    lblSB.append("]"); pubSB.append("]"); unSB.append("]");

    /* --- Seçili danışman (parametreden) --- */
    String selAdvisor = request.getParameter("advisor"); // null | danışman adı
    List<Project> advisorProjects = Collections.emptyList();
    if(selAdvisor != null && !selAdvisor.isBlank()){
        advisorProjects = dao.searchProjectsByAdvisor(selAdvisor);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Proje Raporları - ProjectHub</title>
<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
  body{font-family:'Segoe UI',Tahoma,Verdana,sans-serif;background:#f8f9fa;margin:0;color:#333;}
  /* --- HEADER --- */
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

  /* --- RAPOR ALANI --- */
  .report-container{max-width:1200px;margin:20px auto;background:#fff;border-radius:6px;box-shadow:0 0 10px rgba(0,0,0,.1);padding:20px;}
  .stats-container{display:flex;justify-content:space-around;flex-wrap:wrap;margin:20px 0;}
  .stat-card{background:#fff;border-radius:8px;padding:20px;margin:10px;text-align:center;box-shadow:0 4px 6px rgba(0,0,0,.1);width:200px;}
  .stat-value{font-size:2.5rem;font-weight:bold;margin:10px 0;}
  .stat-label{color:#666;font-size:1rem;}

  .charts-container{display:flex;flex-wrap:wrap;gap:30px;justify-content:center;margin-bottom:30px;}
  .chart-card{width:290px;text-align:center;} .chart-card canvas{max-width:100%;height:auto;}
  .chart-card.big{width:600px;}  /* bar grafiğini büyüttü */

  .advisor-list{margin-top:20px;}
  .advisor-item{display:flex;justify-content:space-between;padding:10px;border-bottom:1px solid #eee;color:inherit;text-decoration:none;}
  .advisor-item:hover{background:#f1f1f1;}

  table{width:100%;border-collapse:collapse;table-layout:auto;margin-top:20px;}
  table th,table td{border:1px solid #ddd;padding:10px 12px;text-align:left;min-width:80px;}
  table th{background:#4caf50;color:#fff;position:sticky;top:0;}
  table tr:nth-child(even){background:#f9f9f9;} table tr:hover{background:#f1f1f1;}

  footer{background:#343a40;padding:4px 8px;text-align:center;position:fixed;bottom:0;width:100%;color:#fff;font-size:14px;}
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
            <a href="project.jsp" class="dropdown-item">Project List</a>
            <a href="report.jsp"  class="dropdown-item">Project Reports</a>
          </div>
        </li>
        <li class="nav-item"><a href="upload.jsp" class="nav-link"><i class="fas fa-upload"></i><span>Upload</span></a></li>
        <li class="nav-item"><a href="FAQs.jsp" class="nav-link"><i class="fas fa-question-circle"></i><span>FAQs</span></a></li>
        <li class="nav-item dropdown">
          <div class="user-profile nav-link">
            <div class="user-avatar"><%= user!=null ? user.charAt(0) : 'U' %></div><span>Account</span><i class="fas fa-chevron-down" style="margin-left:5px;font-size:12px;"></i>
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

  <!-- İstatistik kartları -->
  <div class="stats-container">
    <div class="stat-card"><div class="stat-value"><%= totalProjects %></div><div class="stat-label">Toplam Proje</div></div>
    <div class="stat-card"><div class="stat-value"><%= publishedCount %></div><div class="stat-label">Yayınlanan</div></div>
    <div class="stat-card"><div class="stat-value"><%= unpublishedCount %></div><div class="stat-label">Yayınlanmayan</div></div>
    <div class="stat-card"><div class="stat-value"><%= advisorCounts.size() %></div><div class="stat-label">Danışman</div></div>
  </div>

  <!-- Grafikler -->
  <div class="charts-container">
    <!-- Yayın durumu donut -->
    <div class="chart-card"><canvas id="chartPub"></canvas><h3>Yayın Durumu</h3></div>

    <!-- Konu bazlı yığılmış bar (büyük) -->
    <div class="chart-card big"><canvas id="chartTopic"></canvas><h3>Konuya Göre Yayın Dağılımı</h3></div>
  </div>

  <hr>

  <h2 style="margin-top:30px;">Danışmanlara Göre Proje Dağılımı</h2>
  <div class="advisor-list">
    <% for(Map.Entry<String,Integer> e : advisorCounts.entrySet()){
         String adv = e.getKey();
         String url = "report.jsp?advisor=" + URLEncoder.encode(adv,"UTF-8"); %>
      <a href="<%= url %>" class="advisor-item">
        <span><%= adv %></span><span><%= e.getValue() %> proje</span>
      </a>
    <% } %>
  </div>

  <% if(selAdvisor != null && !selAdvisor.isBlank()){ %>
    <h2 style="margin:35px 0 10px">
      <a href="report.jsp" style="text-decoration:none;margin-right:8px;">&#8592;</a>
      <%= selAdvisor %> danışmanının projeleri
    </h2>

    <% if(advisorProjects.isEmpty()){ %>
       <p style="color:#888">Bu danışmana ait proje bulunamadı.</p>
    <% } else { %>
      <table>
        <thead><tr><th>Proje Konu</th><th>Ders</th><th>Yayın</th><th>Başlangıç</th><th>Bitiş</th></tr></thead>
        <tbody>
          <% for(Project p : advisorProjects){ %>
            <tr>
              <td><%= p.getProjectTopic() %></td>
              <td><%= p.getCourseName()   %></td>
              <td><%= "yes".equalsIgnoreCase(p.getProjectPublished())?"Yayınlandı":"Beklemede" %></td>
              <td><%= p.getUploadStartDate() %></td>
              <td><%= p.getUploadEndDate()   %></td>
            </tr>
          <% } %>
        </tbody>
      </table>
    <% } %>
  <% } %>

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

<!-- JS -->
<script>
/* mobil menü */
document.getElementById('mobileMenuBtn')
        .addEventListener('click',()=>document.getElementById('navContainer').classList.toggle('active'));

/* 1) donut – yayın durumu */
new Chart(document.getElementById('chartPub'),{
  type:'doughnut',
  data:{
    labels:['Yayınlanan','Yayınlanmayan'],
    datasets:[{data:[<%= publishedCount %>,<%= unpublishedCount %>],
               backgroundColor:['#0d6efd','#e91e63']}]
  },
  options:{responsive:true,cutout:'65%',
           plugins:{legend:{position:'bottom'}}}
});

/* 2) yığılmış bar – konu bazlı yayın durumu */
new Chart(document.getElementById('chartTopic'),{
  type:'bar',
  data:{
    labels:<%= lblSB %>,
    datasets:[
      {label:'Yayınlanan',data:<%= pubSB %>,backgroundColor:'#0d6efd'},
      {label:'Yayınlanmayan',data:<%= unSB %>,backgroundColor:'#e91e63'}
    ]
  },
  options:{
    responsive:true,
    plugins:{legend:{position:'bottom'}},
    scales:{x:{stacked:true},
            y:{stacked:true,beginAtZero:true}}
  }
});
</script>
</body>
</html>
