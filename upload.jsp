<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Kullanıcının oturum açıp açmadığını kontrol ediyoruz.
    String user = (String) session.getAttribute("user");
    if (user == null) {
        // Oturum açılmamışsa, login sayfasına yönlendiriyoruz.
        // Burada "return" parametresini upload.jsp olarak belirtiyoruz.
        response.sendRedirect("index2.jsp?error=loginfirst&return=upload.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Upload Project - Your Platform Name</title>
        <style>
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
            #logo {
                width: 150px;
                margin-right: 20px;
            }
            h1 {
                margin: 0;
                color: #fff;
                font-size: 24px;
                flex: 1;
                text-align: center;
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
            /* Form Container */
            #upload-container {
                max-width: 800px;
                margin: 120px auto 60px;
                padding: 40px;
                background-color: #fff;
                border-radius: 6px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            form label {
                display: block;
                margin-bottom: 10px;
                font-size: 18px;
                color: #333;
            }
            form input,
            form textarea {
                width: 100%;
                padding: 12px;
                margin-bottom: 20px;
                box-sizing: border-box;
                font-size: 16px;
                border: 1px solid #ccc;
                border-radius: 5px;
            }
            form textarea {
                resize: vertical;
            }
            form button {
                background-color: #4caf50;
                color: #fff;
                padding: 15px 20px;
                border: none;
                border-radius: 5px;
                font-size: 18px;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }
            form button:hover {
                background-color: #45a049;
            }
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
        <header>
            <img id="logo" src="1.png" alt="Logo">
            <h1>Upload Project</h1>
            <nav>
                <a href="insert.jsp">HOME</a>
                <a href="project.jsp">Projects</a>
                <a href="upload.jsp">UPLOAD</a>
                <a href="FAQs.jsp">FAQs</a>
                <a href="index2.jsp">SIGN UP OR SIGN IN</a>
            </nav>
        </header>
        <div id="upload-container">
            <form action="ProjectServlet" method="post" enctype="multipart/form-data">
                <!-- Proje Konusu -->
                <label for="projectTopic">Proje Konusu:</label>
                <input type="text" id="projectTopic" name="projectTopic" required>
                <!-- Yüklenen Zamanı: Başlangıç Tarihi -->
                <label for="uploadStartDate">Yükleme Başlangıç Tarihi:</label>
                <input type="date" id="uploadStartDate" name="uploadStartDate" required placeholder="yyyy-MM-dd" />
                <!-- Yüklenen Zamanı: Bitiş Tarihi -->
                <label for="uploadEndDate">Yükleme Bitiş Tarihi:</label>
                <input type="date" id="uploadEndDate" name="uploadEndDate" required placeholder="yyyy-MM-dd" />
                <!-- Ders Adı -->
                <label for="courseName">Ders Adı:</label>
                <input type="text" id="courseName" name="courseName" required>
                <!-- Danışman Adı -->
                <label for="advisorName">Danışman Adı:</label>
                <input type="text" id="advisorName" name="advisorName" required>
                <!-- GitHub Link -->
                <label for="githubLink">GitHub Link:</label>
                <input type="text" id="githubLink" name="githubLink" required>
                <!-- Proje Açıklaması -->
                <label for="projectDescription">Proje Açıklaması:</label>
                <textarea id="projectDescription" name="projectDescription" rows="5" required></textarea> -->
                <!-- Proje Resmi -->
                <label for="projectImage">Proje Resmi:</label>
                <input type="file" id="projectImage" name="projectImage" accept="image/*" required> 
                <button type="submit">Upload</button>
            </form>
        </div>
        <% 
            String errorMessage = (String) request.getAttribute("errorMessage"); 
            if (errorMessage != null) { 
        %>
        <script>
            alert("<%= errorMessage %>");
        </script>
        <% 
            } 
        %>
        <footer>
            <p>&copy; 2025 Your Platform Name. All rights reserved.</p>
        </footer>
    </body>
</html>
