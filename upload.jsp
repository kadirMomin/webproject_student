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
            /* Dropdown CSS (sadece Projects için) */
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
            .dropdown-content a {
                color: #fff;
                padding: 8px 12px;
                text-decoration: none;
                display: block;
                transition: background-color 0.3s;
            }
            .dropdown-content a:hover {
                background-color: #95c11e;
                color: #000;
            }
            .dropdown:hover .dropdown-content {
                display: block;
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
            form textarea,
            form select {
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
                <a href="index2.jsp">SIGN UP OR SIGN IN</a>
            </nav>
        </header>
        <div id="upload-container">
            <form action="ProjectServlet" method="post" enctype="multipart/form-data">
                <!-- Proje Konusu -->
                <label for="projectTopic">Proje Konusu:</label>
                <input type="text" id="projectTopic" name="projectTopic" required>
                
                <!-- Yükleme Başlangıç Tarihi -->
                <label for="uploadStartDate">Yükleme Başlangıç Tarihi:</label>
                <input type="date" id="uploadStartDate" name="uploadStartDate" required placeholder="yyyy-MM-dd" />
                
                <!-- Yükleme Bitiş Tarihi -->
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
                
                <!-- Kütüphane Linki -->
                <label for="libraryLink">Kütüphane Linki:</label>
                <input type="text" id="libraryLink" name="libraryLink" required>
                
                <!-- Proje Publish Edildi mi? -->
                <label for="projectPublished">Proje Publish Edildi mi?</label>
                <select id="projectPublished" name="projectPublished" required>
                    <option value="" selected disabled>Seçiniz</option>
                    <option value="yes">Evet</option>
                    <option value="no">Hayır</option>
                </select>
                
                <!-- Projenin Aldığı Ödüller -->
                <label for="projectAwards">Projenin Aldığı Ödüller (1-5):</label>
                <select id="projectAwards" name="projectAwards" required>
                    <option value="" selected disabled>Seçiniz</option>
                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                </select>
                
                <!-- Proje Açıklaması -->
                <label for="projectDescription">Proje Açıklaması:</label>
                <textarea id="projectDescription" name="projectDescription" rows="5" required></textarea> 
                
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
