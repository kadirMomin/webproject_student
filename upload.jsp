<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String user     = (String) session.getAttribute("user");
String userName = (String) session.getAttribute("userName");
if (user == null){
    response.sendRedirect("index2.jsp?error=loginfirst&return=upload.jsp");
    return;
}

/* ---------- DERS + DANIŞMAN ONAY KONTROLÜ ---------- */                 /* ★ */
boolean okCourse  = new course.CourseDAO().hasApprovedCourse(user);        /* ★ */
boolean okAdvisor = new advisor.AdvisorDAO().hasAdvisor(user);             /* ★ */
if( !okCourse || !okAdvisor ){                                             /* ★ */
    response.sendRedirect("courses.jsp?error=notapproved");                /* ★ */
    return;                                                                /* ★ */
}                                                                           /* ★ */
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Upload Project - ProjectHub</title>

  <!-- Font Awesome -->
  <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

  <style>
    /* ——— GLOBAL ——— */
    body{font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif;
         background:#f2f2f2;margin:0;color:#333;padding:20px;}

    /* ——— HEADER ——— */
    header{background:#2c3e50;padding:15px 30px;box-shadow:0 2px 8px rgba(0,0,0,.12);
           position:sticky;top:0;z-index:1000;}
      .header-container{display:flex;align-items:center;max-width:1400px;margin:0 auto;
                        flex-wrap:wrap;width:100%;}
      .logo-container{display:flex;align-items:center;margin-right:30px;}
        #logo{width:40px;height:40px;margin-right:10px;}
        .brand{color:#fff;font-size:1.5rem;font-weight:600;text-decoration:none;}

      .nav-container{display:flex;align-items:center;flex-grow:1;justify-content:flex-end;
                     flex-wrap:wrap;}
      .nav-links{display:flex;align-items:center;list-style:none;margin:0;padding:0;}
        .nav-item{margin-left:15px;position:relative;}
        .nav-link{color:#ecf0f1;text-decoration:none;padding:8px 12px;border-radius:4px;
                  font-size:15px;font-weight:500;display:flex;align-items:center;
                  transition:background .3s;}
        .nav-link:hover{background:rgba(255,255,255,.1);color:#fff;}

      /* Dropdown */
      .dropdown-menu{position:absolute;right:0;background:#fff;min-width:200px;
                     box-shadow:0 8px 16px rgba(0,0,0,.1);border-radius:4px;
                     padding:10px 0;display:none;z-index:1000;}
      .dropdown:hover .dropdown-menu{display:block;}
      .dropdown-item{display:block;padding:10px 20px;color:#333;text-decoration:none;
                     transition:background .3s;}
      .dropdown-item:hover{background:#f8f9fa;color:#2c3e50;}

      /* Avatar */
      .user-profile{display:flex;align-items:center;cursor:pointer;}
      .user-avatar{width:32px;height:32px;border-radius:50%;margin-right:8px;
                   background:#3498db;color:#fff;display:flex;align-items:center;
                   justify-content:center;font-weight:bold;}

      /* Mobile */
      .mobile-menu-btn{display:none;background:none;border:none;color:#fff;font-size:20px;
                       cursor:pointer;}
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

    /* ——— FORM ——— */
    #upload-container{max-width:800px;margin:120px auto 60px;padding:40px;background:#fff;
                      border-radius:6px;box-shadow:0 0 10px rgba(0,0,0,.1);}
    form label{display:block;margin-bottom:10px;font-size:18px;color:#333;}
    form input,form textarea,form select{width:100%;padding:12px;margin-bottom:20px;
          box-sizing:border-box;font-size:16px;border:1px solid #ccc;border-radius:5px;}
    form textarea{resize:vertical;}
    form button{background:#4caf50;color:#fff;padding:15px 20px;border:none;border-radius:5px;
                font-size:18px;cursor:pointer;transition:background .3s;}
    form button:hover{background:#45a049;}

    footer{background:#343a40;padding:4px 8px;text-align:center;position:fixed;bottom:0;
           width:100%;color:#fff;font-size:14px;}
  </style>
</head>
<body>
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
            <div class="user-avatar"><%= userName!=null?userName.charAt(0):'U' %></div>
            <span><%= userName!=null?("Hoşgeldiniz, "+userName):"SIGN IN" %></span>
            <i class="fas fa-chevron-down" style="margin-left:5px;font-size:12px;"></i>
          </div>
          <div class="dropdown-menu">
            <a href="LogoutServlet" class="dropdown-item"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
          </div>
        </li>
      </ul>
    </div>
  </div>
</header>

<div id="upload-container">
  <form action="ProjectServlet" method="post" enctype="multipart/form-data">
    <label for="projectTopic">Proje Konusu:</label>
    <input type="text" id="projectTopic" name="projectTopic" required>

    <label for="uploadStartDate">Yükleme Başlangıç Tarihi:</label>
    <input type="date" id="uploadStartDate" name="uploadStartDate" required placeholder="yyyy‑MM‑dd">

    <label for="uploadEndDate">Yükleme Bitiş Tarihi:</label>
    <input type="date" id="uploadEndDate" name="uploadEndDate" required placeholder="yyyy‑MM‑dd">

    <label for="courseName">Ders Adı:</label>
    <input type="text" id="courseName" name="courseName" required>

    <label for="advisorName">Danışman Adı:</label>
    <input type="text" id="advisorName" name="advisorName" required>

    <label for="githubLink">GitHub Link:</label>
    <input type="url" id="githubLink" name="githubLink" required>

    <label for="libraryLink">Kütüphane Linki:</label>
    <input type="url" id="libraryLink" name="libraryLink" required>

    <label for="projectPublished">Proje Publish Edildi mi?</label>
    <select id="projectPublished" name="projectPublished" required>
      <option value="" selected disabled>Seçiniz</option>
      <option value="yes">Evet</option>
      <option value="no" >Hayır</option>
    </select>

    <!-- YAYIN LINKI sadece “Evet” seçilince açılır -->
    <div id="publish-link-wrapper" style="display:none;">
      <label for="publishLink">Publish Linki (makale / konferans vb.):</label>
      <input type="url" id="publishLink" name="publishLink" placeholder="https:// ">
    </div>

    <label for="projectAwards">Projenin Aldığı Ödüller (1‑5):</label>
    <select id="projectAwards" name="projectAwards" required>
      <option value="" selected disabled>Seçiniz</option>
      <option value="1">1</option><option value="2">2</option>
      <option value="3">3</option><option value="4">4</option>
      <option value="5">5</option>
    </select>

    <label for="projectDescription">Proje Açıklaması:</label>
    <textarea id="projectDescription" name="projectDescription" rows="5" required></textarea>

    <label for="projectImage">Proje Resmi:</label>
    <input type="file" id="projectImage" name="projectImage" accept="image/*" required>
    
    <label for="projectZip">Proje ZIP Dosyası:</label>
<input type="file" id="projectZip" name="projectZip" accept=".zip" required>

    <button type="submit">Upload</button>
  </form>
</div>

<% String err=(String)request.getAttribute("errorMessage"); if(err!=null){ %>
<script>alert("<%= err %>");</script>
<% } %>

<footer><p>&copy; 2025 ProjectHub. All rights reserved.</p></footer>

<script>
/* Mobil menü */
document.getElementById('mobileMenuBtn')
        .addEventListener('click',()=>document.getElementById('navContainer').classList.toggle('active'));

/* Publish link alanını göster/gizle */
const sel  = document.getElementById('projectPublished');
const wrap = document.getElementById('publish-link-wrapper');
function toggleLink(){ wrap.style.display = sel.value==='yes' ? 'block' : 'none'; }
sel.addEventListener('change',toggleLink);
toggleLink();  /* sayfa yenilendiğinde kontrol */
</script>
</body>
</html>
