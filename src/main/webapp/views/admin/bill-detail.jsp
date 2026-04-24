<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, com.polycoffee.Entity.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
Bill bill = (Bill) request.getAttribute("bill");
List<BillDetail> details = (List<BillDetail>) request.getAttribute("details");
%>

<jsp:include page="/views/layout/header.jsp"/>
<jsp:include page="/views/layout/navbar.jsp"/>

<div class="container mt-5">

    <h2 class="mb-4 fw-bold text-center"> Chi tiết hóa đơn</h2>

    <!-- BILL INFO -->
    <div class="card shadow border-0 mb-4">
        <div class="card-body row text-center">

            <div class="col-md-3">
                <p class="text-muted mb-1">Mã đơn</p>
                <h5 class="fw-bold text-primary"><%= bill.getCode() %></h5>
            </div>

            <div class="col-md-3">
                <p class="text-muted mb-1">Phương thức thanh toán</p>
                <h5 class="fw-bold text-primary"><%= bill.getPayment_Method() != null ? bill.getPayment_Method() : "Tiền mặt" %></h5>
            </div>

            <div class="col-md-3">
                <p class="text-muted mb-1">Nhân viên</p>
                <h5 class="fw-bold"><%= bill.getFullName() %></h5>
            </div>

            <div class="col-md-3">
                <p class="text-muted mb-1">Ngày tạo</p>
                <h6>
                    <fmt:formatDate value="${bill.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                </h6>
            </div>

            <div class="col-md-3">
                <p class="text-muted mb-1">Tổng tiền</p>
                <h5 class="fw-bold text-success">
                    <%= String.format("%,d", bill.getTotal()) %> ₫
                </h5>
            </div>

        </div>

        <div class="text-center pb-3">
            <% if (bill.getStatus() == 0) { %>
                <span class="badge bg-warning text-dark px-4 py-2">Waiting</span>
            <% } else if (bill.getStatus() == 1) { %>
                <span class="badge bg-success px-4 py-2">Done</span>
            <% } else { %>
                <span class="badge bg-danger px-4 py-2">Cancel</span>
            <% } %>
        </div>
    </div>

    <!-- TABLE -->
    <div class="card shadow border-0">
        <div class="card-body p-0">

            <table class="table table-hover text-center align-middle mb-0">
                <thead class="table-dark">
                <tr>
                    <th>Sản phẩm</th>
                    <th>Số lượng</th>
                    <th>Đơn giá</th>
                    <th>Thành tiền</th>
                </tr>
                </thead>

                <tbody>
                <% for (BillDetail d : details) { %>
                <tr>
                    <td class="fw-semibold"><%= d.getDrinkName() %></td>
                    <td><%= d.getQuantity() %></td>

                    <td class="text-primary">
                        <%= String.format("%,d", d.getPrice()) %> ₫
                    </td>

                    <td class="text-success fw-bold">
                        <%= String.format("%,d", d.getQuantity() * d.getPrice()) %> ₫
                    </td>
                </tr>
                <% } %>
                </tbody>

            </table>
        </div>
    </div>

    <div class="text-center mt-4">
        <a href="bill" class="btn btn-outline-secondary px-4">
             Quay lại
        </a>
    </div>

</div>

<jsp:include page="/views/layout/footer.jsp"/>