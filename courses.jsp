<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="java.util.*, project.Project, project.ProjectDAO,
                 course.Course,  course.CourseDAO,
                 advisor.Advisor, advisor.AdvisorDAO" %>
<%
/* —————————————————  OTURUM  ————————————————— */
String user = (String) session.getAttribute("user");
if (user == null){ response.sendRedirect("index2.jsp?error=loginfirst&return=courses.jsp"); return; }

/* —————————————————  DAO’LAR & SAYILAR  ————————————————— */
ProjectDAO pDao = new ProjectDAO();
CourseDAO  cDao = new CourseDAO();
AdvisorDAO aDao = new AdvisorDAO();

int guncelProjeler   = pDao.getUserCurrent(user).size();
int benimProjelerim  = pDao.getProjectsByUserName(user).size();
int onaylananProjeler= pDao.getUserApproved(user).size();
int onayBekleyenProj = pDao.getUserPending(user).size();

List<Course>  courseList  = cDao.getAllCourses(user);
List<Advisor> advisorList = aDao.getAllAdvisors();
List<Project> myProjects  = pDao.getProjectsByUserName(user);

/* —————————————————  DURUMLAR  ————————————————— */
boolean hasPendingCourse   = courseList.stream().anyMatch(Course::isSelectedByUser);   // bekleyen ders
boolean hasPendingAdvisor  = aDao.hasPendingAdvisor(user);                             // bekleyen danışman

/* Onaylı ders isimlerini topla (oturum kapatıldığında yeniden sıfırlanır) */
List<Integer> approvedIds   = cDao.getApprovedCourseIds(user);
List<String>  approvedNames = new ArrayList<>();
for(Course c : courseList)
    if(approvedIds.contains(c.getId())) approvedNames.add(c.getName());
