<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="project.Project, project.ProjectDAO" %>
<%
    /* —— Proje bilgisi —— */
    Project project = (Project) request.getAttribute("project");

    if (project == null) {                              // ① id'den çek
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isBlank()) {
            try { project = new ProjectDAO().getProjectById(Integer.parseInt(idParam));
            } catch(NumberFormatException ignore){}
        }
    }
    if (project == null) {                              // ② eski topic parametresi
        String topic = request.getParameter("projectTopic");
        if (topic != null && !topic.isBlank())
            project = new ProjectDAO().getProjectByTopic(topic);
    }
%>
<!DOCTYPE html>
<html lang="tr">
<head>
<meta charset="UTF-8">
<title><%= project!=null?project.getProjectTopic():"Proje Detay" %></title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style>
:root {
    --primary-color: #3498db;
    --secondary-color: #2c3e50;
    --accent-color: #e74c3c;
    --light-gray: #f8f9fa;
    --dark-gray: #343a40;
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background-color: var(--light-gray);
    color: #333;
    line-height: 1.6;
}

header {
    background: linear-gradient(135deg, var(--secondary-color), var(--dark-gray));
    padding: 20px 0;
    text-align: center;
    position: relative;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

header img#logo {
    position: absolute;
    top: 50%;
    left: 40px;
    transform: translateY(-50%);
    width: 150px;
    transition: transform 0.3s ease;
}

header img#logo:hover {
    transform: translateY(-50%) scale(1.05);
}

header h1 {
    margin: 0;
    color: #fff;
    display: inline-block;
    font-weight: 600;
    font-size: 1.8rem;
}

nav {
    margin-top: 15px;
}

nav a {
    color: #fff;
    text-decoration: none;
    margin: 0 15px;
    font-size: 1rem;
    font-weight: 500;
    padding: 5px 10px;
    border-radius: 4px;
    transition: all 0.3s ease;
}

nav a:hover {
    background-color: rgba(255,255,255,0.1);
    text-decoration: none;
}

.container {
    max-width: 1000px;
    margin: 30px auto;
    background: #fff;
    padding: 30px;
    border-radius: 8px;
    box-shadow: 0 5px 15px rgba(0,0,0,0.05);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.container:hover {
    box-shadow: 0 8px 25px rgba(0,0,0,0.1);
}

.header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 25px;
    padding-bottom: 15px;
    border-bottom: 1px solid #eee;
}

.header h1 {
    font-size: 1.8rem;
    color: var(--secondary-color);
    font-weight: 700;
}

.project-topic {
    font-size: 1rem;
    padding: 8px 15px;
    background: var(--primary-color);
    color: #fff;
    border-radius: 50px;
    font-weight: 600;
    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}

.content {
    display: flex;
    flex-wrap: wrap;
    gap: 30px;
}

.image-container {
    flex: 0 0 300px;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 3px 10px rgba(0,0,0,0.1);
    transition: transform 0.3s ease;
    height: fit-content;
}

.image-container:hover {
    transform: scale(1.02);
}

.image-container img {
    width: 100%;
    height: auto;
    display: block;
    transition: transform 0.5s ease;
}

.image-container:hover img {
    transform: scale(1.05);
}

.details {
    flex: 1;
    min-width: 300px;
}

.details h2 {
    font-size: 1.4rem;
    margin-bottom: 15px;
    color: var(--secondary-color);
    font-weight: 600;
    position: relative;
    padding-bottom: 8px;
}

.details h2:after {
    content: '';
    position: absolute;
    bottom: 0;
    left: 0;
    width: 50px;
    height: 3px;
    background: var(--primary-color);
}

.details p {
    margin-bottom: 20px;
    line-height: 1.7;
    color: #555;
}

/* Yükleyen Kullanıcı Özel Stili */
.uploader-section {
    background-color: #f8f9fa;
    border-radius: 8px;
    padding: 20px;
    margin: 25px 0;
    border-left: 4px solid var(--primary-color);
    display: flex;
    align-items: center;
    gap: 15px;
}

