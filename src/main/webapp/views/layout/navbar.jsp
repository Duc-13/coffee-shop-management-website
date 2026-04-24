<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.polycoffee.Entity.User" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
String path = request.getContextPath();
User u = (User) session.getAttribute("user");
%>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

<style>
    .navbar-custom {
        background: rgba(0, 0, 0, 0.55);
        backdrop-filter: blur(10px);
        position: absolute;
        width: 100%;
        z-index: 1000;
    }

    .nav-link-custom {
        color: white;
        margin-right: 15px;
        text-decoration: none;
        padding: 6px 12px;
        border-radius: 6px;
        transition: 0.3s;
    }

    .nav-link-custom:hover {
        background-color: #ffc107;
        color: black;
        transform: translateY(-2px);
    }

    .cart-badge {
        background: red;
        font-size: 11px;
        padding: 2px 6px;
        border-radius: 50%;
        margin-left: 4px;
    }

    .dropdown-toggle:hover {
        background-color: #ffc107 !important;
        color: black !important;
    }

    .dropdown-item:hover {
        background-color: #f8f9fa;
        color: #0d6efd;
        padding-left: 1.5rem;
    }

    @media (min-width: 992px) {
        .dropdown:hover .dropdown-menu {
            display: block;
        }
    }

    .dropdown-menu {
        animation: fadeIn 0.3s;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }
</style>

<nav class="navbar navbar-expand-lg bg-primary px-3 shadow">

    <!-- LOGO -->
    <a class="navbar-brand text-white fw-bold"
       href="<%= (u != null && u.getRole() == 0) ? path + "/admin" : path + "/home" %>">
        PolyCoffee
    </a>

    <!-- MENU -->
    <div class="ms-3 d-flex align-items-center flex-wrap">
        <% if (u != null) { %>

            <% if (u.getRole() == 0) { %>
                <a href="<%=path%>/category" class="nav-link-custom">Category</a>
                <a href="<%=path%>/drink" class="nav-link-custom">Drink</a>
                <a href="<%=path%>/staff" class="nav-link-custom">Staff</a>
                <a href="<%=path%>/bill" class="nav-link-custom">Bill</a>
            <% } %>

            <% if (u.getRole() == 1) { %>
                <a href="<%=path%>/drink" class="nav-link-custom">Drink</a>
                <a href="<%=path%>/bill" class="nav-link-custom">Bill</a>
            <% } %>

            <% if (u.getRole() == 2) { %>
                <a href="<%=path%>/drink" class="nav-link-custom">Menu</a>
                <a href="<%=path%>/bill" class="nav-link-custom">My Bill</a>

                <a href="<%=path%>/cart" class="nav-link-custom">
                    🛒
                    <span class="cart-badge">
                        <%= session.getAttribute("cartCount") == null ? 0 : session.getAttribute("cartCount") %>
                    </span>
                </a>
            <% } %>

        <% } %>
    </div>

    <!-- RIGHT SIDE -->
    <div class="ms-auto d-flex align-items-center">

        <% if (u != null) { %>
        <div class="dropdown">
            <a class="btn btn-warning btn-sm dropdown-toggle shadow-sm" data-bs-toggle="dropdown">
                <i class="bi bi-person-circle"></i>
                <%= u.getFullName() %>
            </a>

            <ul class="dropdown-menu dropdown-menu-end shadow border-0">
                <li>
                    <a class="dropdown-item" href="<%=path%>/ProfileServlet">
                        <i class="bi bi-person"></i> Trang cá nhân
                    </a>
                </li>
                <li><hr class="dropdown-divider"></li>
                <li>
                    <a class="dropdown-item text-danger" href="#" onclick="confirmLogout()">
                        <i class="bi bi-box-arrow-right"></i> Đăng xuất
                    </a>
                </li>
            </ul>
        </div>
        <% } else { %>
            <a href="<%=path%>/login" class="btn btn-light btn-sm">Đăng nhập</a>
        <% } %>
    </div>
</nav>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function confirmLogout() {
        if (confirm("Bạn có chắc chắn muốn đăng xuất không?")) {
            window.location.href = "<%=path%>/logout";
        }
    }
</script>