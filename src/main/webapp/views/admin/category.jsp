<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, com.polycoffee.Entity.Category" %>

<!DOCTYPE html>
<html>
<head>
    <title>Category</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body>

<!-- HEADER + NAVBAR -->
<jsp:include page="/views/layout/header.jsp"/>
<jsp:include page="/views/layout/navbar.jsp"/>

<%
Category item = (Category) request.getAttribute("item");
List<Category> list = (List<Category>) request.getAttribute("list");
%>

<div class="container mt-4">

    <h3 class="mb-4">Quản lý Category</h3>

    <!-- FORM -->
    <div class="card mb-4">
        <div class="card-body">
            <form method="post" action="category">

                <input type="hidden" name="id"
                       value="<%= item != null ? item.getCategoryId() : "" %>">

                <div class="mb-3">
                    <label class="form-label">Tên loại</label>
                    <input type="text" name="name"
                           class="form-control"
                           value="<%= item != null ? item.getName() : "" %>" required>
                </div>

                <div class="form-check mb-3">
                    <input type="checkbox" name="active" class="form-check-input"
                        <%= (item == null || item.isActive()) ? "checked" : "" %>>
                    <label class="form-check-label">Hoạt động</label>
                </div>

                <% if (item == null) { %>
                    <button class="btn btn-success" name="action" value="create">➕ Thêm</button>
                <% } else { %>
                    <button class="btn btn-warning" name="action" value="update">✏️ Cập nhật</button>
                <% } %>

                <a href="category" class="btn btn-secondary">Reset</a>

            </form>
        </div>
    </div>

    <!-- TABLE -->
    <table class="table table-bordered table-hover text-center">
        <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Tên</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>
        </thead>

        <tbody>
        <% for (Category c : list) { %>
            <tr>
                <td><%= c.getCategoryId() %></td>
                <td><%= c.getName() %></td>
                <td>
                    <%= c.isActive() ? "Hoạt động" : " Tắt" %>
                </td>
                <td>
                    <a href="category?action=edit&id=<%= c.getCategoryId() %>"
                       class="btn btn-sm btn-primary">Edit</a>

                    <a href="category?action=delete&id=<%= c.getCategoryId() %>"
                       class="btn btn-sm btn-danger"
                       onclick="return confirm('Bạn có chắc muốn xoá?')">
                        Delete
                    </a>
                </td>
            </tr>
<% } %>
        </tbody>
    </table>

</div>

<!-- FOOTER -->
<jsp:include page="/views/layout/footer.jsp"/>

</body>
</html>