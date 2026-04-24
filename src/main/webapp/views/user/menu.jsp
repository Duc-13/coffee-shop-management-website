<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="path" value="${pageContext.request.contextPath}"/>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

<jsp:include page="/views/layout/header.jsp"/>
<jsp:include page="/views/layout/navbar.jsp"/>

<style>
    @media (min-width: 992px) {
        .col-lg-2-4 { flex: 0 0 auto; width: 20%; }
    }
    .card-img-top { transition: transform 0.3s; }
    .card:hover .card-img-top { transform: scale(1.05); }

    /* ===== Size / Option buttons ===== */
    .opt-group { display: flex; gap: 8px; flex-wrap: wrap; }
    .opt-btn {
        padding: 6px 16px;
        border: 1.5px solid #dee2e6;
        border-radius: 8px;
        background: #fff;
        cursor: pointer;
        font-size: 13px;
        transition: all .15s;
    }
    .opt-btn.active {
        background: #1a7a5e;
        border-color: #1a7a5e;
        color: #fff;
    }
    .opt-btn small { display: block; font-size: 11px; opacity: .8; text-align: center; }

    /* ===== Topping rows ===== */
    .topping-row {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 8px 0;
        border-bottom: 1px solid #f0f0f0;
    }
    .topping-row:last-child { border: none; }

    /* ===== Payment buttons ===== */
    .pay-btn {
        border: 1.5px solid #dee2e6;
        border-radius: 8px;
        background: #fff;
        padding: 8px 4px;
        cursor: pointer;
        font-size: 12px;
        transition: all .15s;
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 4px;
    }
    .pay-btn.active {
        border-color: #1a7a5e;
        background: #e8f5f0;
        color: #1a7a5e;
        font-weight: 500;
    }
    .pay-btn i { font-size: 18px; }

    /* ===== Qty control ===== */
    .qty-ctrl { display: flex; align-items: center; gap: 6px; }
    .qty-ctrl button {
        width: 28px; height: 28px;
        border: 1px solid #dee2e6;
        border-radius: 6px;
        background: #f8f9fa;
        cursor: pointer;
        font-size: 16px;
        display: flex; align-items: center; justify-content: center;
        line-height: 1;
    }
    .qty-ctrl span { min-width: 22px; text-align: center; font-weight: 500; font-size: 14px; }
</style>

