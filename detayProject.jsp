<%-- 
    Document   : detayProject
    Created on : Feb 26, 2025, 1:00:51 PM
    Author     : hp
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Proje Detay</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">

    <style>
        /* Genel Sıfırlama */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        /* Gövde */
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2; /* Açık gri arka plan */
            padding: 20px;
        }

        /* Üst Header */
        header {
            background-color: #343a40; /* Siyaha yakın koyu gri */
            padding: 20px;
            text-align: center;
            position: relative;
        }
        header img#logo {
            position: absolute;
            top: 10px;
            left: 40px;
            width: 150px;
        }
        header h1 {
            margin: 0;
            color: #fff; /* Başlık metni beyaz */
            display: inline-block;
        }
        nav {
            margin-top: 10px;
        }
        nav a {
            color: #fff; /* Menü linkleri beyaz */
            text-decoration: none;
            margin: 0 15px;
            font-size: 18px;
        }
        nav a:hover {
            text-decoration: underline;
        }

        /* Ana Kapsayıcı */
        .container {
            max-width: 900px;
            margin: 20px auto; 
            background-color: #fff;  /* Beyaz zemin */
            padding: 20px;
            border-radius: 6px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        /* İç Header (Proje Detay kısmı) */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .header h1 {
            font-size: 24px;
            color: #333; /* Koyu gri */
        }
        .header .project-topic {
            font-size: 16px;
            padding: 6px 12px;
            background-color: #007bff; /* Bootstrap mavisi */
            color: #fff;
            border-radius: 4px;
        }

        /* İçerik */
        .content {
            display: flex;
            flex-wrap: wrap; /* Dar ekranda alta geçmesi için */
        }
        .content .image-container {
            flex: 0 0 250px;
            margin-right: 20px;
            margin-bottom: 20px;
        }
        .content .image-container img {
            width: 100%;
            height: auto;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .content .details {
            flex: 1;
        }
        .details h2 {
            font-size: 18px;
            margin-bottom: 10px;
            color: #333;
        }
        .details p {
            margin-bottom: 10px;
            line-height: 1.5;
            color: #555;
        }

        /* İndirme Linki */
        .details .download-link a {
            color: #007bff;
            text-decoration: none;
        }
        .details .download-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <!-- Üst Header (Logo + Menü) -->
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

    <!-- Ana İçerik -->
    <div class="container">
        <!-- Başlık ve Konu Kısmı -->
        <div class="header">
            <h1>Proje Detay</h1>
            <div class="project-topic">Proje Konusu: RehberSitemi</div>
        </div>

        <!-- Resim ve Açıklamalar -->
        <div class="content">
            <div class="image-container">
                <img src="1.png" alt="Proje Görseli">
            </div>
            <div class="details">
                <h2>Proje Açıklaması :</h2>
                <p>
                    Deneme Proje Açıklaması Yapılıyor. Bundan sonrası düz yazı…<br>
                    Kontrol amaçlı yazıyorum.
                </p>
                <h2>Proje Dosyası İndirme Linki :</h2>
                <p class="download-link">
                    <a href="#" target="_blank">İndirmek için Tıklayınız.</a>
                </p>
            </div>
        </div>
    </div>
</body>
</html>
