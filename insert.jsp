<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="shortcut icon" href="https://sidcupfamilygolf.com/wp-content/themes/puttosaurus/favicons/favicon-32x32.png" type="image/x-icon" />
        <link href="https://cdn.jsdelivr.net/npm/remixicon@3.4.0/fonts/remixicon.css" rel="stylesheet" />
        <link rel="stylesheet" href="style.css" />
        <style>
            /* Mevcut stil kodlarınız burada yer alıyorsa, onları koruyun; 
               aşağıda sadece ek dropdown CSS kuralları eklenmiştir. */

            /* Dropdown için CSS */
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
        </style>
    </head>
    <body>

        <!-- Language Selector -->
        <div id="language-selector" style="position: fixed; top: 20px; right: 20px; z-index: 1000;">
            <select id="language">
                <option value="en">English</option>
                <option value="tr">Türkçe</option>
            </select>
        </div>

        <div id="nav">
            <img src="1.png" alt="" />
            <div id="search-bar">
                <input type="text" id="search-input" placeholder="Search projects...">
                <button id="search-button">Search</button>
            </div>
            <a href="insert.jsp"><h4 data-lang="en">HOME</h4><h4 data-lang="tr" style="display: none;">ANA SAYFA</h4></a>

            <!-- Projects dropdown menü -->
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
            <!-- ▼▼▼ YENİ: UPLOAD menüsü Admin Panel bağlantısıyla birlikte ▼▼▼ -->
            <div class="dropdown">
                <a class="dropbtn">
                    <h4 data-lang="en">UPLOAD</h4>
                    <h4 data-lang="tr" style="display:none;">YÜKLE</h4>
                </a>
                <div class="dropdown-content">
                    <a href="upload.jsp">Upload Project</a>
                    <a href="combined.jsp">Yönetim Panel</a>
                </div>
            </div>
            <!--<a href="upload.jsp"><h4 data-lang="en">UPLOAD</h4><h4 data-lang="tr" style="display: none;">YÜKLE</h4></a>
              <a href="combined.jsp"><h4 data-lang="en">ADMIN</h4><h4 data-lang="tr" style="display:none;">YÖNETİCİ</h4></a>-->
            <a href="FAQs.jsp"><h4 data-lang="en">FAQs</h4><h4 data-lang="tr" style="display: none;">SSS</h4></a>
            <a href="index2.jsp"><h4 data-lang="en">SIGN UP OR SIGN IN</h4><h4 data-lang="tr" style="display: none;">KAYIT OL / GİRİŞ YAP</h4></a>
        </div>
        <div id="cursor"></div>
        <div id="cursor-blur"></div>

        <video autoplay loop muted src="https://sidcupfamilygolf.com/wp-content/uploads/2023/02/hero.mp4"></video>
        <div id="main">
            <div id="page1">
                <h1 data-lang="en">EXPLORE. CREATE. CONNECT.</h1>
                <h1 data-lang="tr" style="display: none;">KEŞFET. YARAT. BAĞLAN.</h1>
                <h2 data-lang="en">WELCOME TO OPEN FORGE</h2>
                <h2 data-lang="tr" style="display: none;">OPEN FORGE'A HOŞ GELDİNİZ</h2>
                <p data-lang="en">
                    Your go-to platform to showcase academic and personal projects. We're all about tech, player development, and making the project-sharing experience fun and accessible for everyone. Join us in celebrating diverse stories at Open Forge.
                </p>
                <p data-lang="tr" style="display: none;">
                    Akademik ve kişisel projelerinizi sergilemek için başvurabileceğiniz platform. Teknoloji, gelişim ve proje paylaşımını herkes için eğlenceli ve erişilebilir hale getirmeye odaklanıyoruz. Open Forge'da çeşitli hikayeleri kutlamak için bize katılın.
                </p>
                <div id="arrow">
                    <i class="ri-arrow-down-line"></i>
                </div>
            </div>
            <div id="page2">
                <div id="scroller">
                    <div id="scroller-in">
                        <h4 data-lang="en">TOPTRACER RANGE</h4>
                        <h4 data-lang="tr" style="display: none;">TOPTRACER MENZİLİ</h4>
                        <h4 data-lang="en">GOLF LESSONS</h4>
                        <h4 data-lang="tr" style="display: none;">GOLF DERSLERİ</h4>
                        <h4 data-lang="en">ADVENTURE GOLF</h4>
                        <h4 data-lang="tr" style="display: none;">MACERA GOLFÜ</h4>
                        <h4 data-lang="en">COFFEE SHOP</h4>
                        <h4 data-lang="tr" style="display: none;">KAHVE DÜKKANI</h4>
                        <h4 data-lang="en">LEAGUES</h4>
                        <h4 data-lang="tr" style="display: none;">LİGLER</h4>
                    </div>
                    <div id="scroller-in">
                        <h4 data-lang="en">INNOVATION</h4>
                        <h4 data-lang="tr" style="display: none;">YENİLİK</h4>
                        <h4 data-lang="en">CREATIVITY</h4>
                        <h4 data-lang="tr" style="display: none;">YARATICILIK</h4>
                        <h4 data-lang="en">EMPOWERMENT</h4>
                        <h4 data-lang="tr" style="display: none;">GÜÇLENDİRME</h4>
                        <h4 data-lang="en">COLLABORATION</h4>
                        <h4 data-lang="tr" style="display: none;">İŞ BİRLİĞİ</h4>
                        <h4 data-lang="en">EXCELLENCE</h4>
                        <h4 data-lang="tr" style="display: none;">MÜKEMMELLİK</h4>
                    </div>
                </div>
                <div id="about-us">
                    <img src="https://ssir.org/images/blog/Emma-Proud-Benjamin-Kumpf-Innovation-592x333.jpg" alt="Innovation Image">
                    <div id="about-us-in">
                        <h3 data-lang="en">ABOUT US</h3>
                        <h3 data-lang="tr" style="display: none;">HAKKIMIZDA</h3>
                        <p data-lang="en">
                            Welcome to Open Forge, the platform where students and alumni unite to showcase their academic and personal projects. Our mission is to foster collaboration, inspire, and create a space for sharing knowledge. Join our vibrant community to explore, connect, and contribute to the collective learning journey.
                        </p>
                        <p data-lang="tr" style="display: none;">
                            Open Forge'a hoş geldiniz! Öğrenciler ve mezunların akademik ve kişisel projelerini sergilemek için bir araya geldiği platform. Misyonumuz, iş birliğini teşvik etmek, ilham vermek ve bilgi paylaşımı için bir alan yaratmaktır. Keşfetmek, bağlanmak ve kolektif öğrenme yolculuğuna katkıda bulunmak için canlı topluluğumuza katılın.
                        </p>
                    </div>
                    <img src="https://a.storyblok.com/f/99519/1000x565/092c6d12d4/creativity-1__1_.jpg/m/1600x904/filters:format(webp)" alt="Creativity Image">
                </div>
                <div id="cards-container">
                    <div class="card" id="card1">
                        <div class="overlay">
                            <h4 data-lang="en">SHOWCASE</h4>
                            <h4 data-lang="tr" style="display: none;">SERGİLE</h4>
                            <p data-lang="en">
                                Highlight the talent and achievements of present students and alumni by providing a dedicated space to showcase their academic and personal projects.
                            </p>
                            <p data-lang="tr" style="display: none;">
                                Mevcut öğrencilerin ve mezunların yeteneklerini ve başarılarını, akademik ve kişisel projelerini sergilemek için özel bir alan sağlayarak vurgulayın.
                            </p>
                        </div>
                    </div>
                    <div class="card" id="card2">
                        <div class="overlay">
                            <h4 data-lang="en">INSPIRE</h4>
                            <h4 data-lang="tr" style="display: none;">İLHAM VER</h4>
                            <p data-lang="en">
                                Inspire others with the innovative and creative work of your community. Share success stories and unique projects to motivate current and future students.
                            </p>
                            <p data-lang="tr" style="display: none;"> 
                                Topluluğunuzun yenilikçi ve yaratıcı çalışmalarıyla başkalarına ilham verin. Başarı hikayelerini ve benzersiz projeleri paylaşarak mevcut ve gelecekteki öğrencileri motive edin.
                            </p>
                        </div>
                    </div>
                    <div class="card" id="card3">
                        <div class="overlay">
                            <h4 data-lang="en">CONNECT</h4>
                            <h4 data-lang="tr" style="display: none;">BAĞLAN</h4>
                            <p data-lang="en">
                                Foster a sense of community by encouraging connections between present students and alumni. Provide a platform where they can interact, share experiences, and collaborate.
                            </p>
                            <p data-lang="tr" style="display: none;">
                                Mevcut öğrenciler ve mezunlar arasında bağlantıları teşvik ederek bir topluluk duygusu oluşturun. Etkileşimde bulunabilecekleri, deneyimlerini paylaşabilecekleri ve iş birliği yapabilecekleri bir platform sağlayın.
                            </p>
                        </div>
                    </div>
                </div>
                <div id="green-div">
                    <img src="https://eiwgew27fhz.exactdn.com/wp-content/themes/puttosaurus/img/dots-side.svg" alt="" />
                    <h4 data-lang="en">
                        SIGN UP FOR OPEN FORGE NEWS AND SPECIAL OFFERS STRAIGHT TO YOUR INBOX
                    </h4>
                    <h4 data-lang="tr" style="display: none;">
                        OPEN FORGE HABERLERİ VE ÖZEL TEKLİFLERİ İÇİN KAYDOLUN
                    </h4>
                    <img src="https://eiwgew27fhz.exactdn.com/wp-content/themes/puttosaurus/img/dots-side.svg" alt="" />
                </div>
            </div>
            <div id="page3">
                <p data-lang="en">
                    Dive into a tapestry of projects on our platform, where present students converge to share their stories. A space crafted for inspiration, connection, and celebration of diverse endeavors.
                </p>
                <p data-lang="tr" style="display: none;">
                    Platformumuzda, mevcut öğrencilerin hikayelerini paylaştığı projelerin dokusuna dalın. İlham, bağlantı ve çeşitli çabaların kutlanması için tasarlanmış bir alan.
                </p>
                <img id="colon1" src="https://eiwgew27fhz.exactdn.com/wp-content/themes/puttosaurus/img/quote-left.svg" alt="" />
                <img id="colon2" src="https://eiwgew27fhz.exactdn.com/wp-content/themes/puttosaurus/img/quote-right.svg" alt="" />
            </div>
            <div id="page4">
                <h1 data-lang="en">WHAT ARE YOU WAITING FOR?</h1>
                <h1 data-lang="tr" style="display: none;">NE BEKLİYORSUN?</h1>
                <div class="elem">
                    <h2 data-lang="en">LEARN</h2>
                    <h2 data-lang="tr" style="display: none;">ÖĞREN</h2>
                </div>
                <div class="elem">
                    <h2 data-lang="en">UPLOAD</h2>
                    <h2 data-lang="tr" style="display: none;">YÜKLE</h2>
                </div>
                <div class="elem">
                    <h2 data-lang="en">REPEAT</h2>
                    <h2 data-lang="tr" style="display: none;">TEKRARLA</h2>
                </div>
            </div>
            <div id="footer">
                <img src="https://eiwgew27fhz.exactdn.com/wp-content/themes/puttosaurus/img/dots-footer.svg" alt="" />
                <div id="f1">
                    <img src="" alt="" />
                </div>
                <div id="f2">
                    <a href="#page1">
                        <h3 data-lang="en">HOME</h3>
                        <h3 data-lang="tr" style="display: none;">ANA SAYFA</h3>
                    </a>
                    <a href="FAQs.html">
                        <h3 data-lang="en">FAQs</h3>
                        <h3 data-lang="tr" style="display: none;">SSS</h3>
                    </a>
                    <h3 data-lang="en">CONTACT US: support@yourplatform.com</h3>
                    <h3 data-lang="tr" style="display: none;">BİZE ULAŞIN: support@yourplatform.com</h3>
                    <h3 data-lang="en">TEL NO: 27265</h3>
                    <h3 data-lang="tr" style="display: none;">TELEFON NO: 27265</h3>
                </div>
                <div id="f4">
                    <h4 data-lang="en">
                        A20, SIDCUP BYPASS <br />
                        CHISLEHURST <br />
                        KENT <br />
                        BR7 6RP <br />
                        TEL: 0208 309 0181 <br />
                        GET DIRECTIONS <br />
                    </h4>
                    <h4 data-lang="tr" style="display: none;">
                        A20, SIDCUP BYPASS <br />
                        CHISLEHURST <br />
                        KENT <br />
                        BR7 6RP <br />
                        TEL: 0208 309 0181 <br />
                        YOL TARİFİ AL <br />
                    </h4>
                </div>
            </div>
        </div>
        <script>
            // Sayfa yüklendiğinde localStorage'dan dil değerini oku ve uygulamayı başlat
            document.addEventListener('DOMContentLoaded', () => {
                const languageSelector = document.getElementById('language');
                const savedLanguage = localStorage.getItem('language') || 'en';
                languageSelector.value = savedLanguage;
                changeLanguage(savedLanguage);

                languageSelector.addEventListener('change', (event) => {
                    const selectedLanguage = event.target.value;
                    localStorage.setItem('language', selectedLanguage);
                    changeLanguage(selectedLanguage);
                });
            });

            function changeLanguage(lang) {
                document.querySelectorAll('[data-lang]').forEach(element => {
                    if (element.getAttribute('data-lang') === lang) {
                        element.style.display = 'block';
                    } else {
                        element.style.display = 'none';
                    }
                });
            }
        </script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.1/gsap.min.js" integrity="sha512-qF6akR/fsZAB4Co1QDDnUXWnaQseLGXoniuSuSlPQK6+aWhlMZcHzkasCSlnWoe+TJuudlka1/IQ01Dnhgq95g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.1/ScrollTrigger.min.js" integrity="sha512-IHDCHrefnBT3vOCsvdkMvJF/MCPz/nBauQLzJkupa4Gn4tYg5a6VGyzIrjo6QAUy3We5HFOZUlkUpP0dkgE60A==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="script.js"></script>
    </body>
</html>
