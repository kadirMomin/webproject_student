<%@ page contentType="text/html; charset=UTF-8" language="java"
         import="java.util.*, course.Course, course.CourseDAO,
                 advisor.Advisor, advisor.AdvisorDAO" %>
<%
    /* ---------- oturum kontrolü ---------- */
    String user = (String) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("index2.jsp?error=loginfirst&return=courses.jsp");
        return;
    }

    /* ---------- verileri çek ---------- */
    List<Course>  courseList  = new CourseDAO().getAllCourses(user);
    List<Advisor> advisorList = new AdvisorDAO().getAllAdvisors();

    /* ---------- basit sayaçlar ---------- */
    int toplamProjeler   = 5;   // gerçek ProjectDAO ile çekebilirsin
    int guncelProjeler   = 3;
    int benimProjelerim  = 2;
    int bitenProjelerim  = 1;
    int onaylananProjeler= 1;
    int onayBekleyenProj = 1;
    int aldigimDers      = courseList.size();
    int toplamDers       = courseList.size(); /* tüm ders sayısı aynı listeden */
%>

<!DOCTYPE html>
<html lang="tr">
<head>
  <meta charset="UTF-8">
  <title>Ders İşlemleri - ProjectHub</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <style>
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: #f8f9fa;
      margin: 0;
      color: #333;
    }
    
    /* Header */
    .header {
      background: #2c3e50;
      padding: 15px 30px;
      box-shadow: 0 2px 10px rgba(0,0,0,.1);
      position: sticky;
      top: 0;
      z-index: 1000;
    }
    
    .brand {
      color: #fff;
      font-size: 1.5rem;
      font-weight: 600;
      text-decoration: none;
      display: flex;
      align-items: center;
    }
    
    .logo {
      width: 40px;
      height: 40px;
      margin-right: 10px;
    }
    
    /* Genel kutu */
    .card {
      background: #fff;
      border: 1px solid #dee2e6;
      border-radius: 6px;
      padding: 20px;
      margin-bottom: 25px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }
    
    /* Layout */
    .container-flex {
      display: flex;
      gap: 20px;
      max-width: 1200px;
      margin: 20px auto;
      padding: 0 15px;
    }
    
    .sidebar {
      width: 250px;
    }
    
    .content {
      flex: 1;
    }
    
    /* Sol menü */
    .list-group {
      list-style: none;
      padding: 0;
      margin: 0;
    }
    
    .list-group li {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 12px 15px;
      border: 1px solid #ddd;
      border-left: 5px solid #6c757d;
      margin-bottom: 8px;
      background: #f8f9fa;
      border-radius: 4px;
      color: #333;
      transition: all 0.3s;
    }
    
    .list-group li:hover {
      background: #e9ecef;
      transform: translateX(5px);
    }
    
    .list-group li span.badge {
      display: inline-block;
      min-width: 24px;
      padding: 4px;
      background: #6c757d;
      color: #fff;
      border-radius: 50%;
      text-align: center;
      font-size: 12px;
    }
    
    /* İkon renkleri */
    .list-group li[data-color="primary"]  { border-left-color: #0d6efd }
    .list-group li[data-color="success"]  { border-left-color: #198754 }
    .list-group li[data-color="info"]     { border-left-color: #0dcaf0 }
    .list-group li[data-color="warning"]  { border-left-color: #ffc107 }
    .list-group li[data-color="danger"]   { border-left-color: #dc3545 }
    
    /* Dairesel sayaç */
    .circle-box {
      display: flex;
      justify-content: space-around;
      flex-wrap: wrap;
      gap: 15px;
    }
    
    .circle {
      width: 120px;
      height: 120px;
      border: 3px dashed #6c757d;
      border-radius: 50%;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      margin: 10px;
      transition: all 0.3s;
    }
    
    .circle:hover {
      transform: scale(1.05);
      border-color: #4caf50;
    }
    
    .circle strong {
      font-size: 24px;
      color: #2c3e50;
    }
    
    .circle span {
      font-size: 13px;
      text-align: center;
      color: #6c757d;
    }
    
    /* Tablolar */
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 15px;
    }
    
    th, td {
      border: 1px solid #dee2e6;
      padding: 12px;
      text-align: left;
      font-size: 14px;
    }
    
    th {
      background: #4caf50;
      color: #fff;
      font-weight: 600;
      position: sticky;
      top: 0;
    }
    
    tr:nth-child(even) {
      background-color: #f2f2f2;
    }
    
    tr:hover {
      background-color: #e9e9e9;
    }
    
    /* Butonlar */
    .btn {
      padding: 6px 12px;
      font-size: 14px;
      border-radius: 4px;
      color: #fff;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      margin-right: 5px;
      border: none;
      cursor: pointer;
      transition: background-color 0.3s;
    }
    
    .btn i {
      margin-right: 5px;
    }
    
    .btn-select {
      background: #17a2b8;
    }
    
    .btn-select:hover {
      background: #138496;
    }
    
    .btn-delete {
      background: #dc3545;
    }
    
    .btn-delete:hover {
      background: #c82333;
    }
    
    .btn-issue {
      background: #ff9800;
    }
    
    .btn-issue:hover {
      background: #e68a00;
    }
    
    .action-buttons {
      display: flex;
      gap: 5px;
    }
    
    /* Durum göstergeleri */
    .status-selected {
      color: #28a745;
      font-weight: bold;
    }
    
    .status-not-selected {
      color: #dc3545;
      font-weight: bold;
    }
    
    /* Başlıklar */
    h4 {
      color: #2c3e50;
      margin: 0 0 15px;
      padding-bottom: 10px;
      border-bottom: 2px solid #4caf50;
    }
    
    /* Footer */
    footer {
      background: #343a40;
      padding: 10px;
      text-align: center;
      color: #fff;
      font-size: 14px;
      margin-top: 20px;
    }
    
    @media(max-width: 900px) {
      .container-flex {
        flex-direction: column;
      }
      
      .sidebar {
        width: 100%;
      }
      
      .circle {
        width: 100px;
        height: 100px;
      }
    }
  </style>
</head>
<body>

<!-- Header -->
<div class="header">
  <a href="insert.jsp" class="brand">
    <img class="logo" src="1.png" alt="Logo">
    ProjectHub
  </a>
</div>

<div class="container-flex">

  <!-- ========== SOL MENÜ ========== -->
  <aside class="sidebar">
    <div class="card">
      <h4>İstatistikler</h4>
      <ul class="list-group">
        <li data-color="danger">Toplam Proje Sayısı      <span class="badge"><%= toplamProjeler %></span></li>
        <li data-color="success">Güncel Projeler         <span class="badge"><%= guncelProjeler %></span></li>
        <li data-color="info">Benim Projelerim          <span class="badge"><%= benimProjelerim %></span></li>
        <li data-color="warning">Biten Projelerim       <span class="badge"><%= bitenProjelerim %></span></li>
        <li data-color="primary">Onaylanan Projelerim   <span class="badge"><%= onaylananProjeler %></span></li>
        <li data-color="primary">Onay Bekleyen Projeler <span class="badge"><%= onayBekleyenProj %></span></li>
        <li data-color="info">Aldığım Ders Sayısı      <span class="badge"><%= aldigimDers %></span></li>
        <li data-color="success">Toplam Ders Sayısı     <span class="badge"><%= toplamDers %></span></li>
      </ul>
    </div>
  </aside>

  <!-- ========== ANA İÇERİK ========== -->
  <section class="content">

    <!-- Sistem İstatistikleri -->
    <div class="card">
      <h4>Sistem İstatistikleri</h4>
      <div class="circle-box">
        <div class="circle"><strong>5</strong><span>Sistemdeki <br>Toplam Proje Sayısı</span></div>
        <div class="circle"><strong>3</strong><span>Sistemdeki <br>Güncel Projeler</span></div>
        <div class="circle"><strong>2</strong><span>Sistemdeki <br>Yüklenen Proje Sayısı</span></div>
        <div class="circle"><strong>1</strong><span>Onaylanan <br>Proje Sayısı</span></div>
      </div>
    </div>

    <!-- Teslim Ettiğim Son Proje -->
    <div class="card">
      <h4>Teslim Ettiğim Son Proje</h4>
      <table>
        <thead>
          <tr>
            <th>Proje Konusu</th>
            <th>Dersi</th>
            <th>Yükleme Zamanı</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>RehberSistemi</td>
            <td>İnternet Programlama 1</td>
            <td>2014-04-15 18:37:16</td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Ders Listesi -->
    <div class="card">
      <h4>Ders Listesi ve İşlemleri</h4>
      <table>
        <thead>
          <tr>
            <th>Ders No</th>
            <th>Ders Adı</th>
            <th>Ders Eğitmeni</th>
            <th>Toplam Seçim</th>
            <th>Durumum</th>
            <th>İşlemler</th>
          </tr>
        </thead>
        <tbody>
          <% for (Course c : courseList) { %>
          <tr>
            <td><%= c.getId() %></td>
            <td><%= c.getName() %></td>
            <td><%= c.getInstructor() %></td>
            <td><%= c.getTotalSelected() %></td>
            <td class="<%= c.isSelectedByUser() ? "status-selected" : "status-not-selected" %>">
              <%= c.isSelectedByUser() ? "✔ Seçildi" : "✘ Seçilmedi" %>
            </td>
            <td>
              <div class="action-buttons">
                <a href="CourseSelectServlet?id=<%= c.getId() %>" class="btn btn-select">
                  <i class="fas fa-check"></i> Seç
                </a>
                <a href="CourseDeleteServlet?id=<%= c.getId() %>" class="btn btn-delete">
                  <i class="fas fa-trash"></i> Sil
                </a>
                <a href="CourseIssueServlet?id=<%= c.getId() %>" class="btn btn-issue">
                  <i class="fas fa-exclamation-triangle"></i> Sorun
                </a>
              </div>
            </td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </div>

    <!-- Danışman Seçimi -->
    <div class="card">
      <h4>Danışman Seçimi</h4>
      <table>
        <thead>
          <tr>
            <th>Danışman No</th>
            <th>Danışman Adı</th>
            <th>İşlem</th>
          </tr>
        </thead>
        <tbody>
          <% for (Advisor a : advisorList) { %>
          <tr>
            <td><%= a.getId() %></td>
            <td><%= a.getName() %></td>
            <td>
              <a href="AdvisorSelectServlet?id=<%= a.getId() %>" class="btn btn-select">
                <i class="fas fa-check"></i> Seç
              </a>
            </td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </div>

  </section>
</div>

<footer>
  <p>&copy; 2025 ProjectHub. All rights reserved.</p>
</footer>

</body>
</html>