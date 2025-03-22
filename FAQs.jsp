<%-- 
    Document   : newjsp
    Created on : Feb 19, 2025, 3:16:18 PM
    Author     : hp
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
    body {
      background-color: #000;
      color: #95c11e;
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
    }

    header {
      background-color: #000;
      padding: 20px;
      text-align: center;
      position: relative;
    }

    h1 {
      margin: 0;
      color: #fff;
    }

    #logo {
      position: absolute;
      top: 10px;
      left: 40px;
      width: 150px;
    }

    nav {
      margin-top: 10px;
    }

    nav a {
      color: #fff;
      text-decoration: none;
      margin: 0 15px;
      font-size: 18px;
    }

    .faq-container {
      max-width: 800px;
      margin: 20px auto;
      padding: 20px;
    }

    .faq {
      margin-bottom: 20px;
    }

    .faq h2 {
      color: #95c11e;
      cursor: pointer;
    }

    .faq p {
      display: none;
    }

    footer {
      background-color: #000;
      padding: 10px;
      text-align: center;
      position: fixed;
      bottom: 0;
      width: 100%;
    }

    #question-mark {
      position: fixed;
      top: 45%;
      right: 30px;
      transform: translateY(-50%);
      width: 350px;
      height: auto;
    }
  </style>
    </head>
    <body>
     <header>
         <img id="logo" src="1.png" alt="Logo">
    <h1>FAQs</h1>
    <nav>
      <a href="insert.jsp">HOME</a>
      <a href="project.jsp">Projects</a>
      <a href="upload.jsp">UPLOAD</a>
      <a href="FAQs.jsp">FAQs</a>
      <a href="index2.jsp">SIGN UP OR SIGN IN</a>
    </nav>
  </header>
        
         <div class="faq-container">
    <div class="faq">
      <h2>What is the purpose of this platform?</h2>
      <p>The platform is designed to provide present students and alumni with a space to showcase and share their academic and personal projects, fostering a sense of community and inspiration.</p>
    </div>

    <div class="faq">
      <h2>Who can use this platform?</h2>
      <p>Present students and alumni are welcome to actively participate by posting and exploring academic and personal projects.</p>
    </div>

    <div class="faq">
      <h2>How can I post my projects on the platform?</h2>
      <p>To share your projects, simply log in to your account, navigate to the designated section, and follow the user-friendly posting process to showcase your present and past endeavors.</p>
    </div>

    <div class="faq">
      <h2>Is there a limit to the number of projects I can post?</h2>
      <p>No, there is no limit. Feel free to share as many projects as you'd like to highlight your diverse range of academic and personal achievements.</p>
    </div>

    <div class="faq">
      <h2>Can I interact with other users on the platform?</h2>
      <p>Absolutely! Engage in discussions, offer feedback, and connect with fellow present students and alumni who share similar interests or have worked on related projects.</p>
    </div>

    <div class="faq">
      <h2>Are only academic projects accepted, or can I share personal projects as well?</h2>
      <p>The platform encourages the sharing of both academic and personal projects. Whether it's a research paper, a personal blog, or a creative endeavor, we welcome a diverse range of contributions.</p>
    </div>

    <div class="faq">
      <h2>How can I stay updated on new projects and platform activities?</h2>
      <p>Stay connected by regularly checking the platform for updates. You can also subscribe to newsletters or follow our social media channels to receive timely notifications about new projects, events, and community highlights.</p>
    </div>

    <div class="faq">
      <h2>Is there a search feature to find specific projects or topics?</h2>
      <p>Yes, the platform is equipped with a search feature, allowing users to easily find specific projects or topics of interest. Simply enter keywords, tags, or relevant details to streamline your search.</p>
    </div>

    <div class="faq">
      <h2>I have technical difficulties or other inquiries. How can I get support?</h2>
      <p>For any technical issues or general inquiries, feel free to reach out to our dedicated support team through the "Contact Us" section on the platform. We are here to assist you in making your experience seamless and enjoyable.</p>
    </div>
  </div>

  <footer>
    <p>kadir_boss@gmail.com</p>
  </footer>

  <img src="2.png" alt="Question Mark Image" id="question-mark">

  <script>
    // Add JavaScript to toggle the display of answers when questions are clicked
    document.addEventListener('DOMContentLoaded', function () {
      var faqQuestions = document.querySelectorAll('.faq h2');

      faqQuestions.forEach(function (question) {
        question.addEventListener('click', function () {
          var answer = this.nextElementSibling;

          if (answer.style.display === 'block') {
            answer.style.display = 'none';
          } else {
            answer.style.display = 'block';
          }
        });
      });
    });
  </script>
    </body>
</html>
