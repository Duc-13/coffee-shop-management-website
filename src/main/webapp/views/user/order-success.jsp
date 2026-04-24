<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="/views/layout/header.jsp"/>
<jsp:include page="/views/layout/navbar.jsp"/>

<div class="container py-5" style="max-width: 650px">
  <div class="card border-0 shadow-sm p-4 text-center">
    <i class="bi bi-check-circle-fill text-success" style="font-size: 4rem"></i>
    <h3 class="fw-bold mt-3">Đặt hàng thành công!</h3>
    <p class="text-muted">Mã đơn hàng: <strong>#${lastBillId}</strong></p>
    <p class="mb-0 small">Phương thức thanh toán:
      <span class="text-primary fw-bold">${lastPaymentMethod}</span>
  </div>

  <%-- Danh sách món --%>
  <div class="card border-0 shadow-sm mt-4">
    <div class="card-header fw-bold bg-white">Chi tiết đơn hàng</div>
    <table class="table align-middle mb-0">
      <thead class="table-light">
      <tr>
        <th class="ps-3">Món</th>
        <th class="text-center">SL</th>
        <th class="text-end pe-3">Thành tiền</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach var="entry" items="${lastCart}">
        <tr>
          <td class="ps-3">
            <div class="d-flex align-items-center gap-2">
              <img src="${pageContext.request.contextPath}/images/${entry.value.image}"
                   style="width:45px;height:45px;object-fit:cover;border-radius:8px">
              <div>
                <div class="fw-bold">${entry.value.name}</div>
                <small class="text-muted">
                  <fmt:formatNumber value="${entry.value.price}" pattern="#,###"/> ₫
                </small>
              </div>
            </div>
          </td>
          <td class="text-center">x${entry.value.quantity}</td>
          <td class="text-end pe-3 fw-bold text-success">
            <fmt:formatNumber value="${entry.value.price * entry.value.quantity}" pattern="#,###"/> ₫
          </td>
        </tr>
      </c:forEach>
      </tbody>
      <tfoot class="table-light">
      <tr>
        <td colspan="2" class="ps-3 fw-bold">Tổng cộng</td>
        <td class="text-end pe-3 fw-bold text-danger fs-5">
          <fmt:formatNumber value="${lastTotal}" pattern="#,###"/> ₫
        </td>
      </tr>
      </tfoot>
    </table>
  </div>

  <div class="text-center mt-4">
    <a href="${pageContext.request.contextPath}/drink" class="btn btn-primary px-4">
      <i class="bi bi-arrow-left"></i> Tiếp tục mua hàng
    </a>
  </div>
</div>

<jsp:include page="/views/layout/footer.jsp"/>