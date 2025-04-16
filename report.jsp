<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, project.Project, project.ProjectDAO" %>
<%
    // Oturum kontrolü
    String user = (String) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("index2.jsp?error=loginfirst&return=report.jsp");
        return;
    }
    
    // DAO üzerinden gerekli verileri çekiyoruz:
    ProjectDAO dao = new ProjectDAO();
    int totalProjects = dao.getTotalProjectCount();
    Map<String, Integer> statusCounts = dao.getProjectCountByStatus();
    Map<String, Integer> advisorCounts = dao.getProjectCountByAdvisor();
    List<Project> recentProjects = dao.getRecentProjects(5);

    // Yayınlanan-yayınlanmayan dağılımı
    int publishedCount   = statusCounts.getOrDefault("yes", 0);
    int unpublishedCount = statusCounts.getOrDefault("no", 0);
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Proje Raporları - Your Platform Name</title>
  
  <!-- Chart.js CDN -->
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  
  <style>
    /* Genel alanlar (Project.jsp ile uyumlu) */
    body {
      font-family: Arial, sans-serif;
      background-color: #f2f2f2;
      padding: 20px;
      margin: 0;
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
    /* Logo veya diğer öğeler */
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
    /* Dropdown CSS (sadece Projects ve SIGN UP OR SIGN IN için) */
    .dropdown {
      position: relative;
      display: inline-block;
    }
    .dropbtn {
      color: #fff;
      background-color: transparent;
      border: none;
      cursor: pointer;
      font-size: 16px;
      padding: 0;
    }
    .dropdown-content {
      display: none;
      position: absolute;
      background-color: #343a40;
      min-width: 160px;
      box-shadow: 0 8px 16px rgba(0,0,0,0.2);
      z-index: 9999;
    }
    /* Dropdown içeriğindeki bağlantıların ve h4 etiketlerinin yazı boyutu küçültüldü */
    .dropdown-content a, 
    .dropdown-content h4 {
      color: #fff;
      padding: 8px 12px;
      text-decoration: none;
      display: block;
      transition: background-color 0.3s;
      margin: 0;
      font-size: 14px; /* Küçültülmüş font boyutu */
    }
    .dropdown-content a:hover,
    .dropdown-content h4:hover {
      background-color: #95c11e;
      color: #000;
    }
    .dropdown:hover .dropdown-content {
      display: block;
    }
    /* Rapor Kapsayıcısı */
    .report-container {
      max-width: 1200px;
      margin: 20px auto;
      background-color: #fff;
      border-radius: 6px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
      padding: 20px;
    }
    /* Grafik kapsayıcıları (dairesel grafikler) */
    .charts-container {
      display: flex;
      flex-wrap: wrap;
      gap: 30px;
      justify-content: center;
      margin-bottom: 30px;
    }
    .chart-card {
      width: 250px;
      text-align: center;
    }
    .chart-card canvas {
      max-width: 100%;
      height: auto;
    }
    
    /* Stat Card ve stat grid (isteğe bağlı) */
    .stat-card {
      background-color: #4caf50;
      color: white;
      padding: 15px;
      border-radius: 6px;
      margin-bottom: 20px;
      text-align: center;
    }
    .stat-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
      gap: 15px;
      margin-bottom: 30px;
    }
    .advisor-list {
      margin-top: 20px;
    }
    .advisor-item {
      display: flex;
      justify-content: space-between;
      padding: 10px;
      border-bottom: 1px solid #eee;
    }
    /* Tablo */
    table {
      width: 100%;
      border-collapse: collapse;
      table-layout: auto;
      margin-top: 20px;
    }
    table th,
    table td {
      border: 1px solid #ddd;
      padding: 10px 12px;
      text-align: left;
      min-width: 80px;
    }
    table th {
      background-color: #4caf50;
      color: white;
      position: sticky;
      top: 0;
    }
    table tr:nth-child(even) {
      background-color: #f9f9f9;
    }
    table tr:hover {
      background-color: #f1f1f1;
    }
    
    /* Footer */
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
  <!-- HEADER -->
  <header>
    <h1>Proje Raporları</h1>
    <nav>
      <a href="insert.jsp">HOME</a>
      <!-- Projects dropdown -->
      <div class="dropdown">
        <a class="dropbtn">
          <h4 data-lang="en">Projects</h4>
          <h4 data-lang="tr" style="display: none;">Projeler</h4>
        </a>
        <div class="dropdown-content">
          <a href="project.jsp">Project List</a>
          <a href="report.jsp">Project Reports</a>
        </div>
      </div>
      <a href="upload.jsp">UPLOAD</a>
      <a href="FAQs.jsp">FAQs</a>
      
      <!-- SIGN UP OR SIGN IN dropdown: üzerine gelince LOGOUT görünsün -->
      <div class="dropdown">
        <a class="dropbtn">SIGN UP OR SIGN IN</a>
        <div class="dropdown-content">
          <a href="LogoutServlet">
            <h4 data-lang="en">LOGOUT</h4>
            <h4 data-lang="tr" style="display: none;">ÇIKIŞ</h4>
          </a>
        </div>
      </div>
    </nav>
  </header>
  
  <!-- ANA RAPOR KAPSAYICISI -->
  <div class="report-container">
    <div class="charts-container">
      <!-- Toplam Proje -->
      <div class="chart-card">
        <canvas id="chartTotal"></canvas>
        <h3>Toplam Proje</h3>
      </div>
      <!-- Yayınlanan -->
      <div class="chart-card">
        <canvas id="chartPublished"></canvas>
        <h3>Yayınlanan Proje</h3>
      </div>
      <!-- Yayınlanmayan -->
      <div class="chart-card">
        <canvas id="chartUnpublished"></canvas>
        <h3>Yayınlanmayan Proje</h3>
      </div>
    </div>
    
    <hr>
    
    <!-- Sayısal Bilgiler -->
    <p><strong>Toplam Proje Sayısı:</strong> <%= totalProjects %></p>
    <p><strong>Yayınlanan Proje Sayısı:</strong> <%= publishedCount %></p>
    <p><strong>Yayınlanmayan Proje Sayısı:</strong> <%= unpublishedCount %></p>
    
    <h2 style="margin-top:30px;">Danışmanlara Göre Proje Dağılımı</h2>
    <div class="advisor-list">
      <% for (Map.Entry<String, Integer> entry : advisorCounts.entrySet()) { %>
        <div class="advisor-item">
          <span><%= entry.getKey() %></span>
          <span><%= entry.getValue() %> proje</span>
        </div>
      <% } %>
    </div>
    
    <h2 style="margin-top:30px;">Son Eklenen 5 Proje</h2>
    <table>
      <thead>
        <tr>
          <th>Proje Adı</th>
          <th>Eklenme Tarihi</th>
          <th>Danışman</th>
        </tr>
      </thead>
      <tbody>
        <% for (Project p : recentProjects) { %>
          <tr>
            <td><%= p.getProjectTopic() %></td>
            <td><%= p.getUploadStartDate() %></td>
            <td><%= p.getAdvisorName() %></td>
          </tr>
        <% } %>
      </tbody>
    </table>
  </div>
  
  <footer>
    <p>&copy; 2025 Your Platform Name. All rights reserved.</p>
  </footer>
      
  <!-- Chart.js Doughnut Grafik Kodları -->
  <script>
    // JSP'den gelen verileri JS değişkenlerine atıyoruz
    const totalProjects    = <%= totalProjects %>;
    const publishedCount   = <%= publishedCount %>;
    const unpublishedCount = <%= unpublishedCount %>;
    
    // Chart: Toplam Proje
    const ctxTotal = document.getElementById('chartTotal').getContext('2d');
    new Chart(ctxTotal, {
      type: 'doughnut',
      data: {
        labels: ['Proje'],
        datasets: [{
          label: 'Toplam Proje',
          data: [totalProjects],
          backgroundColor: ['#4caf50'],
          hoverBackgroundColor: ['#66bb6a']
        }]
      },
      options: {
        responsive: true,
        cutout: '70%',
        plugins: {
          tooltip: { enabled: false },
          legend:  { display: false },
          title: {
            display: true,
            text: totalProjects + ' Adet',
            color: '#333',
            font: { size: 18 }
          }
        }
      }
    });

    // Chart: Yayınlanan Proje
    const ctxPublished = document.getElementById('chartPublished').getContext('2d');
    new Chart(ctxPublished, {
      type: 'doughnut',
      data: {
        labels: ['Yayınlanan'],
        datasets: [{
          label: 'Yayınlanan Proje',
          data: [publishedCount],
          backgroundColor: ['#007bff'],
          hoverBackgroundColor: ['#3399ff']
        }]
      },
      options: {
        responsive: true,
        cutout: '70%',
        plugins: {
          tooltip: { enabled: false },
          legend:  { display: false },
          title: {
            display: true,
            text: publishedCount + ' Adet',
            color: '#333',
            font: { size: 18 }
          }
        }
      }
    });

    // Chart: Yayınlanmayan Proje
    const ctxUnpublished = document.getElementById('chartUnpublished').getContext('2d');
    new Chart(ctxUnpublished, {
      type: 'doughnut',
      data: {
        labels: ['Yayınlanmayan'],
        datasets: [{
          label: 'Yayınlanmayan Proje',
          data: [unpublishedCount],
          backgroundColor: ['#e91e63'],
          hoverBackgroundColor: ['#ec407a']
        }]
      },
      options: {
        responsive: true,
        cutout: '70%',
        plugins: {
          tooltip: { enabled: false },
          legend:  { display: false },
          title: {
            display: true,
            text: unpublishedCount + ' Adet',
            color: '#333',
            font: { size: 18 }
          }
        }
      }
    });
  </script>
</body>
</html>
