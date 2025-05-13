<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Yönetici Paneli - Giriş / Kayıt</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">

    <style>
        :root{
            --primary:#4e73df; --secondary:#f8f9fc; --accent:#2e59d9; --text:#5a5c69;
        }
        body{background:var(--secondary);color:var(--text);height:100vh;display:flex;align-items:center}
        .auth-container{max-width:1000px;margin:auto;border-radius:15px;overflow:hidden;
                        box-shadow:0 4px 20px rgba(0,0,0,.1)}
        .auth-left{background:linear-gradient(135deg,var(--primary),var(--accent));color:#fff;
                   padding:4rem;display:flex;flex-direction:column;justify-content:center}
        .auth-right{background:#fff;padding:4rem}
        .auth-title{font-weight:700;margin-bottom:1.5rem}
        .auth-description{opacity:.9;margin-bottom:2rem}
        .auth-features{list-style:none;padding:0}
        .auth-features li{margin-bottom:1rem;display:flex;align-items:center}
        .auth-features i{margin-right:10px;font-size:1.2rem}
        .nav-tabs{border-bottom:none;margin-bottom:2rem;justify-content:center}
        .nav-tabs .nav-link{border:none;color:var(--text);font-weight:600;padding:.75rem 1.5rem;
                            margin:0 .5rem;border-radius:50px}
        .nav-tabs .nav-link.active{background:var(--primary);color:#fff}
        .form-floating label{color:#6c757d}
        .form-control:focus{border-color:var(--primary);
                            box-shadow:0 0 0 .25rem rgba(78,115,223,.25)}
        .btn-primary{background:var(--primary);border-color:var(--primary);padding:.75rem;font-weight:600}
        .btn-primary:hover{background:var(--accent);border-color:var(--accent)}
        .auth-footer{text-align:center;margin-top:2rem;font-size:.9rem;color:#6c757d}
        .alert{border-radius:8px}
    </style>
</head>
<body>
<div class="container">
  <div class="row auth-container">

    <!-- SOL alan -->
    <div class="col-md-6 auth-left d-none d-md-block">
        <h1 class="auth-title">Yönetici Paneline Hoş Geldiniz</h1>
        <p  class="auth-description">
            Sistem yöneticileri için gelişmiş kontrol paneli. Kayıt olarak hemen
            başlayabilir ya da zaten hesabınız varsa giriş yapabilirsiniz.
        </p>
        <ul class="auth-features">
            <li><i class="bi bi-check-circle-fill"></i> Kolay ve hızlı yönetim</li>
            <li><i class="bi bi-check-circle-fill"></i> Güvenli erişim kontrolü</li>
            <li><i class="bi bi-check-circle-fill"></i> Gerçek zamanlı veri analizi</li>
            <li><i class="bi bi-check-circle-fill"></i> Responsive tasarım</li>
        </ul>
    </div>

    <!-- SAĞ alan -->
    <div class="col-md-6 auth-right">

      <!-- MESAJLAR -->
      <%-- loginError --%>
      <% if(request.getParameter("loginError") != null){ %>
         <div class="alert alert-danger alert-dismissible fade show" role="alert">
             Hatalı email veya şifre!
             <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
         </div>
      <% } %>

      <%-- registerError --%>
      <% if(request.getParameter("registerError") != null){ %>
         <div class="alert alert-danger alert-dismissible fade show" role="alert">
             Kayıt sırasında hata! Email zaten kullanımda olabilir.
             <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
         </div>
      <% } %>

      <%-- registerSuccess --%>
      <% if(request.getParameter("registerSuccess") != null){ %>
         <div class="alert alert-success alert-dismissible fade show" role="alert">
             Kayıt başarılı! Artık giriş yapabilirsiniz.
             <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
         </div>
      <% } %>

      <%-- logout --%>
      <% if(request.getParameter("logout") != null){ %>
         <div class="alert alert-info alert-dismissible fade show" role="alert">
             Başarıyla çıkış yaptınız.
             <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
         </div>
      <% } %>

      <!-- TAB menü -->
      <ul class="nav nav-tabs" id="authTabs" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active" id="login-tab" data-bs-toggle="tab"
                    data-bs-target="#login" type="button" role="tab"> <i class="bi bi-box-arrow-in-right me-1"></i> Giriş Yap </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="register-tab" data-bs-toggle="tab"
                    data-bs-target="#register" type="button" role="tab"> <i class="bi bi-person-plus me-1"></i> Kayıt Ol </button>
        </li>
      </ul>

      <!-- TAB içerikleri -->
      <div class="tab-content" id="authTabsContent">
        <!-- GİRİŞ -->
        <div class="tab-pane fade show active" id="login" role="tabpanel">
          <form action="AdminServlet" method="post">
              <input type="hidden" name="action" value="login">
              <div class="form-floating mb-3">
                  <input type="email" class="form-control" id="loginEmail" name="email"
                         placeholder="Email" required>
                  <label for="loginEmail">Email</label>
              </div>
              <div class="form-floating mb-4">
                  <input type="password" class="form-control" id="loginPassword" name="password"
                         placeholder="Şifre" required>
                  <label for="loginPassword">Şifre</label>
              </div>
              <button type="submit" class="btn btn-primary w-100 mb-3">Giriş Yap</button>
          </form>
        </div>

        <!-- KAYIT -->
        <div class="tab-pane fade" id="register" role="tabpanel">
          <form action="AdminServlet" method="post">
              <input type="hidden" name="action" value="register">
              <div class="form-floating mb-3">
                  <input type="text" class="form-control" id="regFull" name="fullName"
                         placeholder="Ad Soyad" required>
                  <label for="regFull">Ad Soyad</label>
              </div>
              <div class="form-floating mb-3">
                  <input type="email" class="form-control" id="regEmail" name="email"
                         placeholder="Email" required>
                  <label for="regEmail">Email</label>
              </div>
              <div class="form-floating mb-4">
                  <input type="password" class="form-control" id="regPwd" name="password"
                         placeholder="Şifre" required>
                  <label for="regPwd">Şifre</label>
              </div>
              <button type="submit" class="btn btn-primary w-100">Kayıt Ol</button>
          </form>
        </div>
      </div>

      <div class="auth-footer">
          <p>© 2023 Yönetici Paneli. Tüm hakları saklıdır.</p>
      </div>
    </div><!-- auth-right -->
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
/* Kayıt sonrası sekmeyi aktif et */
document.addEventListener('DOMContentLoaded',()=>{
   const p=new URLSearchParams(window.location.search);
   if(p.has('registerError')||p.has('registerSuccess')){
        new bootstrap.Tab(document.getElementById('register-tab')).show();
   }
});
</script>
</body>
</html>
