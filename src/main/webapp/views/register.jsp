<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Register</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>

<body class="bg-light">
<%@ include file="/views/layout/header.jsp" %>

<div class="container mt-5" style="max-width:400px;">
    <h3 class="text-center mb-3">Register</h3>

    <form method="post" action="${pageContext.request.contextPath}/register">

        <div class="mb-3">
            <input name="fullname" class="form-control" placeholder="Full Name" required>
        </div>

        <div class="mb-3">
            <input name="email" class="form-control" placeholder="Email" required>
        </div>

        <div class="mb-3">
            <div class="input-group">
                <input type="password" name="password" id="password" class="form-control" placeholder="Password" required>
                <span class="input-group-text" id="togglePassword" style="cursor:pointer;">
                    <i class="bi bi-eye-slash" id="eyeIcon"></i>
                </span>
            </div>
        </div>

        <button class="btn btn-primary w-100 mb-3">Register</button>

        <div class="text-center">
            <small>Đã có tài khoản?
                <a href="${pageContext.request.contextPath}/login">Login</a>
            </small>
        </div>
    </form>

    <p class="text-danger mt-3 text-center">${error}</p>
</div>

<script>
    const togglePassword = document.querySelector('#togglePassword');
    const password = document.querySelector('#password');
    const eyeIcon = document.querySelector('#eyeIcon');

    togglePassword.addEventListener('click', function () {
        const type = password.type === 'password' ? 'text' : 'password';
        password.type = type;
        eyeIcon.classList.toggle('bi-eye');
        eyeIcon.classList.toggle('bi-eye-slash');
    });
</script>

</body>
</html>