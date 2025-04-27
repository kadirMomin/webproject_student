<%@ page contentType="text/html;charset=UTF-8" language="java" import="project.Project, project.ProjectDAO" %>
<%
    /* —— Proje bilgisi model veya servlet’ten gelmediyse burada çekiyoruz —— */
    Project project = (Project) request.getAttribute("project");

    if (project == null) {                              // ① Öncelik : id
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isBlank()) {
            try {
                int pid = Integer.parseInt(idParam);
                ProjectDAO dao = new ProjectDAO();
                project = dao.getProjectById(pid);
            } catch (NumberFormatException ignore) {
                /* geçersiz id ise alttaki topic’e düş */ }
        }
    }

    if (project == null) {                              // ② Geriye dönük uyumluluk : topic
        String projectTopic = request.getParameter("projectTopic");
        if (projectTopic != null && !projectTopic.trim().isEmpty()) {
            ProjectDAO dao = new ProjectDAO();
            project = dao.getProjectByTopic(projectTopic);
        }
    }
%>
<!DOCTYPE html>
<html lang="tr">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Proje Detay</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
        <style>
            *{
                margin:0;
                padding:0;
                box-sizing:border-box;
            }
            body{
                font-family:Arial,sans-serif;
                background:#f2f2f2;
                padding:20px;
            }
            header{
                background:#343a40;
                padding:20px;
                text-align:center;
                position:relative;
            }
            header img#logo{
                position:absolute;
                top:10px;
                left:40px;
                width:150px;
            }
            header h1{
                margin:0;
                color:#fff;
                display:inline-block;
            }
            nav{
                margin-top:10px;
            }
            nav a{
                color:#fff;
                text-decoration:none;
                margin:0 15px;
                font-size:18px;
            }
            nav a:hover{
                text-decoration:underline;
            }
            .container{
                max-width:900px;
                margin:20px auto;
                background:#fff;
                padding:20px;
                border-radius:6px;
                box-shadow:0 0 10px rgba(0,0,0,.1);
            }
            .header{
                display:flex;
                justify-content:space-between;
                align-items:center;
                margin-bottom:20px;
            }
            .header h1{
                font-size:24px;
                color:#333;
            }
            .project-topic{
                font-size:16px;
                padding:6px 12px;
                background:#007bff;
                color:#fff;
                border-radius:4px;
            }
            .content{
                display:flex;
                flex-wrap:wrap;
            }
            .image-container{
                flex:0 0 250px;
                margin-right:20px;
                margin-bottom:20px;
            }
            .image-container img{
                width:100%;
                border:1px solid #ccc;
                border-radius:4px;
            }
            .details{
                flex:1;
            }
            .details h2{
                font-size:18px;
                margin-bottom:10px;
                color:#333;
            }
            .details p{
                margin-bottom:10px;
                line-height:1.5;
                color:#555;
            }
            .download-link a{
                color:#007bff;
                text-decoration:none;
            }
            .download-link a:hover{
                text-decoration:underline;
            }
        </style>
    </head>
    <body>
        <header>
            <img id="logo" src="1.png" alt="Logo">
            <h1>Getting Started</h1>
            <nav>
                <a href="insert.jsp">HOME</a>
                <a href="project.jsp">PROJECTS</a>
                <a href="upload.jsp">UPLOAD</a>
                <a href="FAQs.jsp">FAQs</a>
                <a href="index2.jsp">SIGN UP OR SIGN IN</a>
            </nav>
        </header>

        <div class="container">
            <div class="header">
                <h1>Proje Detay</h1>
                <div class="project-topic">Proje Konusu: <%= project != null ? project.getProjectTopic() : "Bilgi Yok"%></div>
            </div>

            <div class="content">
                <div class="image-container">
                    <img src="uploads/<%= project != null ? project.getProjectImage() : "1.png"%>" alt="Proje Görseli">
                </div>
                <div class="details">
                    <h2>Proje Açıklaması :</h2>
                    <p><%= project != null ? project.getProjectDescription() : "Açıklama bulunamadı."%></p>

                    <h2>Proje Dosyası İndirme Linki :</h2>
                    <p class="download-link">
                        <a href="uploads/zips/<%= project != null ? project.getProjectFile() : "#"%>"
                           target="_blank">ZIP’i indir</a>
                    </p>
                </div>
            </div>
        </div>
    </body>
</html>
