<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Nhân viên</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <%@ include file="/views/layout/header.jsp" %>
    <%@ include file="/views/layout/navbar.jsp" %>
    <div class="container mt-4 p-4 bg-white shadow rounded">
    <h4 class="text-success text-center">${message}</h4>

    <div class="card mb-4">
        <div class="card-header bg-primary text-white">Quản lý Nhân Viên</div>
        <div class="card-body">

            <form action="${pageContext.request.contextPath}/staff/index" method="post" autocomplete="off">
              <input type="hidden" name="usersId" value="${userForm.usersId}">

                <div class="row">
                    <div class="col-md-3 mb-3">
                        <label>Họ tên:</label>
                        <input type="text" name="fullName" class="form-control" value="${userForm.fullName}" required>
                    </div>
                    <div class="col-md-3 mb-3">
                        <label>Email :</label>
                        <input type="email" name="email" class="form-control" value="${userForm.email}" autocomplete="off" required>
                    </div>
                    <div class="col-md-3 mb-3">
                        <label>Mật khẩu:</label>
                       <input type="password" name="password" class="form-control" value="${userForm.password}" autocomplete="new-password">
                    </div>
                    <div class="col-md-3 mb-3">
                        <label>Vai trò:</label>
                        <select name="role" class="form-control">
                            <option value="2" ${userForm.role == 2 ? 'selected' : ''}>Khách hàng (Guest)</option>
                            <option value="1" ${userForm.role == 1 ? 'selected' : ''}>Nhân viên (Staff)</option>
                            <option value="0" ${userForm.role == 0 ? 'selected' : ''}>Quản trị (Admin)</option>
                        </select>
                    </div>
                </div>

                <button class="btn btn-success" formaction="${pageContext.request.contextPath}/staff/create">Thêm Mới</button>
                <button class="btn btn-warning" formaction="${pageContext.request.contextPath}/staff/update">Cập Nhật</button>
                <button class="btn btn-danger" formaction="${pageContext.request.contextPath}/staff/delete">Xóa</button>
                <a href="${pageContext.request.contextPath}/staff/index" class="btn btn-secondary">Làm Mới Form</a>
            </form>
        </div>
    </div>

    <hr>
   <form action="${pageContext.request.contextPath}/staff/index" method="GET" class="card p-3 mb-4 shadow-sm border-0 bg-light-subtle">
           <div class="row g-3 align-items-end">
               <div class="col-md-3">
                   <label class="form-label fw-bold text-muted small uppercase">Tên nhân viên</label>
                   <input type="text" name="search_name" class="form-control" value="${param.search_name}" placeholder="Nhập tên...">
               </div>
               <div class="col-md-3">
                   <label class="form-label fw-bold text-muted small uppercase">Email</label>
                   <input type="text" name="search_email" class="form-control" value="${param.search_email}" placeholder="Nhập email...">
               </div>
               <div class="col-md-3">
                   <label class="form-label fw-bold text-muted small uppercase">Vai trò</label>
                   <select name="search_role" class="form-select">
                       <option value="-1">Tất cả</option>
                       <option value="0" ${param.search_role == '0' ? 'selected' : ''}>Quản trị (Admin)</option>
                       <option value="1" ${param.search_role == '1' ? 'selected' : ''}>Nhân viên (Staff)</option>
                       <option value="2" ${param.search_role == '2' ? 'selected' : ''}>Khách hàng (Guest)</option>
                   </select>
               </div>
               <div class="col-md-3">
                   <button type="submit" class="btn btn-primary w-100 fw-bold"> Tìm kiếm & Lọc</button>
               </div>
           </div>
       </form>

        <table class="table table-bordered table-hover mt-3">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Họ tên</th>
                    <th>Email</th>
                    <th>Vai trò</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="u" items="${staffList}">
                    <tr>
                        <td>${u.usersId}</td>
                        <td>${u.fullName}</td>
                        <td>${u.email}</td>
                        <td>
                                ${u.role == 0 ? 'Admin' : (u.role == 1 ? 'Staff' : 'User')}
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/staff/edit/${u.usersId}" class="btn btn-sm btn-info">Chọn</a>

                            <form action="${pageContext.request.contextPath}/staff/reset-pass" method="post" style="display:inline-block;">
                                <input type="hidden" name="resetEmail" value="${u.email}">
                                <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Gửi mật khẩu mới vào email này?');">Cấp lại mật khẩu</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        </table>

                <c:if test="${totalPages > 1}">
                    <nav aria-label="Page navigation" class="mt-4 pb-4">
                        <ul class="pagination justify-content-center shadow-sm">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage - 1}&search_name=${param.search_name}&search_email=${param.search_email}&search_role=${param.search_role}">
                                    Trước
                                </a>
                            </li>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}&search_name=${param.search_name}&search_email=${param.search_email}&search_role=${param.search_role}">${i}</a>
                                </li>
                            </c:forEach>

                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage + 1}&search_name=${param.search_name}&search_email=${param.search_email}&search_role=${param.search_role}">
                                    Sau
                                </a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </div>
    </div>
    <%@ include file="/views/layout/footer.jsp" %>
</body>
</html>