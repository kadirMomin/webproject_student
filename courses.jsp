<%@ page contentType="text/html; charset=UTF-8" language="java"
         import="java.util.*, project.Project, project.ProjectDAO,
                 course.Course, course.CourseDAO,
                 advisor.Advisor, advisor.AdvisorDAO" %>
<%
/* ---------- oturum ---------- */
String user=(String)session.getAttribute("user");
if(user==null){
    response.sendRedirect("index2.jsp?error=loginfirst&return=courses.jsp");
    return;
}

/* ---------- DAO’lar --------- */
ProjectDAO pDao=new ProjectDAO();
CourseDAO  cDao=new CourseDAO();
AdvisorDAO aDao=new AdvisorDAO();

/* ---------- veriler ---------- */
List<Project> myAll = pDao.getProjectsByUserName(user);
List<Project> cur   = pDao.getUserCurrent  (user);
List<Project> fin   = pDao.getUserFinished (user);
List<Project> appr  = pDao.getUserApproved (user);
List<Project> pend  = pDao.getUserPending  (user);

int guncelProjeler   = cur .size();
int benimProjelerim  = myAll.size();
int bitenProjelerim  = fin .size();
int onaylananProjeler= appr.size();
int onayBekleyenProj = pend.size();

/* ---------- hangi tablo? ---------- */
String view = request.getParameter("view");
List<Project> tableData;
if      ("current".equals(view))  tableData = cur;
else if ("mine".equals(view))     tableData = myAll;
else if ("finished".equals(view)) tableData = fin;
else if ("approved".equals(view)) tableData = appr;
else if ("pending".equals(view))  tableData = pend;
else                              tableData = java.util.Collections.emptyList();  /* gelen ileti */

/* ---------- ders listesi + danışman filtresi ---------- */
List<Course>  courseList  = cDao.getAllCourses(user);
String adv = request.getParameter("advisor");        // ?advisor=…
if(adv!=null && !adv.isBlank())
    courseList.removeIf(c -> !c.getInstructor().equalsIgnoreCase(adv));

List<Advisor> advisorList = aDao.getAllAdvisors();
%>