boolean hasApprovedCourse = !approvedNames.isEmpty();
%>
<!DOCTYPE html>
<html lang="tr">
<head>
<meta charset="UTF-8">
<title>Ders İşlemleri – ProjectHub</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style>
/* ---------------- STİLLER (DEĞİŞMEDİ) ---------------- */
body{font-family:'Segoe UI',Tahoma,sans-serif;background:#f8f9fa;margin:0;color:#333}
header{background:#2c3e50;padding:15px 30px;box-shadow:0 2px 10px rgba(0,0,0,.1);position:sticky;top:0;z-index:1000}
.header-container{display:flex;align-items:center;max-width:1400px;margin:0 auto;flex-wrap:wrap;width:100%}
.logo-container{display:flex;align-items:center;margin-right:30px}#logo{width:40px;height:40px;margin-right:10px}
.brand{color:#fff;font-size:1.5rem;font-weight:600;text-decoration:none}
.nav-container{display:flex;align-items:center;flex-grow:1;justify-content:flex-start;flex-wrap:wrap}
.nav-links{display:flex;align-items:center;list-style:none;margin:0;padding:0}
.nav-item{margin-left:15px;position:relative}
.nav-link{color:#ecf0f1;text-decoration:none;padding:8px 12px;border-radius:4px;font-size:15px;font-weight:500;display:flex;align-items:center;transition:background .3s}
.nav-link:hover{background:rgba(255,255,255,.1);color:#fff}
.dropdown-menu{position:absolute;right:0;background:#fff;min-width:200px;box-shadow:0 8px 16px rgba(0,0,0,.1);border-radius:4px;padding:10px 0;display:none;z-index:1000}
.dropdown:hover .dropdown-menu{display:block}
.dropdown-item{display:block;padding:10px 20px;color:#333;text-decoration:none;transition:background .3s}
.dropdown-item:hover{background:#f8f9fa;color:#2c3e50}
.user-profile{display:flex;align-items:center;cursor:pointer}
.user-avatar{width:32px;height:32px;border-radius:50%;margin-right:8px;background:#3498db;color:#fff;display:flex;align-items:center;justify-content:center;font-weight:bold}
.mobile-menu-btn{display:none;background:none;border:none;color:#fff;font-size:20px;cursor:pointer}
@media(max-width:992px){
 .header-container{flex-direction:column;align-items:stretch}
 .nav-container{flex-direction:column;align-items:stretch;margin-top:15px;display:none}
 .nav-container.active{display:flex}
 .nav-links{flex-direction:column;align-items:stretch}
 .nav-item{margin:5px 0}
 .dropdown-menu{position:static;box-shadow:none;width:100%;display:none}
 .dropdown:hover .dropdown-menu{display:block}
 .mobile-menu-btn{display:block;position:absolute;right:20px;top:20px}
}
.container-flex{display:flex;gap:20px;max-width:1200px;margin:20px auto;padding:0 15px}
.sidebar{width:250px}.content{flex:1}
.card{background:#fff;border:1px solid #dee2e6;border-radius:6px;padding:20px;margin-bottom:25px;box-shadow:0 2px 4px rgba(0,0,0,.05)}
.list-group{list-style:none;padding:0;margin:0}
.list-group li{display:flex;justify-content:space-between;align-items:center;padding:12px 15px;border:1px solid #ddd;border-left:5px solid #6c757d;margin-bottom:8px;background:#f8f9fa;border-radius:4px;transition:.3s}
.list-group li:hover{background:#e9ecef;transform:translateX(5px)}
.list-group li a{color:inherit;text-decoration:none;flex:1;display:flex;justify-content:space-between}
.badge{min-width:24px;padding:4px;background:#6c757d;color:#fff;border-radius:50%;font-size:12px;text-align:center}
[data-color="success"]{border-left-color:#198754}[data-color="info"]{border-left-color:#0dcaf0}
[data-color="primary"]{border-left-color:#0d6efd}[data-color="warning"]{border-left-color:#ffc107}
table{width:100%;border-collapse:collapse;margin-top:15px}
th,td{border:1px solid #dee2e6;padding:12px;text-align:left;font-size:14px}
th{background:#4caf50;color:#fff;position:sticky;top:0}
tr:nth-child(even){background:#f2f2f2}tr:hover{background:#e9e9e9}
.btn{padding:6px 12px;border:none;border-radius:4px;color:#fff;font-size:14px;display:inline-flex;align-items:center;gap:5px;cursor:pointer;text-decoration:none}
.btn-select{background:#17a2b8}.btn-select:hover{background:#138496}
.btn-delete{background:#dc3545}.btn-delete:hover{background:#c82333}
.btn-issue{background:#ff9800}.btn-issue:hover{background:#e68a00}
.btn-disabled{opacity:.45;pointer-events:none}
.status-selected{color:#28a745;font-weight:bold}.status-not-selected{color:#dc3545;font-weight:bold}
.alert-ok{background:#d4edda;color:#155724;border:1px solid #c3e6cb;padding:10px 12px;border-radius:4px;margin-bottom:12px}
@media(max-width:900px){.container-flex{flex-direction:column}.sidebar{width:100%}}
</style>
</head>

<body>
<!-- ------------------------------------------------ HEADER ------------------------------------------------ -->
<header>
  <div class="header-container">
    <div class="logo-container">
      <img id="logo" src="1.png" alt="Logo"><a href="insert.jsp" class="brand">ProjectHub</a>
    </div>
    <button class="mobile-menu-btn" id="mobileMenuBtn"><i class="fas fa-bars"></i></button>

    <div class="nav-container" id="navContainer">
      <ul class="nav-links">
        <li class="nav-item"><a href="insert.jsp" class="nav-link"><i class="fas fa-home"></i><span>Home</span></a></li>
        <li class="nav-item dropdown"><a href="#" class="nav-link"><i class="fas fa-project-diagram"></i><span>Projects</span><i class="fas fa-chevron-down" style="margin-left:5px;font-size:12px;"></i></a>
          <div class="dropdown-menu"><a href="project.jsp" class="dropdown-item">Project List</a><a href="report.jsp" class="dropdown-item">Project Reports</a></div></li>
        <li class="nav-item dropdown"><a href="#" class="nav-link"><i class="fas fa-upload"></i><span>Upload</span><i class="fas fa-chevron-down" style="margin-left:5px;font-size:12px;"></i></a>
          <div class="dropdown-menu"><a href="upload.jsp" class="dropdown-item"><i class="fas fa-file-upload" style="width:16px"></i> Proje Yükle</a><a href="courses.jsp" class="dropdown-item"><i class="fas fa-book" style="width:16px"></i> Ders İşlemleri</a></div></li>
        <li class="nav-item"><a href="FAQs.jsp" class="nav-link"><i class="fas fa-question-circle"></i><span>FAQs</span></a></li>
        <li class="nav-item dropdown"><div class="user-profile nav-link"><div class="user-avatar"><%= user!=null?user.charAt(0):'U' %></div><span>Account</span><i class="fas fa-chevron-down" style="margin-left:5px;font-size:12px;"></i></div>
          <div class="dropdown-menu"><a href="ProfileServlet" class="dropdown-item"><i class="fas fa-user"></i><span>Profile</span></a><a href="LogoutServlet" class="dropdown-item"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a></div></li>
      </ul>
    </div>
  </div>
</header>

<!-- ------------------------------------------------  ANA İÇERİK  ------------------------------------------------ -->
<div class="container-flex">

  <!-- ---------------- SOL MENÜ ---------------- -->
  <aside class="sidebar">
    <div class="card"><h4>İstatistikler</h4>
      <ul class="list-group">
        <li data-color="success"><a href="courses.jsp?view=current"><span>Güncel Projeler</span><span class="badge"><%=guncelProjeler%></span></a></li>
        <li data-color="info"><a href="courses.jsp?view=mine"><span>Yüklenen Projeler</span><span class="badge"><%=benimProjelerim%></span></a></li>
        <li data-color="primary"><a href="courses.jsp?view=approved"><span>Onaylanan Projeler</span><span class="badge"><%=onaylananProjeler%></span></a></li>
        <li data-color="warning"><a href="courses.jsp?view=pending"><span>Onay Bekleyen</span><span class="badge"><%=onayBekleyenProj%></span></a></li>
      </ul>
    </div>
  </aside>

  <!-- ---------------- ANA PANEL ---------------- -->
  <section class="content">

    <!-- Ders Kartı -->
    <div class="card">
      <h4>Ders Listesi ve İşlemleri</h4>

      <%-- Yönetici tarafından onaylanmışsa mesajı göster --%>
      <% if(hasApprovedCourse){ %>
        <div class="alert-ok">
            <%= String.join(", ", approvedNames) %> dersi yönetici tarafından onaylandı ✓
        </div>
      <% } %>

      <table>
        <thead><tr><th>#</th><th>Ders Adı</th><th>Eğitmen</th><th>Seçim</th><th>Durumum</th><th>İşlemler</th></tr></thead>
        <tbody>
        <% for(Course c : courseList){
             boolean alreadyTaken = myProjects.stream().anyMatch(p -> p.getCourseName().equals(c.getName()));
             boolean canSelect    = !hasPendingCourse && !c.isSelectedByUser() && !alreadyTaken;
        %>
          <tr>
            <td><%= c.getId() %></td>
            <td><%= c.getName() %></td>
            <td><%= c.getInstructor() %></td>
            <td><%= c.getTotalSelected() %></td>
            <td class="<%= c.isSelectedByUser() ? "status-selected" : "status-not-selected" %>">
               <%= c.isSelectedByUser() ? "✔ Seçildi" : "✘ Seçilmedi" %></td>
            <td>
              <a class="btn btn-select <%= canSelect ? "" : "btn-disabled" %>"
                 <%= canSelect
                    ? "href=\"CourseSelectServlet?id="+c.getId()+"\""
                    : "href=\"javascript:void(0);\" onclick=\"alert('Bu dersi zaten aldınız veya bekleyen isteğiniz var.');\"" %>>
                 <i class="fas fa-check"></i>Seç
              </a>
              <a class="btn btn-delete" href="CourseDeleteServlet?id=<%=c.getId()%>"><i class="fas fa-trash"></i>Sil</a>
              <a class="btn btn-issue"  href="CourseIssueServlet?id=<%=c.getId()%>"><i class="fas fa-exclamation-triangle"></i>Sorun</a>
            </td>
          </tr>
        <% } %>
        </tbody>
      </table>
    </div>

    <!-- Danışman Kartı -->
    <div class="card">
      <h4>Danışman Seçimi</h4>
      <table>
        <thead><tr><th>#</th><th>Danışman</th><th>İşlem</th></tr></thead>
        <tbody>
        <% for(Advisor a : advisorList){
             boolean canSelAdv = !hasPendingAdvisor;
        %>
          <tr>
            <td><%= a.getId() %></td>
            <td><%= a.getName() %></td>
            <td>
              <a class="btn btn-select <%= canSelAdv ? "" : "btn-disabled" %>"
                 <%= canSelAdv
                    ? "href=\"AdvisorSelectServlet?id="+a.getId()+"\""
                    : "href=\"javascript:void(0);\" onclick=\"alert('Bekleyen danışman isteğiniz zaten var. Yönetici onayından sonra yeni danışman seçebilirsiniz.');\"" %>>
                <i class="fas fa-check"></i>Seç
              </a>
              <a class="btn btn-delete" href="AdvisorDeleteServlet?id=<%=a.getId()%>"><i class="fas fa-trash"></i>Sil</a>
            </td>
          </tr>
        <% } %>
        </tbody>
      </table>
    </div>

  </section>
</div>

<footer style="text-align:center;margin:20px 0;color:#555">© 2025 ProjectHub.</footer>

<script>
document.getElementById('mobileMenuBtn')
        .addEventListener('click', () => document.getElementById('navContainer').classList.toggle('active'));
</script>
</body>
</html>
