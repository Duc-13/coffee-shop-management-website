<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, com.polycoffee.Entity.Bill" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    List<Bill> list = (List<Bill>) request.getAttribute("list");
    com.polycoffee.Entity.User currentUser = (com.polycoffee.Entity.User) session.getAttribute("user");
    String staffName = (currentUser != null) ? currentUser.getFullName() : "Nhân viên";
%>

<jsp:include page="/views/layout/header.jsp"/>
<jsp:include page="/views/layout/navbar.jsp"/>

<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold"><i class="bi bi-receipt-cutoff"></i> Đơn hàng bạn đã tạo</h2>
        <div class="text-end">
            <span class="badge bg-dark p-2 shadow-sm">
                <i class="bi bi-person-circle"></i> <%= staffName %>
            </span>
        </div>
    </div>

    <% if (list == null || list.isEmpty()) { %>
    <div class="alert alert-light text-center shadow-sm border">
        <i class="bi bi-cart-x fs-1 d-block mb-2 text-muted"></i>
        Bạn chưa tạo đơn hàng nào.
    </div>
    <% } else { %>

    <div class="card shadow-sm border-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0 text-center">
                <thead class="table-light text-secondary small text-uppercase">
                <tr>
                    <th>Mã đơn</th>
                    <th>Tổng tiền</th>
                    <th>Thanh toán</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <% for (Bill b : list) { %>
                <tr>
                    <td class="fw-bold text-primary">#<%= b.getCode() %></td>
                    <td class="fw-bold text-success"><%= String.format("%,d", b.getTotal()) %> ₫</td>
                    <td>
                        <%-- Hiển thị icon theo phương thức thanh toán --%>
                        <% if ("chuyenkhoan".equals(b.getPayment_Method())) { %>
                        <span class="badge bg-info-subtle text-info border border-info-subtle">
                                <i class="bi bi-bank"></i> Chuyển khoản
                            </span>
                        <% } else { %>
                        <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle">
                                <i class="bi bi-cash"></i> Tiền mặt
                            </span>
                        <% } %>
                    </td>
                    <td>
                        <% if (b.getStatus() == 0) { %>
                        <span class="badge bg-warning-subtle text-warning border border-warning-subtle rounded-pill">Chờ xử lý</span>
                        <% } else if (b.getStatus() == 1) { %>
                        <span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill">Hoàn thành</span>
                        <% } else { %>
                        <span class="badge bg-danger-subtle text-danger border border-danger-subtle rounded-pill">Đã hủy</span>
                        <% } %>
                    </td>
                    <td style="min-width: 250px;">
                        <div class="d-flex justify-content-center gap-2">
                            <a href="bill?action=detail&id=<%= b.getBillsId() %>"
                               class="btn btn-outline-info btn-sm px-3"
                               style="border-radius: 5px; font-weight: 500;">
                                Detail
                            </a>

                            <% if (b.getStatus() == 0) { // CHỈ HIỆN KHI ĐANG ĐỢI %>
                            <a href="bill?action=complete&id=<%= b.getBillsId() %>"
                               class="btn btn-outline-success btn-sm px-3"
                               style="border-radius: 5px; font-weight: 500;"
                               onclick="return confirm('Xác nhận hoàn thành đơn hàng #<%= b.getCode() %>?')">
                                Done
                            </a>

                            <a href="bill?action=cancel&id=<%= b.getBillsId() %>"
                               class="btn btn-outline-danger btn-sm px-3"
                               style="border-radius: 5px; font-weight: 500;"
                               onclick="return confirm('Bạn có chắc chắn muốn hủy đơn hàng #<%= b.getCode() %>?')">
                                Cancel
                            </a>
                            <% } else { %>
                            <%-- Hiển thị văn bản khi đã khóa trạng thái --%>
                            <% } %>
                        </div>
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