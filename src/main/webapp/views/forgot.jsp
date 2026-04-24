<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Forgot Password</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>

<body class="bg-light">
<%@ include file="/views/layout/header.jsp" %>

<div class="container mt-5" style="max-width:400px;">
    <h3 class="text-center mb-3">Forgot Password</h3>

    <form method="post" action="${pageContext.request.contextPath}/forgot-pass" onsubmit="return validateForm()">

        <div class="mb-3">
            <input name="email" class="form-control" placeholder="Email" required>
        </div>

        <div class="mb-3">
            <div class="input-group">
                <input type="password" name="newpass" id="newpass" class="form-control" placeholder="New Password" required>
                <span class="input-group-text" id="toggleNewPass" style="cursor:pointer;">
                    <i class="bi bi-eye-slash" id="eyeIcon1"></i>
                </span>
            </div>
        </div>

        <div class="mb-3">
            <div class="input-group">
                <input type="password" name="confirmpass" id="confirmpass" class="form-control" placeholder="Confirm Password" required>
                <span class="input-group-text" id="toggleConfirmPass" style="cursor:pointer;">
                    <i class="bi bi-eye-slash" id="eyeIcon2"></i>
                </span>
            </div>
        </div>

        <button class="btn btn-primary w-100 mb-3">Update Password</button>

        <div class="text-center">
            <small><a href="${pageContext.request.contextPath}/login">Back to Login</a></small>
        </div>
    </form>

    <p class="text-success text-center">${msg}</p>
    <p class="text-danger text-center">${error}</p>
</div>

<script>
    function toggle(idInput, idIcon) {
        let input = document.getElementById(idInput);
        let icon = document.getElementById(idIcon);

        let type = input.type === "password" ? "text" : "password";
        input.type = type;

        icon.classList.toggle("bi-eye");
        icon.classList.toggle("bi-eye-slash");
    }

    document.getElementById("toggleNewPass").onclick = () => toggle("newpass", "eyeIcon1");
    document.getElementById("toggleConfirmPass").onclick = () => toggle("confirmpass", "eyeIcon2");

    function validateForm() {
        let p1 = document.getElementById("newpass").value;
        let p2 = document.getElementById("confirmpass").value;

        if (p1 !== p2) {
            alert("Mật khẩu không khớp!");
            return false;
        }
        return true;
    }
</script>

</body>
</html>