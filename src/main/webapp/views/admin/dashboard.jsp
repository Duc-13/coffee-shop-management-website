<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - PolyCoffee</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="bg-light">

<%@ include file="/views/layout/header.jsp" %>
<%@ include file="/views/layout/navbar.jsp" %>

<div class="container mt-5">
    <div class="text-center">
        <h1 class="display-5 fw-bold text-dark">WELCOME TO ADMIN DASHBOARD</h1>
        <p class="lead text-muted">Hệ thống quản lý Cửa hàng Cà phê PolyCoffee</p>
    </div>

    <hr class="my-4">

    <div class="card shadow border-0 mb-4">
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/dashboard" method="get" class="row g-3 align-items-end">
                <div class="col-md-4">
                    <label class="form-label fw-bold">Từ ngày</label>
                    <input type="date" name="from" class="form-control" value="${param.from}">
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-bold">Đến ngày</label>
                    <input type="date" name="to" class="form-control" value="${param.to}">
                </div>
                <div class="col-md-4">
                    <button type="submit" class="btn btn-primary w-100 fw-bold">
                        <i class="bi bi-filter"></i> Lọc Thống Kê
                    </button>
                </div>
            </form>
        </div>
    </div>

    <div class="row justify-content-center g-4 mb-5">
        <div class="col-md-3">
            <div class="card text-white bg-primary h-100 shadow border-0">
                <div class="card-header fw-bold">DRINKS</div>
                <div class="card-body d-flex flex-column justify-content-between text-center">
                    <h5 class="card-title"><i class="bi bi-cup-hot fs-1"></i></h5>
                    <p class="card-text small">Quản lý kho đồ uống, giá cả.</p>
                    <a href="${pageContext.request.contextPath}/drink" class="btn btn-light btn-sm fw-bold mt-auto">Manage</a>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card text-white bg-success h-100 shadow border-0">
                <div class="card-header fw-bold">CATEGORIES</div>
                <div class="card-body d-flex flex-column justify-content-between text-center">
                    <h5 class="card-title"><i class="bi bi-tags fs-1"></i></h5>
                    <p class="card-text small">Quản lý loại đồ uống.</p>
                    <a href="${pageContext.request.contextPath}/category" class="btn btn-light btn-sm fw-bold mt-auto">Manage</a>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card text-white bg-warning h-100 shadow border-0">
                <div class="card-header fw-bold text-dark">STAFF</div>
                <div class="card-body d-flex flex-column justify-content-between text-dark text-center">
                    <h5 class="card-title"><i class="bi bi-people fs-1"></i></h5>
                    <p class="card-text small">Quản lý nhân viên & quyền.</p>
                    <a href="${pageContext.request.contextPath}/staff/index" class="btn btn-dark btn-sm fw-bold mt-auto">Manage</a>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card text-white bg-danger h-100 shadow border-0">
                <div class="card-header fw-bold">BILLS</div>
                <div class="card-body d-flex flex-column justify-content-between text-center">
                    <h5 class="card-title"><i class="bi bi-receipt fs-1"></i></h5>
                    <p class="card-text small">Quản lý hóa đơn bán hàng.</p>
                    <a href="${pageContext.request.contextPath}/bill" class="btn btn-light btn-sm fw-bold mt-auto">Manage</a>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-lg-6">
            <div class="card shadow border-0 h-100">
                <div class="card-header bg-dark text-white fw-bold">
                    <i class="bi bi-star-fill text-warning"></i> TOP 5 THỨC UỐNG BÁN CHẠY
                </div>
                <div class="card-body">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Tên món</th>
                                <th class="text-center">Số lượng</th>
                                <th class="text-end">Doanh thu</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${topDrinks}">
                                <tr>
                                    <td class="fw-bold">${item.drinkName}</td>
                                    <td class="text-center"><span class="badge bg-info text-dark">${item.totalQuantitySold}</span></td>
                                    <td class="text-end text-success fw-bold">
                                        <fmt:formatNumber value="${item.totalRevenue}" type="currency" currencySymbol="₫" />
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="col-lg-6">
            <div class="card shadow border-0 h-100">
                <div class="card-header bg-dark text-white fw-bold">
                    <i class="bi bi-bar-chart-line-fill text-info"></i> BIỂU ĐỒ DOANH THU THEO NGÀY
                </div>
                <div class="card-body">
                    <canvas id="revenueChart" style="min-height: 250px;"></canvas>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/views/layout/footer.jsp" %>

<script>
    const ctx = document.getElementById('revenueChart').getContext('2d');

    // Lấy dữ liệu từ Java gửi sang
    const labels = [
        <c:forEach var="r" items="${revenues}">
            '<fmt:formatDate value="${r.revenueDate}" pattern="dd/MM" />',
        </c:forEach>
    ];

    const dataRevenue = [
        <c:forEach var="r" items="${revenues}">
            ${r.totalRevenue},
        </c:forEach>
    ];

    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Doanh thu (VNĐ)',
                data: dataRevenue,
                borderColor: '#198754',
                backgroundColor: 'rgba(25, 135, 84, 0.1)',
                borderWidth: 3,
                fill: true,
                tension: 0.3
            }]
        },
        options: {
            responsive: true,
            scales: {
                y: { beginAtZero: true }
            }
        }
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>