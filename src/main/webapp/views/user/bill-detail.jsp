<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, com.polycoffee.Entity.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
Bill bill = (Bill) request.getAttribute("bill");
List<BillDetail> details = (List<BillDetail>) request.getAttribute("details");
%>

<jsp:include page="/views/layout/header.jsp"/>
<jsp:include page="/views/layout/navbar.jsp"/>

<div class="container mt-5 mb-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow-lg border-0" style="border-top: 5px solid #0d6efd !important;">
                <div class="card-body p-5">
                    <div class="text-center mb-4">
                        <h2 class="fw-bold text-primary">POLY COFFEE</h2>
                        <p class="text-muted mb-0">Hóa đơn thanh toán</p>
                    </div>

                    <div class="row mb-4 border-bottom pb-3">
                        <div class="col-6">
                            <span class="text-muted d-block small">Mã hóa đơn:</span>
                            <span class="fw-bold"><%= bill.getCode() %></span>
                        </div>
                        <div class="col-6 text-end">
                            <span class="text-muted d-block small">Phương thức thanh toán:</span>
                            <span class="badge bg-info text-dark"><%= bill.getPayment_Method() != null ? bill.getPayment_Method() : "Tiền mặt" %>
        </span>
                        </div>
                        <div class="col-6 text-end">
                            <span class="text-muted d-block small">Ngày lập:</span>
                            <span class="fw-bold"><fmt:formatDate value="${bill.createdAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                        </div>
                    </div>

                    <div class="table-responsive mb-4">
                        <table class="table table-borderless align-middle mb-0">
                            <thead class="border-bottom">
                                <tr class="text-muted small text-uppercase">
                                    <th>Sản phẩm</th>
                                    <th class="text-center">SL</th>
                                    <th class="text-end">Thành tiền</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (BillDetail d : details) { %>
                                <tr>
                                    <td class="fw-semibold"><%= d.getDrinkName() %> <br>
                                        <small class="text-muted"><%= String.format("%,d", d.getPrice()) %> ₫</small>
                                    </td>
                                    <td class="text-center">x<%= d.getQuantity() %></td>
                                    <td class="text-end fw-bold"><%= String.format("%,d", d.getQuantity() * d.getPrice()) %> ₫</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>

                    <div class="p-3 bg-light rounded-3 d-flex justify-content-between align-items-center mb-4">
                        <span class="text-uppercase fw-bold text-muted">Tổng thanh toán:</span>
                        <h4 class="fw-bold text-success mb-0"><%= String.format("%,d", bill.getTotal()) %> ₫</h4>
                    </div>

                    <div class="text-center">
                        <p class="small text-muted font-italic">Cảm ơn quý khách đã sử dụng dịch vụ của PolyCoffee!</p>
                        <a href="bill" class="btn btn-outline-secondary mt-2"><i class="bi bi-arrow-left"></i> Quay lại lịch sử</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp"/>