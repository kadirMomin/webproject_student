<%@ page contentType="text/html; charset=UTF-8" language="java"
         import="java.util.*, project.Project, project.ProjectDAO,
                 advisor.Advisor, advisor.AdvisorDAO,
                 course.CourseDAO" %>
<%-- ─────────  OTURUM  ───────── --%>
<%
String adminEmail = (String) session.getAttribute("admin");
if(adminEmail == null){          // yönetici oturumu yok
    response.sendRedirect("combined.jsp");
    return;
}

/* —— Hoş-geldiniz ismi —— */
String adminName = (String) session.getAttribute("adminName");
if (adminName == null) adminName = adminEmail; 
%>
 
<%-- ─────────  ÇIKIŞ İSTEĞİ  ───────── --%>
<%
if ("logout".equals(request.getParameter("do"))) {   // ← admin.jsp?do=logout
    session.invalidate();                           // 1) oturumu sil
    response.sendRedirect("insert.jsp");            // 2) anasayfaya dön
    return;                                         // 3) geri kalan kod çalışmaz
}
%>

<%-- ─────────  DAO’LAR  ───────── --%>
<%
ProjectDAO pDao = new ProjectDAO();
AdvisorDAO aDao = new AdvisorDAO();
CourseDAO  cDao = new CourseDAO();
%>

<%-- ─────────  PROJELER  ───────── --%>
<%
List<Project> all  = pDao.getAllProjects(),
              cur  = new ArrayList<>(), fin = new ArrayList<>(),
              appr = new ArrayList<>(), pend = new ArrayList<>();

for (Project p : all) {
    if ("yes".equalsIgnoreCase(p.getProjectPublished())) appr.add(p); else pend.add(p);
    if (p.getUploadEndDate().toLocalDate().isBefore(java.time.LocalDate.now()))
         fin.add(p); else cur.add(p);
}
int topProj = all.size(), curProj = cur.size(), uplProj = all.size(),
    appProj = appr.size(), penProj = pend.size();
%>

<%-- ─────────  SEÇİMLER  ───────── --%>
<%
List<CourseDAO.CourseSelection>   selCourses    = cDao.getAllSelections();
List<AdvisorDAO.AdvisorSelection> selAdvisors   = aDao.getAllSelections();
List<CourseDAO.PendingSel>        pendingCourse = cDao.getPendingSelections();   // yeni
%>

<%-- ─────────  GÖRÜNÜM  ───────── --%>
<%
String view = request.getParameter("view"); // null|current|…|pendingcourse
Map<String,Object> tbl = new HashMap<String,Object>(){{
    put("current"      , cur);
    put("upload"       , all);
    put("approved"     , appr);
    put("pending"      , pend);
    put("finished"     , fin);
    put("coursesel"    , selCourses);
    put("advisorsel"   , selAdvisors);
    put("pendingcourse", pendingCourse);    // derse onay listesi
}};
List<?> table = (List<?>) tbl.getOrDefault(view, Collections.emptyList());

String title =
      "current".equals(view)       ? "Güncel Projeler"
    : "upload".equals(view)        ? "Yüklenen Projeler"
    : "approved".equals(view)      ? "Onaylanan Projeler"
    : "pending".equals(view)       ? "Onay Bekleyen Projeler"
    : "finished".equals(view)      ? "Biten Projeler"
    : "coursesel".equals(view)     ? "Ders Seçimleri"
    : "advisorsel".equals(view)    ? "Danışman Seçimleri"
    : "pendingcourse".equals(view) ? "Ders Onayı"
    :                               "Gelen İleti Kutusu";
%>

