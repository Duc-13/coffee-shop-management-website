<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

<jsp:include page="/views/layout/header.jsp"/>
<jsp:include page="/views/layout/navbar.jsp"/>

<div class="container py-5">
  <h2 class="fw-bold mb-4"><i class="bi bi-cart3"></i> GIỎ HÀNG CỦA BẠN</h2>

  <div class="row g-4">
    <div class="col-lg-8">
      <c:choose>
        <%-- TRƯỜNG HỢP 1: KHÁCH BẤM "MUA NGAY" --%>
        <c:when test="${not empty sessionScope.buyNowItem}">
          <div class="card border-0 shadow-sm overflow-hidden border-warning">
            <div class="card-header bg-warning text-dark fw-bold">
              <i class="bi bi-lightning-charge-fill"></i> ĐƠN HÀNG MUA NGAY
            </div>
            <table class="table align-middle mb-0">
              <thead class="table-light">
                <tr><th class="ps-3">Sản phẩm</th><th class="text-center">Số lượng</th><th class="text-end pe-3">Thành tiền</th></tr>
              </thead>
              <tbody>
                <c:set var="total" value="${buyNowItem.price * buyNowItem.quantity}" />
                <tr>
                  <td class="ps-3">
                    <div class="d-flex align-items-center">
                      <img src="${pageContext.request.contextPath}/images/${buyNowItem.image}" class="rounded me-3" style="width: 60px; height: 60px; object-fit: cover;">
                      <div>
                        <h6 class="mb-0 fw-bold">${buyNowItem.name}</h6>
                        <small class="text-muted"><fmt:formatNumber value="${buyNowItem.price}" pattern="#,###" /> ₫</small><br>
                        <a href="${pageContext.request.contextPath}/cart/cancel-buynow" class="text-danger x-small text-decoration-none">
                          <i class="bi bi-x-circle"></i> Hủy mua ngay
                        </a>
                      </div>
                    </div>
                  </td>
                  <td class="text-center fw-bold">x${buyNowItem.quantity}</td>
                  <td class="text-end pe-3 fw-bold text-success"><fmt:formatNumber value="${total}" pattern="#,###" /> ₫</td>
                </tr>
              </tbody>
            </table>
          </div>
        </c:when>

        <%-- TRƯỜNG HỢP 2: GIỎ HÀNG TRỐNG --%>
        <c:when test="${empty cart || cart.size() == 0}">
          <div class="card border-0 shadow-sm p-5 text-center">
            <i class="bi bi-cart-x display-1 text-muted"></i>
            <p class="mt-3 lead">Giỏ hàng của bạn đang trống.</p>
            <a href="${pageContext.request.contextPath}/drink" class="btn btn-primary px-4">Quay lại Menu</a>
          </div>
        </c:when>

        <%-- TRƯỜNG HỢP 3: GIỎ HÀNG BÌNH THƯỜNG --%>
        <c:otherwise>
          <div class="card border-0 shadow-sm overflow-hidden">
            <table class="table align-middle mb-0">
              <thead class="table-light">
              <tr><th class="ps-3">Sản phẩm</th><th class="text-center">Số lượng</th><th class="text-end pe-3">Thành tiền</th></tr>
              </thead>
              <tbody>
              <c:set var="total" value="0" />
              <c:forEach var="item" items="${cart.values()}">
                <c:set var="total" value="${total + (item.price * item.quantity)}" />
                <tr>
                  <td class="ps-3">
                    <div class="d-flex align-items-center">
                      <img src="${pageContext.request.contextPath}/images/${item.image}" class="rounded me-3" style="width: 60px; height: 60px; object-fit: cover;">
                      <div>
                        <h6 class="mb-0 fw-bold">${item.name}</h6>
                        <small class="text-muted"><fmt:formatNumber value="${item.price}" pattern="#,###" /> ₫</small><br>
                        <a href="${pageContext.request.contextPath}/cart/remove?id=${item.drinkId}" class="text-danger x-small text-decoration-none"><i class="bi bi-trash"></i> Xóa</a>
                      </div>
                    </div>
                  </td>
                  <td class="text-center" style="width: 150px;">
                    <div class="input-group input-group-sm">
                      <a href="${pageContext.request.contextPath}/cart/update?id=${item.drinkId}&qty=-1" class="btn btn-outline-secondary">-</a>
                      <input type="text" class="form-control text-center bg-white" value="${item.quantity}" readonly>
                      <a href="${pageContext.request.contextPath}/cart/update?id=${item.drinkId}&qty=1" class="btn btn-outline-secondary">+</a>
                    </div>
                  </td>
                  <td class="text-end pe-3 fw-bold text-success"><fmt:formatNumber value="${item.price * item.quantity}" pattern="#,###" /> ₫</td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </div>
        </c:otherwise>
      </c:choose>
    </div>

    <div class="col-lg-4">
      <div class="card border-0 shadow-sm p-4">
        <h5 class="fw-bold mb-4">Tóm tắt đơn hàng</h5>
        <div class="d-flex justify-content-between mb-2">
          <span>Tạm tính:</span><span class="fw-bold"><fmt:formatNumber value="${total}" pattern="#,###" /> ₫</span>
        </div>
        <div class="d-flex justify-content-between mb-2">
          <span>Phí vận chuyển:</span><span class="text-success fw-bold">Miễn phí</span>
        </div>
        <hr>
        <div class="d-flex justify-content-between mb-4">
          <span class="h5 fw-bold">Tổng cộng:</span><span class="h5 fw-bold text-danger"><fmt:formatNumber value="${total}" pattern="#,###" /> ₫</span>
        </div>

        <form action="${pageContext.request.contextPath}/order/checkout" method="post">
            <h6 class="fw-bold mb-3">Hình thức thanh toán</h6>
            <div class="form-check mb-2">
                <input class="form-check-input" type="radio" name="paymentMethod" value="Tiền mặt" id="payCash" checked onchange="toggleQR()">
                <label class="form-check-label" for="payCash">Tiền mặt</label>
            </div>
            <div class="form-check mb-4">
                <input class="form-check-input" type="radio" name="paymentMethod" value="Chuyển khoản" id="payTransfer" onchange="toggleQR()">
                <label class="form-check-label" for="payTransfer">Chuyển khoản</label>
            </div>

            <div id="qrContainer" class="text-center mb-4" style="display: none;">
                <p class="small text-muted mb-2">Vui lòng quét mã QR để chuyển khoản:</p>
                <img src="${pageContext.request.contextPath}/images/QR.jpg" alt="Mã QR" class="img-fluid rounded shadow-sm" style="max-width: 200px;">
            </div>

            <button type="submit" class="btn btn-success w-100 py-3 fw-bold fs-5"
            ${(empty cart || cart.size() == 0) && empty sessionScope.buyNowItem ? 'disabled' : ''}>
                XÁC NHẬN THANH TOÁN
            </button>
        </form>

        <a href="${pageContext.request.contextPath}/drink" class="btn btn-link w-100 text-muted mt-3 text-decoration-none small">
          <i class="bi bi-arrow-left"></i> Tiếp tục mua hàng
        </a>

        <script>
        function toggleQR() {
            const isTransfer = document.getElementById('payTransfer').checked;
            const qrContainer = document.getElementById('qrContainer');
            if (isTransfer) {
                qrContainer.style.display = 'block';
            } else {
                qrContainer.style.display = 'none';
            }
        }
        </script>
      </div>
    </div>
  </div>
</div>

<jsp:include page="/views/layout/footer.jsp"/>