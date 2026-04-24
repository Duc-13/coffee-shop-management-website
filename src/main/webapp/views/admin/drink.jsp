<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý thực đơn - PolyCoffee</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .img-clickable:hover { transform: scale(1.05); transition: 0.2s; border-color: #0d6efd; cursor: pointer; }
        .pagination .page-link { color: #333; }
        .pagination .active .page-link { background-color: #333; border-color: #333; color: white; }
    </style>
</head>
<body class="bg-light">
<%@ include file="/views/layout/header.jsp" %>
<%@ include file="/views/layout/navbar.jsp" %>

<div class="container mt-4">
    <h2 class="mb-4 fw-bold text-dark">Quản lý Thực đơn</h2>

    <div class="card shadow-sm mb-4">
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/drink/save" method="post" enctype="multipart/form-data">
               <input type="hidden" name="drinksId" value="${drinkDetail != null ? drinkDetail.drinksId : ''}">
                <input type="hidden" name="currentImage" value="${drinkDetail.image}">

                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label fw-bold">Tên món</label>
                        <input type="text" name="drinkName" class="form-control" value="${drinkDetail.name}" required>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label fw-bold">Giá (VNĐ)</label>
                        <input type="number" name="price" class="form-control" value="${drinkDetail.price}" required>
                    </div>
                    <div class="col-md-12 mb-3">
                        <label class="form-label fw-bold">Mô tả món uống:</label>
                        <textarea name="description" class="form-control" rows="2" placeholder="Nhập mô tả...">${drink.description}</textarea>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-bold">Loại đồ uống</label>
                        <select name="categoryId" class="form-select" required>
                            <c:forEach var="c" items="${categories}">
                                <option value="${c.categoryId}" ${drinkDetail.categoryId == c.categoryId ? 'selected' : ''}>${c.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-bold">Hình ảnh món</label>
                        <input type="file" name="imageFile" class="form-control" accept="image/*">
                        <c:if test="${not empty drinkDetail.image}">
                            <div class="mt-1 d-flex align-items-center">
                                <img src="${pageContext.request.contextPath}/images/${drinkDetail.image}" width="30" height="30" style="object-fit: cover;" class="me-2 rounded shadow-sm">
                                <small class="text-muted text-truncate">Hiện tại: ${drinkDetail.image}</small>
                            </div>
                        </c:if>
                    </div>

                    <div class="col-12 d-flex align-items-center justify-content-between">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="active" value="true" id="activeCheck"
                            ${drinkDetail.active || drinkDetail == null ? 'checked' : ''}>
                            <label class="form-check-label" for="activeCheck">Đang hoạt động</label>
                        </div>
                        <div>
                            <button type="submit" class="btn btn-success px-4 me-2">
                                <i class="bi bi-save"></i> ${drinkDetail != null ? 'Cập nhật' : 'Thêm mới'}
                            </button>
                            <a href="${pageContext.request.contextPath}/drink" class="btn btn-secondary px-4">Làm mới</a>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <div class="card shadow-sm mb-4 border-0">
        <div class="card-body bg-light-subtle">
            <form action="${pageContext.request.contextPath}/drink" method="get" class="row g-3 align-items-end">
                <div class="col-md-5">
                    <label class="form-label small fw-bold text-uppercase text-muted">Tìm kiếm tên món</label>
                    <div class="input-group">
                        <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
                        <input type="text" name="name" class="form-control" placeholder="Nhập tên đồ uống..." value="${name}">
                    </div>
                </div>
                <div class="col-md-4">
                    <label class="form-label small fw-bold text-uppercase text-muted">Lọc theo loại</label>
                    <select name="categoryId" class="form-select">
                        <option value="">Tất cả loại đồ uống</option>
                        <c:forEach var="c" items="${categories}">
                            <option value="${c.categoryId}" ${categoryId == c.categoryId ? 'selected' : ''}>
                                    ${c.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <button type="submit" class="btn btn-primary w-100"><i class="bi bi-filter"></i> Lọc danh sách</button>
                </div>
            </form>
        </div>
    </div>

    <div class="bg-white shadow rounded p-0 overflow-hidden">
        <table class="table table-hover align-middle mb-0">
            <thead class="table-dark text-center">
                <tr>
                    <th width="5%">ID</th>
                    <th width="15%">Tên món</th>
                    <th width="10%">Hình ảnh</th>
                    <th width="20%">Mô tả</th>
                    <th width="10%">Giá</th>
                    <th width="12%">Trạng thái</th>
                    <th width="13%">Loại</th>
                    <th width="15%">Hành động</th> </tr>
            </thead>
            <tbody>
            <c:forEach var="d" items="${drinkList}">
                <tr>
                    <td class="text-center">${d.drinksId}</td>
                    <td class="fw-bold text-primary">${d.name}</td>
                    <td class="text-center">
                        <img src="${pageContext.request.contextPath}/images/${not empty d.image ? d.image : 'default.jpg'}"
                             alt="${d.name}"
                             class="img-thumbnail img-clickable"
                             style="width: 50px; height: 50px; object-fit: cover;"
                             onclick="zoomImage(this.src)">
                    </td>

                    <td>${d.description}</td>

                    <td class="text-end fw-bold text-danger">${d.price} VNĐ</td>


                    <td class="text-center">
                        <span class="badge ${d.active ? 'bg-success' : 'bg-secondary'} px-3">
                                ${d.active ? 'Hoạt động' : 'Tạm ngưng'}
                        </span>
                    </td>



                    <td class="text-center">
                        <c:forEach var="c" items="${categories}">
                            <c:if test="${c.categoryId == d.categoryId}">${c.name}</c:if>
                        </c:forEach>
                    </td>
                    <td class="text-center">
                        <a href="${pageContext.request.contextPath}/drink/edit?id=${d.drinksId}" class="btn btn-outline-primary btn-sm me-1">
                            <i class="bi bi-pencil"></i> Sửa
                        </a>
                        <a href="${pageContext.request.contextPath}/drink/delete?id=${d.drinksId}" class="btn btn-outline-danger btn-sm"
                           onclick="return confirm('Bạn có chắc chắn muốn xóa món này?')">
                            <i class="bi bi-trash"></i> Xóa
                        </a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty drinkList}">
                <tr><td colspan="7" class="text-center p-4 text-muted">Không tìm thấy món ăn nào.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <c:if test="${totalPages > 1}">
        <nav aria-label="Page navigation" class="mt-4 pb-4">
            <ul class="pagination justify-content-center shadow-sm">
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link" href="?page=1&name=${name}&categoryId=${categoryId}&status=${status}">
                        <i class="bi bi-chevron-double-left"></i>
                    </a>
                </li>
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link" href="?page=${currentPage - 1}&name=${name}&categoryId=${categoryId}&status=${status}">
                        <i class="bi bi-chevron-left"></i>
                    </a>
                </li>

                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                        <a class="page-link" href="?page=${i}&name=${name}&categoryId=${categoryId}&status=${status}">${i}</a>
                    </li>
                </c:forEach>

                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="?page=${currentPage + 1}&name=${name}&categoryId=${categoryId}&status=${status}">
                        <i class="bi bi-chevron-right"></i>
                    </a>
                </li>
                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="?page=${totalPages}&name=${name}&categoryId=${categoryId}&status=${status}">
                        <i class="bi bi-chevron-double-right"></i>
                    </a>
                </li>
            </ul>
        </nav>
    </c:if>
</div>

<div class="modal fade" id="imageModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content bg-transparent border-0">
            <div class="modal-body text-center p-0 position-relative">
                <img src="" id="zoomedImage" class="img-fluid rounded shadow-lg border border-3 border-white">
                <button type="button" class="btn-close btn-close-white position-absolute top-0 end-0 m-3 shadow" data-bs-dismiss="modal"></button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function zoomImage(src) {
        document.getElementById('zoomedImage').src = src;
        var myModal = new bootstrap.Modal(document.getElementById('imageModal'));
        myModal.show();
    }
</script>

<%@ include file="/views/layout/footer.jsp" %>
</body>
</html>