<!DOCTYPE html>
<html lang="tr"><head>
<meta charset="UTF-8"><title>Yönetici Paneli</title>
<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style>
*{box-sizing:border-box}body{margin:0;font-family:Arial,Helvetica,sans-serif;background:#f0f2f4}
header{background:#2c3e50;color:#fff;padding:12px 30px;font-size:18px;font-weight:600}
.container{display:flex;max-width:1180px;margin:25px auto;gap:20px;padding:0 10px}
.sidebar{width:235px}.content{flex:1}
.card{background:#fff;border:1px solid #ddd;border-radius:6px;padding:18px;box-shadow:0 2px 4px rgba(0,0,0,.06)}
ul.menu{list-style:none;padding:0;margin:0}
ul.menu li{display:flex;justify-content:space-between;align-items:center;padding:11px 14px;border:1px solid #ddd;border-left:5px solid var(--c);background:#f8f9fa;margin-bottom:7px;border-radius:4px;font-size:14px;transition:.3s}
ul.menu li:hover{background:#e9ecef;transform:translateX(5px)}
ul.menu li a{color:inherit;text-decoration:none;flex:1;display:flex;justify-content:space-between}
.badge{background:#6c757d;color:#fff;border-radius:50%;padding:2px 7px;font-size:12px}
[data-c="dgr"]{--c:#dc3545}[data-c="suc"]{--c:#198754}[data-c="inf"]{--c:#0dcaf0}[data-c="prm"]{--c:#0d6efd}[data-c="wrn"]{--c:#ffc107}
table{width:100%;border-collapse:collapse;margin-top:10px}
th,td{border:1px solid #ddd;padding:9px 10px;font-size:13px;text-align:left}
th{background:#4caf50;color:#fff;position:sticky;top:0}
.btn{padding:4px 8px;border:none;border-radius:4px;color:#fff;font-size:12px;cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;gap:4px}
.btn-select{background:#17a2b8}.btn-delete{background:#dc3545}
@media(max-width:900px){.container{flex-direction:column}.sidebar{width:100%}}
header a.logout{float:right;color:#fff;text-decoration:none;font-size:14px;padding:4px 8px}
header a.logout:hover{text-decoration:underline}
.container{display:flex;max-width:1180px;margin:25px auto;gap:20px;padding:0 10px}
header span.welcome{margin-left:25px;font-size:15px;font-weight:400;}
</style>
</head>
<body>

<header>
    Yönetici Paneli
        <span class="welcome">Hoş geldiniz, <%= adminName %></span>
   <!-- ─────── ÇIKIŞ BUTONU ─────── -->
  <a href="admin.jsp?do=logout" class="logout">
      <i class="fas fa-sign-out-alt"></i> Çıkış
  </a>
</header>

<div class="container">

<!-- ─────────  MENÜ  ───────── -->
<aside class="sidebar">
 <ul class="menu">
  <li data-c="dgr">Toplam <span class="badge"><%=topProj%></span></li>
  <li data-c="suc"><a href="admin.jsp?view=current"><span>Güncel</span><span class="badge"><%=curProj%></span></a></li>
  <li data-c="inf"><a href="admin.jsp?view=upload"><span>Yüklenen</span><span class="badge"><%=uplProj%></span></a></li>
  <li data-c="prm"><a href="admin.jsp?view=approved"><span>Onaylanan</span><span class="badge"><%=appProj%></span></a></li>
  <li data-c="prm"><a href="admin.jsp?view=pending"><span>Onay Bekleyen</span><span class="badge"><%=penProj%></span></a></li>
  <li data-c="wrn"><a href="admin.jsp?view=finished"><span>Biten</span><span class="badge"><%=fin.size()%></span></a></li>
  <li data-c="suc"><a href="admin.jsp?view=coursesel"><span>Ders Seçimleri</span><span class="badge"><%=selCourses.size()%></span></a></li>
  <li data-c="inf"><a href="admin.jsp?view=advisorsel"><span>Danışman Seçimleri</span><span class="badge"><%=selAdvisors.size()%></span></a></li>
  <li data-c="inf"><a href="admin.jsp?view=pendingcourse"><span>Ders Onayı</span><span class="badge"><%=pendingCourse.size()%></span></a></li>
 </ul>
</aside>

<!-- ─────────  İÇERİK  ───────── -->
<section class="content"><div class="card">
<h4 style="margin:0 0 15px"><%=title%></h4>

<%-- ### DERS ONAYI GÖRÜNÜMÜ ### --%>
<% if ("pendingcourse".equals(view)) { %>
  <table>
    <tr><th>UserName</th><th>Ders</th><th>Eğitmen</th><th>İşlem</th></tr>
    <% for (course.CourseDAO.PendingSel ps : pendingCourse) { %>
      <tr>
        <td><%= ps.getUserName() %></td>
        <td><%= ps.getCourseName() %></td>
        <td><%= ps.getInstructor() %></td>
        <td>
           <a class="btn btn-select"
              href="CourseApproveServlet?id=<%=ps.getRecId()%>&act=ok"><i class="fas fa-check"></i>Onay</a>
           <a class="btn btn-delete"
              href="CourseApproveServlet?id=<%=ps.getRecId()%>&act=del"><i class="fas fa-times"></i>Sil</a>
        </td>
      </tr>
    <% } %>
    <% if (pendingCourse.isEmpty()) { %>
       <tr><td colspan="4" style="text-align:center">Bekleyen ders seçimi yok</td></tr>
    <% } %>
  </table>

<%-- ### DERS & DAN. LİSTELERİ ### --%>
<% } else if ("coursesel".equals(view)) { %>
  <table><tr><th>UserName</th><th>Ders</th><th>Eğitmen</th></tr>
    <% for (course.CourseDAO.CourseSelection c : selCourses) { %>
      <tr><td><%=c.getUserName()%></td><td><%=c.getCourseName()%></td><td><%=c.getInstructor()%></td></tr>
    <% } %>
    <% if (selCourses.isEmpty()) { %><tr><td colspan="3" style="text-align:center">Kayıt yok</td></tr><% } %>
  </table>

<% } else if ("advisorsel".equals(view)) { %>
  <table><tr><th>UserName</th><th>Danışman</th></tr>
    <% for (advisor.AdvisorDAO.AdvisorSelection a : selAdvisors) { %>
      <tr><td><%=a.getUserName()%></td><td><%=a.getAdvisorName()%></td></tr>
    <% } %>
    <% if (selAdvisors.isEmpty()) { %><tr><td colspan="2" style="text-align:center">Kayıt yok</td></tr><% } %>
  </table>

<%-- ### PROJE TABLOLARI ### --%>
<% } else if (!table.isEmpty() || view!=null) { %>
  <table>
   <tr>
     <th>Konu</th>
     <% if (!"pending".equals(view)) { %>
          <th>Ders</th><th>Danışman</th><th>Öğrenci</th>
     <% } %>
     <th>Durum</th>
     <% if ("pending".equals(view) || "approved".equals(view)) { %><th>İşlem</th><% } %>
   </tr>

   <% for (Project p : (List<Project>) table) { %>
     <tr>
       <td><%= p.getProjectTopic() %></td>
       <% if (!"pending".equals(view)) { %>
            <td><%= p.getCourseName()   %></td>
            <td><%= p.getAdvisorName()  %></td>
            <td><%= p.getUploaderName() %></td>
       <% } %>
       <td><%= "yes".equalsIgnoreCase(p.getProjectPublished())?"Onaylı":"Beklemede" %></td>

       <% if ("pending".equals(view)) { %>
         <td>
           <a class="btn btn-select" href="ProjectApproveServlet?id=<%=p.getId()%>">
               <i class="fas fa-check"></i>Onay</a>
           <a class="btn btn-delete" href="ProjectRejectServlet?id=<%=p.getId()%>&from=pending">
               <i class="fas fa-trash"></i>Sil</a>
         </td>
       <% } else if ("approved".equals(view)) { %>
         <td>
           <a class="btn btn-delete" href="ProjectRejectServlet?id=<%=p.getId()%>&from=approved">
               <i class="fas fa-times"></i>Kaldır</a>
         </td>
       <% } %>
     </tr>
   <% } %>

   <% if (table.isEmpty()) { %>
      <tr><td colspan="6" style="text-align:center">Kayıt yok</td></tr>
   <% } %>
  </table>

<%-- ### GİRİŞTE GELEN İLETİ  ### --%>
<% } else { %>
  <table><tr><th>İleti</th><th>Tarih</th><th>Durum</th></tr>
        <tr><td>Sistem açıldı</td><td>2025-03-18</td><td>✓</td></tr></table>
<% } %>

</div></section></div></body></html>
