<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Thông tin cá nhân</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f0f4f2; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }

        .profile-wrapper {
            max-width: 900px;
            margin: 50px auto;
            padding: 0 20px;
        }

        .profile-header {
            background: linear-gradient(135deg, #006644, #00a86b);
            border-radius: 12px 12px 0 0;
            padding: 35px 40px;
            color: white;
            display: flex;
            align-items: center;
            gap: 25px;
        }

        .avatar-circle {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            background: rgba(255,255,255,0.25);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            color: white;
            border: 3px solid rgba(255,255,255,0.6);
            flex-shrink: 0;
        }

        .profile-header-info h4 {
            margin: 0 0 5px 0;
            font-size: 1.5rem;
            font-weight: 700;
        }

        .profile-header-info span {
            font-size: 0.9rem;
            opacity: 0.85;
        }

        .profile-card {
            background: white;
            border-radius: 0 0 12px 12px;
            padding: 40px 40px 35px;
            border: 1px solid #dee2e6;
            border-top: none;
            box-shadow: 0 6px 24px rgba(0,0,0,0.08);
        }

        .section-label {
            font-size: 0.78rem;
            font-weight: 600;
            color: #888;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            margin-bottom: 6px;
        }

        .info-field {
            background: #f8faf9;
            border: 1.5px solid #e0e7e3;
            border-radius: 8px;
            padding: 12px 16px;
            font-size: 1rem;
            color: #212529;
            width: 100%;
            transition: border-color 0.2s, background 0.2s;
        }

        .info-field:focus {
            outline: none;
            border-color: #006644;
            background: #fff;
            box-shadow: 0 0 0 3px rgba(0,102,68,0.1);
        }

        .info-field:disabled {
            background: #f8faf9;
            color: #495057;
            cursor: default;
            border-color: #e0e7e3;
        }

        .password-wrapper {
            position: relative;
        }

        .password-wrapper .info-field {
            padding-right: 48px;
        }

        .btn-eye {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #6c757d;
            font-size: 1rem;
            cursor: pointer;
            padding: 4px 6px;
            line-height: 1;
            transition: color 0.2s;
        }

        .btn-eye:hover { color: #006644; }

        .divider {
            border: none;
            border-top: 1.5px solid #f0f0f0;
            margin: 30px 0;
        }

        .btn-edit {
            background: #fff3cd;
            color: #856404;
            border: 1.5px solid #ffc107;
            border-radius: 8px;
            padding: 10px 28px;
            font-weight: 600;
            transition: 0.2s;
        }

        .btn-edit:hover { background: #ffe69c; }

        .btn-save {
            background-color: #006644;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 10px 28px;
            font-weight: 600;
            transition: 0.2s;
        }

        .btn-save:hover { background-color: #004d33; color: white; }

        .field-icon {
            color: #006644;
            margin-right: 8px;
            width: 18px;
        }

        .info-field.is-invalid {
            border-color: #dc3545 !important;
            background-color: #fff8f8;
        }
    </style>
</head>
<body>

<%@ include file="/views/layout/header.jsp" %>
<%@ include file="/views/layout/navbar.jsp" %>

<div class="profile-wrapper">

    <!-- Header banner -->
    <div class="profile-header">
        <div class="avatar-circle">
            <i class="fa-solid fa-user"></i>
        </div>
        <div class="profile-header-info">
            <h4>${item.fullName}</h4>
            <span><i class="fa-solid fa-envelope me-1"></i>${item.email}</span>
        </div>
    </div>

    <!-- Profile card -->
    <div class="profile-card">

        <c:if test="${not empty message}">
            <div class="alert alert-success alert-dismissible fade show mb-4" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i>${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <form action="ProfileServlet" method="POST" id="profileForm">
            <div class="row g-4">

                <!-- Họ & tên -->
                <div class="col-md-6">
                    <div class="section-label">
                        <i class="fa-solid fa-id-card field-icon"></i>Họ &amp; tên
                    </div>
                    <input type="text" class="info-field view-mode" name="fullname"
                           value="${item.fullName}" disabled required>
                </div>

                <!-- Số điện thoại -->
                <div class="col-md-6">
                    <div class="section-label">
                        <i class="fa-solid fa-phone field-icon"></i>Số điện thoại
                    </div>
                    <input type="text" class="info-field view-mode" name="phone"
                           value="${item.phone}" disabled
                           pattern="^0[35789][0-9]{8}$"
                           title="Số điện thoại phải gồm 10 chữ số">
                </div>

                <!-- Email -->
                <div class="col-md-6">
                    <div class="section-label">
                        <i class="fa-solid fa-envelope field-icon"></i>Email
                    </div>
                    <input type="email" class="info-field view-mode" name="email"
                           value="${item.email}" disabled required
                           title="Vui lòng nhập đúng định dạng email">
                </div>

                <!-- Mật khẩu + nút xem -->
                <div class="col-md-6">
                    <div class="section-label">
                        <i class="fa-solid fa-lock field-icon"></i>Mật khẩu
                    </div>
                    <div class="password-wrapper">
                        <input type="password" class="info-field view-mode" name="password"
                               id="passwordField" value="${item.password}" disabled required>
                        <button type="button" class="btn-eye" id="btnTogglePassword" title="Xem/ẩn mật khẩu">
                            <i class="fa-solid fa-eye" id="eyeIcon"></i>
                        </button>
                    </div>
                </div>

            </div>

            <hr class="divider">

            <div class="d-flex justify-content-end gap-2">
                <button type="button" id="btnEdit" class="btn btn-edit">
                    <i class="fa-solid fa-pen me-1"></i> Chỉnh sửa
                </button>
                <button type="submit" id="btnSave" class="btn btn-save d-none">
                    <i class="fa-solid fa-floppy-disk me-1"></i> Lưu thay đổi
                </button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Toggle edit mode
    const btnEdit = document.getElementById('btnEdit');
    const btnSave = document.getElementById('btnSave');
    const inputs  = document.querySelectorAll('.view-mode');

    btnEdit.addEventListener('click', function () {
        btnEdit.classList.add('d-none');
        btnSave.classList.remove('d-none');
        inputs.forEach(input => input.removeAttribute('disabled'));
        inputs[0].focus();
    });

    // Toggle password visibility
    const btnToggle = document.getElementById('btnTogglePassword');
    const pwField   = document.getElementById('passwordField');
    const eyeIcon   = document.getElementById('eyeIcon');

    btnToggle.addEventListener('click', function () {
        const isHidden = pwField.type === 'password';
        pwField.type   = isHidden ? 'text' : 'password';
        eyeIcon.classList.toggle('fa-eye',      !isHidden);
        eyeIcon.classList.toggle('fa-eye-slash', isHidden);
    });

    // Thêm đoạn này vào cuối thẻ <script> của bạn
    const profileForm = document.getElementById('profileForm');

    profileForm.addEventListener('submit', function (e) {
        const emailInput = document.querySelector('input[name="email"]');
        const phoneInput = document.querySelector('input[name="phone"]');

        // 1. Định dạng Email: Chuẩn cơ bản
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        // 2. Định dạng SĐT Việt Nam: 10 số, bắt đầu bằng số 0 (ví dụ: 09, 03, 08...)
        const phoneRegex = /^(0[3|5|7|8|9])([0-9]{8})$/;

        let isValid = true;
        let errorMessage = "";

        // Kiểm tra Email
        if (!emailRegex.test(emailInput.value)) {
            errorMessage += "Email không đúng định dạng (ví dụ: abc@gmail.com).\n";
            emailInput.classList.add('is-invalid'); // Thêm viền đỏ của Bootstrap
            isValid = false;
        } else {
            emailInput.classList.remove('is-invalid');
        }

        // Kiểm tra Số điện thoại
        if (phoneInput.value && !phoneRegex.test(phoneInput.value)) {
            errorMessage += "Số điện thoại phải có 10 chữ số và bắt đầu bằng đầu số hợp lệ (03, 05, 07, 08, 09).";
            phoneInput.classList.add('is-invalid');
            isValid = false;
        } else {
            phoneInput.classList.remove('is-invalid');
        }

        if (!isValid) {
            alert(errorMessage);
            e.preventDefault(); // Ngăn chặn gửi form
        }
    });
</script>
</body>
</html>
