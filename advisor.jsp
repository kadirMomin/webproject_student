<%@ page contentType="text/html; charset=UTF-8" language="java"
         import="java.util.*, project.Project, project.ProjectDAO,
                 advisor.Advisor, advisor.AdvisorDAO" %>
<%
/* ---------- oturum ---------- */
String user = (String) session.getAttribute("user");
if(user == null){
    response.sendRedirect("index2.jsp?error=loginfirst&return=advisor.jsp");
    return;
}

/* ---------- hangi danışman? ----------
   - URL’de  advisor.jsp?id=3  şeklinde gönderiyoruz.
   - id yoksa kullanıcının seçtiği ilk danışmanı okuyoruz (yoksa hata). */
String idParam = request.getParameter("id");

AdvisorDAO aDao = new AdvisorDAO();
List<Advisor> advList = aDao.getAllAdvisors();

Advisor selAdvisor = null;
if(idParam != null && !idParam.isBlank()){
    int advId = Integer.parseInt(idParam);
    selAdvisor = advList.stream()
                        .filter(a -> a.getId() == advId)
                        .findFirst().orElse(null);
}
/* (zorunlu değil) – eğer id yoksa user_advisor tablosundan al:
   SELECT advisorId FROM user_advisor WHERE userName=? LIMIT 1            */
if(selAdvisor == null){
    out.println("<h3 style='color:red;text-align:center'>Danışman bulunamadı!</h3>");
    return;
}

/* ---------- projeler ---------- */
ProjectDAO pDao = new ProjectDAO();
List<Project> all = pDao.searchProjectsByAdvisor(selAdvisor.getName());

List<Project> cur  = new ArrayList<>();
List<Project> fin  = new ArrayList<>();
List<Project> appr = new ArrayList<>();
List<Project> pend = new ArrayList<>();

for(Project p : all){
    if("yes".equalsIgnoreCase(p.getProjectPublished())) appr.add(p); else pend.add(p);
    if(p.getUploadEndDate().toLocalDate().isBefore(java.time.LocalDate.now())) fin.add(p); else cur.add(p);
}

int topProj = all.size(), curProj = cur.size(), uplProj = all.size(),
    appProj = appr.size(), penProj = pend.size();

/* ---------- tablo seçimi ---------- */
String view = request.getParameter("view");          // current|upload|approved|pending|finished
List<Project> table;
if      ("current".equals(view))  table = cur;
else if ("upload".equals(view))   table = all;
else if ("approved".equals(view)) table = appr;
else if ("pending".equals(view))  table = pend;
else if ("finished".equals(view)) table = fin;
else                              table = all;      /* varsayılan tümü */

/* başlık */
String title;
if     ("current".equals(view))  title = "Güncel Projeler";
else if("approved".equals(view)) title = "Onaylanan Projeler";
else if("pending".equals(view))  title = "Onay Bekleyen Projeler";
else if("finished".equals(view)) title = "Biten Projeler";
else                             title = "Yüklenen Projeler";
%>
<!DOCTYPE html>
<html lang="tr">
<head>
<meta charset="UTF-8">
<title>Danışman Paneli – <%= selAdvisor.getName() %></title>
<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

<!-- ——— aynı CSS ——— -->
<style>
*{box-sizing:border-box}
body{margin:0;font-family:Arial,Helvetica,sans-serif;background:#f0f2f4;color:#333}
header{background:#2c3e50;color:#fff;padding:12px 30px;font-size:18px;font-weight:600}
.container{display:flex;max-width:1180px;margin:25px auto;gap:20px;padding:0 10px}
.sidebar{width:235px}.content{flex:1}
.card{background:#fff;border:1px solid #ddd;border-radius:6px;padding:18px;box-shadow:0 2px 4px rgba(0,0,0,.06)}
ul.menu{list-style:none;padding:0;margin:0}
ul.menu li{display:flex;justify-content:space-between;align-items:center;padding:11px 14px;
           border:1px solid #ddd;border-left:5px solid var(--c);background:#f8f9fa;
           margin-bottom:7px;border-radius:4px;font-size:14px;transition:.3s}
ul.menu li:hover{background:#e9ecef;transform:translateX(5px)}
ul.menu li a{color:inherit;text-decoration:none;flex:1;display:flex;justify-content:space-between}
.badge{background:#6c757d;color:#fff;border-radius:50%;padding:2px 7px;font-size:12px}
[data-c="dgr"]{--c:#dc3545}[data-c="suc"]{--c:#198754}
[data-c="inf"]{--c:#0dcaf0}[data-c="prm"]{--c:#0d6efd}
[data-c="wrn"]{--c:#ffc107}
table{width:100%;border-collapse:collapse;margin-top:10px}
th,td{border:1px solid #ddd;padding:9px 10px;font-size:13px;text-align:left}
th{background:#4caf50;color:#fff;position:sticky;top:0}
@media(max-width:900px){.container{flex-direction:column}.sidebar{width:100%}}
</style>
</head>
<body>

<header>Danışman Paneli – <%= selAdvisor.getName() %></header>

<div class="container">

  <!-- ———— Sol Menü ———— -->
  <aside class="sidebar">
    <ul class="menu">
      <li data-c="dgr">Toplam Proje <span class="badge"><%= topProj %></span></li>
      <li data-c="suc"><a href="advisor.jsp?id=<%= selAdvisor.getId() %>&view=current">
         <span>Güncel Projeler</span><span class="badge"><%= curProj %></span></a></li>
      <li data-c="inf"><a href="advisor.jsp?id=<%= selAdvisor.getId() %>&view=upload">
         <span>Yüklenen Projeler</span><span class="badge"><%= uplProj %></span></a></li>
      <li data-c="prm"><a href="advisor.jsp?id=<%= selAdvisor.getId() %>&view=approved">
         <span>Onaylanan Projeler</span><span class="badge"><%= appProj %></span></a></li>
      <li data-c="prm"><a href="advisor.jsp?id=<%= selAdvisor.getId() %>&view=pending">
         <span>Onay Bekleyen</span><span class="badge"><%= penProj %></span></a></li>
      <li data-c="wrn"><a href="advisor.jsp?id=<%= selAdvisor.getId() %>&view=finished">
         <span>Biten Projeler</span><span class="badge"><%= fin.size() %></span></a></li>
    </ul>
  </aside>

  <!-- ———— Sağ Alan ———— -->
  <section class="content">

    <div class="card">
      <h4 style="margin:0 0 15px"><%= title %></h4>

      <table>
        <tr><th>Konu</th><th>Ders</th><th>Bitiş</th><th>Durum</th></tr>
        <% for(Project p : table){ %>
          <tr>
            <td><%= p.getProjectTopic()   %></td>
            <td><%= p.getCourseName()     %></td>
            <td><%= p.getUploadEndDate() %></td>
            <td><%= p.getProjectPublished() %></td>
          </tr>
        <% } %>
        <% if(table.isEmpty()){ %>
          <tr><td colspan="4" style="text-align:center">Kayıt yok</td></tr>
        <% } %>
      </table>
    </div>

  </section>
</div>
</body>
</html>
