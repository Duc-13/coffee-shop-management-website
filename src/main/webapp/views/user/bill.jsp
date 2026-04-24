<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, com.polycoffee.Entity.Bill" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<% List<Bill> list = (List<Bill>) request.getAttribute("list"); %>

<jsp:include page="/views/layout/header.jsp"/>
<jsp:include page="/views/layout/navbar.jsp"/>

<style>

    .card-no-jump {
        transition: none !important;
        box-shadow: none !important;
    }
    .card-no-jump:hover {
        transform: none !important;
        box-shadow: none !important;
        cursor: default !important;
    }


    .clickable-row {
        cursor: pointer;
        transition: background-color 0.2s ease;
    }
    .clickable-row:hover {
        background-color: #e9ecef !important;
    }
</style>

<div class="container mt-5">
    <h3 class="mb-4 text-center fw-bold text-primary"><i class="bi bi-clock-history"></i> LỊCH SỬ ĐƠN HÀNG</h3>

    <% if (list == null || list.isEmpty()) { %>
        <div class="alert alert-warning text-center">
            Bạn chưa có đơn hàng nào. Hãy ra Menu để đặt món nhé!
        </div>
    <% } else { %>

    <div class="card border-0 card-no-jump">
        <div class="card-body p-0">
            <table class="table align-middle text-center mb-0">
                <thead class="table-dark">
                <tr>
                    <th>Mã đơn</th>
                    <th>Ngày đặt</th>
                    <th>Tổng tiền</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                <% for (Bill b : list) { %>

                <tr class="clickable-row" onclick="window.location.href='bill?action=detail&id=<%= b.getBillsId() %>'">

                    <td class="fw-bold text-primary"><%= b.getCode() %></td>

                    <td class="text-muted">
                        <fmt:formatDate value="<%= b.getCreatedAt() %>" pattern="dd/MM/yyyy HH:mm"/>
                    </td>

                    <td class="fw-bold text-success"><%= String.format("%,d", b.getTotal()) %> ₫</td>

                    <td>
                        <% if (b.getStatus() == 0) { %>
                            <span class="badge bg-warning text-dark px-3 py-2">Đang chờ xử lý</span>
                        <% } else if (b.getStatus() == 1) { %>
                            <span class="badge bg-success px-3 py-2">Đã hoàn thành</span>
                        <% } else { %>
                            <span class="badge bg-danger px-3 py-2">Đã hủy</span>
                        <% } %>
                    </td>

                    <td>
                        <a href="bill?action=detail&id=<%= b.getBillsId() %>" class="btn btn-outline-info btn-sm">
                            <i class="bi bi-eye"></i> Xem biên lai
                        </a>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
    <% } %>
</div>

<jsp:include page="/views/layout/footer.jsp"/>