<div class="container mt-4">

    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-${sessionScope.messageType} alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>${sessionScope.message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="message" scope="session"/>
        <c:remove var="messageType" scope="session"/>
    </c:if>

    <h2 class="text-center fw-bold mb-4">MENU ĐỒ UỐNG</h2>

    <%-- Filter bar --%>
    <div class="card shadow-sm mb-4 border-0">
        <div class="card-body bg-light-subtle">
            <form action="${path}/drink" method="get" class="row g-3 align-items-end">
                <div class="col-md-5">
                    <label class="form-label small fw-bold text-uppercase text-muted">Tìm kiếm tên món</label>
                    <input type="text" name="name" class="form-control" placeholder="Nhập tên đồ uống..." value="${name}">
                </div>
                <div class="col-md-4">
                    <label class="form-label small fw-bold text-uppercase text-muted">Lọc theo loại</label>
                    <select name="categoryId" class="form-select">
                        <option value="">Tất cả loại đồ uống</option>
                        <c:forEach var="c" items="${categories}">
                            <option value="${c.categoryId}" ${categoryId == c.categoryId ? 'selected' : ''}>${c.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-primary w-100"><i class="bi bi-filter"></i> Lọc</button>
                        <a href="${path}/drink" class="btn btn-outline-secondary w-100"><i class="bi bi-arrow-counterclockwise"></i> Reset</a>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <%-- Drink grid --%>
    <div class="row g-3">
        <c:forEach var="d" items="${drinkList}">
            <div class="col-6 col-md-4 col-lg-2-4">
                <div class="card h-100 shadow-sm border-0 rounded-3 overflow-hidden">
                    <img src="${path}/images/${d.image}" class="card-img-top" style="height:160px;object-fit:cover;"
                         onerror="this.src='https://via.placeholder.com/300x200'">
                    <div class="card-body p-2 text-center">
                        <h6 class="fw-bold mb-1 text-truncate">${d.name}</h6>
                        <p class="text-success small fw-bold mb-1">${d.price} ₫</p>
                    </div>
                    <div class="card-footer bg-white p-2 border-0">
                        <button class="btn btn-outline-success btn-sm w-100 fw-bold mb-2"
                                onclick="openOrderModal('${d.drinksId}','${d.name}','${d.price}','${d.image}')">
                            <i class="bi bi-cart-plus"></i> Thêm món
                        </button>
                        <button class="btn btn-primary btn-sm w-100 fw-bold"
                                onclick="openOrderModal('${d.drinksId}','${d.name}','${d.price}','${d.image}','checkout')">
                            <i class="bi bi-lightning-fill"></i> Đặt ngay
                        </button>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <%-- Pagination --%>
    <c:if test="${totalPages > 1}">
        <nav class="mt-4 pb-4">
            <ul class="pagination justify-content-center shadow-sm">
                <li class="page-item ${currentPage==1?'disabled':''}">
                    <a class="page-link" href="?page=1&name=${name}&categoryId=${categoryId}"><i class="bi bi-chevron-double-left"></i></a>
                </li>
                <li class="page-item ${currentPage==1?'disabled':''}">
                    <a class="page-link" href="?page=${currentPage-1}&name=${name}&categoryId=${categoryId}"><i class="bi bi-chevron-left"></i></a>
                </li>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${currentPage==i?'active':''}">
                        <a class="page-link" href="?page=${i}&name=${name}&categoryId=${categoryId}">${i}</a>
                    </li>
                </c:forEach>
                <li class="page-item ${currentPage==totalPages?'disabled':''}">
                    <a class="page-link" href="?page=${currentPage+1}&name=${name}&categoryId=${categoryId}"><i class="bi bi-chevron-right"></i></a>
                </li>
                <li class="page-item ${currentPage==totalPages?'disabled':''}">
                    <a class="page-link" href="?page=${totalPages}&name=${name}&categoryId=${categoryId}"><i class="bi bi-chevron-double-right"></i></a>
                </li>
            </ul>
        </nav>
    </c:if>
</div>

<%-- ===== ORDER MODAL (Đã chỉnh sửa bố cục) ===== --%>
<div class="modal fade" id="orderModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg"> <%-- Thêm modal-lg để rộng hơn --%>
        <div class="modal-content border-0 shadow">

            <div class="modal-header border-0 pb-0">
                <h5 class="modal-title fw-bold" id="omDrinkName">Tên món</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body pt-2">
                <div class="row">
                    <%-- Cột trái: Ảnh đồ uống --%>
                    <div class="col-md-5 mb-3 mb-md-0">
                        <img id="omDrinkImg" src="" class="img-fluid rounded-3 shadow-sm"
                             style="width: 100%; height: 300px; object-fit: cover;">
                    </div>

                    <%-- Cột phải: Các lựa chọn --%>
                    <div class="col-md-7">
                        <%-- Kích cỡ --%>
                        <p class="fw-bold small text-success mb-2">Chọn kích cỡ</p>
                        <div class="opt-group mb-3" id="sizeGroup">
                            <button class="opt-btn active" onclick="selSize(this,0)">M <small>0 đ</small></button>
                            <button class="opt-btn" onclick="selSize(this,5000)">L <small>+5.000 đ</small></button>
                        </div>

                        <%-- Ngọt --%>
                        <p class="fw-bold small text-success mb-2">Ngọt</p>
                        <div class="opt-group mb-3">
                            <button class="opt-btn" onclick="selGroup(this)">Ít</button>
                            <button class="opt-btn active" onclick="selGroup(this)">Bình thường</button>
                            <button class="opt-btn" onclick="selGroup(this)">Nhiều</button>
                        </div>

                        <%-- Đá --%>
                        <p class="fw-bold small text-success mb-2">Đá</p>
                        <div class="opt-group mb-3">
                            <button class="opt-btn" onclick="selGroup(this)">Ít đá</button>
                            <button class="opt-btn active" onclick="selGroup(this)">Bình thường</button>
                            <button class="opt-btn" onclick="selGroup(this)">Nhiều đá</button>
                        </div>

                        <%-- Số lượng --%>
                        <p class="fw-bold small text-success mt-3 mb-2">Số lượng</p>
                        <div class="qty-ctrl mb-3">
                            <button onclick="changeMainQty(-1)">−</button>
                            <span id="omQty">1</span>
                            <button onclick="changeMainQty(1)">+</button>
                        </div>
                    </div>
                </div>

                <%-- Trong modal-body của orderModal --%>
                <div id="paymentSection"> <%-- Bọc lại để ẩn/hiện --%>
                    <hr class="text-muted opacity-25">
                    <p class="fw-bold small text-success mb-2">Phương thức thanh toán</p>
                    <div class="row g-2" id="payGroup">
                        <div class="col-6">
                            <button type="button" class="pay-btn w-100 active py-3" id="pay-tienmat" onclick="selPay('tienmat')">
                                <i class="bi bi-cash-coin fs-4"></i> Tiền mặt
                            </button>
                        </div>
                        <div class="col-6">
                            <button type="button" class="pay-btn w-100 py-3" id="pay-chuyenkhoan" onclick="selPay('chuyenkhoan')">
                                <i class="bi bi-bank fs-4"></i> Chuyển khoản
                            </button>
                        </div>
                    </div>
                </div>
                <%-- Trong phần #paymentSection của orderModal --%>
                <div id="qrSection" class="text-center mt-3" style="display: none;">
                    <p class="small text-muted mb-2">Vui lòng quét mã để thanh toán:</p>
                    <img src="${pageContext.request.contextPath}/images/QR.jpg"
                         alt="Mã QR"
                         class="img-fluid rounded shadow-sm border"
                         style="max-width: 200px;">
                </div>
            </div>

            <div class="modal-footer border-0 pt-0 d-flex justify-content-between align-items-center">
                <div>
                    <div class="small text-muted">Tổng cộng</div>
                    <div class="fw-bold text-success fs-5" id="omTotal">0 ₫</div>
                </div>
                <form action="${path}/cart/add" method="post" id="omForm">
                    <input type="hidden" name="drinkId" id="omDrinkId">
                    <input type="hidden" name="quantity" id="omQtyHidden">
                    <input type="hidden" name="size" id="omSizeHidden">
                    <input type="hidden" name="payMethod" id="omPayHidden">
                    <input type="hidden" name="redirect" id="omRedirect" value="menu">
                    <button type="submit" class="btn btn-success fw-bold px-5 py-2" onclick="submitOrder()">
                        <i class="bi bi-cart-check"></i> Xác nhận
                    </button>
                </form>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    //* ===== Khai báo biến toàn cục (State) ===== */
    let omBasePrice = 0;
    let omSizeDelta = 5000;
    let omQty = 1;
    let omPayMethod = 'tienmat';
    let omRedirectVal = 'menu';

    /* Hàm định dạng tiền tệ */
    function fmt(n) {
        return Math.round(n).toLocaleString('vi-VN') + ' ₫';
    }

    /* Hàm tính tổng cộng */
    function calcTotal() {
        return (omBasePrice + omSizeDelta) * omQty;
    }

    /* Hàm cập nhật hiển thị tổng tiền */
    function refreshTotal() {
        document.getElementById('omTotal').textContent = fmt(calcTotal());
    }

    /* ===== Các hàm xử lý sự kiện ===== */

    // Mở Modal và thiết lập giá trị ban đầu
    function openOrderModal(id, name, price, img, redirect) {
        omBasePrice = parseInt(price) || 0;
        omSizeDelta = 5000;
        omQty = 1;
        omPayMethod = 'tienmat';
        omRedirectVal = redirect || 'menu';

        document.getElementById('omDrinkId').value = id;
        document.getElementById('omDrinkName').textContent = name;
        document.getElementById('omQty').textContent = 1;
        document.getElementById('omRedirect').value = omRedirectVal;

        // Gán ảnh vào modal
        const imgPath = img ? "${path}/images/" + img : 'https://via.placeholder.com/300x300';
        document.getElementById('omDrinkImg').src = imgPath;

        // LOGIC ẨN/HIỆN PHƯƠNG THỨC THANH TOÁN
        const paySec = document.getElementById('paymentSection');
        if (omRedirectVal === 'checkout') {
            paySec.style.display = 'block'; // Hiện khi "Đặt ngay"
        } else {
            paySec.style.display = 'none';  // Ẩn khi "Thêm món"
        }

        // Reset giao diện size: mặc định chọn L (index 1)
        document.querySelectorAll('#sizeGroup .opt-btn').forEach((b, i) => {
            b.classList.toggle('active', i === 1);
        });

        // Reset phương thức thanh toán về mặc định
        document.querySelectorAll('.pay-btn').forEach(b => b.classList.remove('active'));
        document.getElementById('pay-tienmat').classList.add('active');

        refreshTotal();
        bootstrap.Modal.getOrCreateInstance(document.getElementById('orderModal')).show();
    }

    // Chọn kích cỡ
    function selSize(btn, delta) {
        btn.closest('.opt-group').querySelectorAll('.opt-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        omSizeDelta = parseInt(delta) || 0;
        refreshTotal();
    }

    // Chọn Ngọt/Đá (Generic)
    function selGroup(btn) {
        btn.closest('.opt-group').querySelectorAll('.opt-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
    }

    // Thay đổi số lượng món chính
    function changeMainQty(delta) {
        omQty = Math.max(1, omQty + delta);
        document.getElementById('omQty').textContent = omQty;
        refreshTotal();
    }

    // Chọn phương thức thanh toán
    function selPay(method) {
        omPayMethod = method;
        document.querySelectorAll('.pay-btn').forEach(b => b.classList.remove('active'));
        document.getElementById('pay-' + method).classList.add('active');
    }

    // Gán dữ liệu vào form trước khi submit
    function submitOrder() {
        document.getElementById('omQtyHidden').value = omQty;
        document.getElementById('omSizeHidden').value = omSizeDelta;
        document.getElementById('omPayHidden').value = omPayMethod;
    }

    /* Tự động đóng thông báo alert sau 3 giây */
    window.setTimeout(function () {
        const alertElement = document.querySelector('.alert');
        if (alertElement) {
            const bsAlert = new bootstrap.Alert(alertElement);
            bsAlert.close();
        }
    }, 3000);
    function selPay(method) {
        omPayMethod = method;

        // Cập nhật trạng thái active cho các nút
        document.querySelectorAll('.pay-btn').forEach(b => b.classList.remove('active'));
        document.getElementById('pay-' + method).classList.add('active');

        // Xử lý ẩn/hiện mã QR
        const qrSec = document.getElementById('qrSection');
        if (method === 'chuyenkhoan') {
            qrSec.style.display = 'block';
        } else {
            qrSec.style.display = 'none';
        }
    }
</script>

<jsp:include page="/views/layout/footer.jsp"/>