<!DOCTYPE html>
<html lang="tr">
<head>
  <meta charset="UTF-8">
  <title>Ders İşlemleri - ProjectHub</title>
  <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

  <!-- —————  STİLLER ————— -->
  <style>
  body{font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif;background:#f8f9fa;margin:0;color:#333}
  /* header */
  .header{background:#2c3e50;padding:15px 30px;box-shadow:0 2px 10px rgba(0,0,0,.1);position:sticky;top:0;z-index:1000}
  .brand{color:#fff;font-size:1.5rem;font-weight:600;text-decoration:none;display:flex;align-items:center}
  .logo{width:40px;height:40px;margin-right:10px}
  /* kart & layout */
  .card{background:#fff;border:1px solid #dee2e6;border-radius:6px;padding:20px;margin-bottom:25px;box-shadow:0 2px 4px rgba(0,0,0,.05)}
  .container-flex{display:flex;gap:20px;max-width:1200px;margin:20px auto;padding:0 15px}
  .sidebar{width:250px}.content{flex:1}
  /* sol menü */
  .list-group{list-style:none;padding:0;margin:0}
  .list-group li{display:flex;justify-content:space-between;align-items:center;padding:12px 15px;border:1px solid #ddd;border-left:5px solid #6c757d;margin-bottom:8px;background:#f8f9fa;border-radius:4px;transition:.3s}
  .list-group li:hover{background:#e9ecef;transform:translateX(5px)}
  .list-group li a{color:inherit;text-decoration:none;flex:1;display:flex;justify-content:space-between}
  .badge{min-width:24px;padding:4px;background:#6c757d;color:#fff;border-radius:50%;font-size:12px;text-align:center}
  [data-color="success"] {border-left-color:#198754}[data-color="info"]{border-left-color:#0dcaf0}
  [data-color="primary"] {border-left-color:#0d6efd}[data-color="warning"]{border-left-color:#ffc107}
  /* tablolar */
  table{width:100%;border-collapse:collapse;margin-top:15px}
  th,td{border:1px solid #dee2e6;padding:12px;text-align:left;font-size:14px}
  th{background:#4caf50;color:#fff;position:sticky;top:0}
  tr:nth-child(even){background:#f2f2f2} tr:hover{background:#e9e9e9}
  /* butonlar */
  .btn{padding:6px 12px;border:none;border-radius:4px;color:#fff;font-size:14px;display:inline-flex;align-items:center;gap:5px;cursor:pointer;text-decoration:none}
  .btn-select{background:#17a2b8}.btn-select:hover{background:#138496}
  .btn-delete{background:#dc3545}.btn-delete:hover{background:#c82333}
  .btn-issue {background:#ff9800}.btn-issue:hover {background:#e68a00}
  /* durum */
  .status-selected{color:#28a745;font-weight:bold}.status-not-selected{color:#dc3545;font-weight:bold}
  /* responsive */
  @media(max-width:900px){.container-flex{flex-direction:column}.sidebar{width:100%}}
  </style>
</head>
<body>

<!-- ————— ÜST BAR ————— -->
<div class="header">
  <a href="insert.jsp" class="brand"><img src="1.png" class="logo" alt="logo">ProjectHub</a>
</div>

<div class="container-flex">

  <!-- ————— SOL MENÜ ————— -->
  <aside class="sidebar">
    <div class="card">
      <h4>İstatistikler</h4>
      <ul class="list-group">
        <li data-color="success"><a href="courses.jsp?view=current"><span>Güncel Projeler</span><span class="badge"><%= guncelProjeler %></span></a></li>
        <li data-color="info"><a href="courses.jsp?view=mine"><span>Yüklenen Projeler</span><span class="badge"><%= benimProjelerim %></span></a></li>
        <li data-color="primary"><a href="courses.jsp?view=approved"><span>Onaylanan Projeler</span><span class="badge"><%= onaylananProjeler %></span></a></li>
        <li data-color="primary"><a href="courses.jsp?view=pending"><span>Onay Bekleyen</span><span class="badge"><%= onayBekleyenProj %></span></a></li>
        <li data-color="warning"><a href="courses.jsp?view=finished"><span>Biten Projeler</span><span class="badge"><%= bitenProjelerim %></span></a></li>
      </ul>
    </div>
  </aside>

  <!-- ————— ANA İÇERİK ————— -->
  <section class="content">

    <!-- —— Ders Listesi —— -->
    <div class="card">
      <h4>Ders Listesi ve İşlemleri</h4>
      <table>
        <thead><tr><th>#</th><th>Ders Adı</th><th>Eğitmen</th><th>Seçim</th><th>Durumum</th><th>İşlemler</th></tr></thead>
        <tbody>
        <% for(Course c:courseList){ %>
          <tr>
            <td><%= c.getId() %></td>
            <td><%= c.getName() %></td>
            <td><%= c.getInstructor() %></td>
            <td><%= c.getTotalSelected() %></td>
            <td class="<%= c.isSelectedByUser()?"status-selected":"status-not-selected" %>">
                 <%= c.isSelectedByUser()?"✔ Seçildi":"✘ Seçilmedi" %></td>
            <td>
              <a class="btn btn-select" href="CourseSelectServlet?id=<%= c.getId() %>"><i class="fas fa-check"></i>Seç</a>
              <a class="btn btn-delete" href="CourseDeleteServlet?id=<%= c.getId() %>"><i class="fas fa-trash"></i>Sil</a>
              <a class="btn btn-issue"  href="CourseIssueServlet?id=<%= c.getId() %>"><i class="fas fa-exclamation-triangle"></i>Sorun</a>
            </td>
          </tr>
        <% } %>
        </tbody>
      </table>
    </div>

    <!-- —— Danışman Seçimi —— -->
    <div class="card">
      <h4>Danışman Seçimi</h4>
      <table>
        <thead><tr><th>#</th><th>Danışman</th><th>İşlem</th></tr></thead>
        <tbody>
        <% for(Advisor a:advisorList){ %>
          <tr>
            <td><%= a.getId() %></td>
            <td><%= a.getName() %></td>
            <td><a class="btn btn-select" href="AdvisorSelectServlet?id=<%= a.getId() %>"><i class="fas fa-check"></i>Seç</a></td>
          </tr>
        <% } %>
        </tbody>
      </table>
    </div>

  </section>
</div>

<footer style="text-align:center;margin:20px 0;color:#555">&copy; 2025 ProjectHub. All rights reserved.</footer>
</body>
</html>