.uploader-avatar {
    width: 60px;
    height: 60px;
    border-radius: 50%;
    background-color: var(--primary-color);
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 1.5rem;
    font-weight: bold;
}

.uploader-info h3 {
    font-size: 1.2rem;
    margin-bottom: 5px;
    color: var(--secondary-color);
}

.uploader-info p {
    margin: 0;
    color: #6c757d;
    font-size: 0.9rem;
}

.download-link {
    margin-top: 25px;
}

.download-link a {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    color: #fff;
    background-color: var(--primary-color);
    padding: 12px 25px;
    border-radius: 50px;
    text-decoration: none;
    font-weight: 600;
    transition: all 0.3s ease;
    box-shadow: 0 3px 10px rgba(52, 152, 219, 0.3);
}

.download-link a:hover {
    background-color: #2980b9;
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(52, 152, 219, 0.4);
    text-decoration: none;
}

.download-link a i {
    font-size: 1.2rem;
}

/* Responsive Tasarım */
@media (max-width: 768px) {
    header img#logo {
        position: static;
        transform: none;
        margin-bottom: 15px;
    }
    
    header {
        padding: 20px;
    }
    
    nav {
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
        gap: 10px;
    }
    
    nav a {
        margin: 0 5px;
    }
    
    .content {
        flex-direction: column;
    }
    
    .image-container {
        flex: 1 1 100%;
        margin-right: 0;
    }
}
</style>
</head>
<body>
<header>
    <img id="logo" src="1.png" alt="Logo">
    <h1>Proje Yönetim Sistemi</h1>
    <nav>
        <a href="insert.jsp"><i class="fas fa-home"></i> HOME</a>
        <a href="project.jsp"><i class="fas fa-project-diagram"></i> PROJECTS</a>
        <a href="upload.jsp"><i class="fas fa-upload"></i> UPLOAD</a>
        <a href="FAQs.jsp"><i class="fas fa-question-circle"></i> FAQs</a>
        <a href="index2.jsp"><i class="fas fa-user"></i> SIGN IN</a>
    </nav>
</header>

<div class="container">
    <div class="header">
        <h1>Proje Detay</h1>
        <div class="project-topic">
            <%= project!=null?project.getProjectTopic():"Bilgi Yok" %>
        </div>
    </div>

    <div class="content">
        <div class="image-container">
            <img src="uploads/<%= project!=null?project.getProjectImage():"1.png" %>" alt="Proje Görseli">
        </div>

        <div class="details">
            <h2>Proje Açıklaması</h2>
            <p><%= project!=null?project.getProjectDescription():"Açıklama bulunamadı." %></p>

            <!-- Vurgulanmış Yükleyen Kullanıcı Bölümü -->
            <div class="uploader-section">
                <div class="uploader-avatar">
                    <%= project!=null && project.getUploaderName()!=null ? 
                        project.getUploaderName().substring(0,1).toUpperCase() : "?" %>
                </div>
                <div class="uploader-info">
                    <h3>Yükleyen Kullanıcı</h3>
                    <p><i class="fas fa-user"></i> <%= project!=null?project.getUploaderName():"Bilinmiyor" %></p>
                    <p><i class="fas fa-calendar-alt"></i> <%= new java.util.Date() %></p>
                </div>
            </div>

            <h2>Proje Dosyası</h2>
            <div class="download-link">
                <a href="uploads/zips/<%= project!=null?project.getProjectFile():"#"%>" target="_blank">
                    <i class="fas fa-file-archive"></i> ZIP'i İndir
                </a>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
// Proje görseline tıklanınca büyütme efekti
$(document).ready(function() {
    $('.image-container img').click(function() {
        $(this).toggleClass('zoomed');
    });
    
    // Yükleyen kullanıcı bölümüne hover efekti
    $('.uploader-section').hover(
        function() {
            $(this).css('transform', 'translateY(-3px)');
            $(this).css('box-shadow', '0 5px 15px rgba(0,0,0,0.1)');
        },
        function() {
            $(this).css('transform', '');
            $(this).css('box-shadow', '');
        }
    );
});
</script>
</body>
</html>