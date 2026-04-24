<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, com.polycoffee.Entity.Bill" %>

<%
    List<Bill> list = (List<Bill>) request.getAttribute("list");
    Integer currentPageObj = (Integer) request.getAttribute("currentPage");
    Integer totalPagesObj = (Integer) request.getAttribute("totalPages");

    int currentPage = currentPageObj != null ? currentPageObj : 1;
    int totalPages = totalPagesObj != null ? totalPagesObj : 1;
%>

<jsp:include page="/views/layout/header.jsp"/>
<jsp:include page="/views/layout/navbar.jsp"/>

<div class="container mt-5">

    <!-- HEADER -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold">Quản lý hóa đơn</h2>

        <!-- CREATE BUTTON -->
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createModal">
            + Tạo hóa đơn
        </button>
    </div>

    <!-- CREATE MODAL -->
    <div class="modal fade" id="createModal">
        <div class="modal-dialog">
            <div class="modal-content">

                <form action="${pageContext.request.contextPath}/bill" method="post">
                    <input type="hidden" name="action" value="create"/>

                    <div class="modal-header">
                        <h5 class="modal-title">Tạo hóa đơn</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body">

                        <div class="mb-3">
                            <label>Mã đơn</label>
                            <input type="text" name="code" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label>Tổng tiền</label>
                            <input type="number" name="total" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label>Trạng thái</label>
                            <select name="status" class="form-control">
                                <option value="0">Waiting</option>
                                <option value="1">Done</option>
                                <option value="-1">Cancel</option>
                            </select>
                        </div>


                    </div>

                    <div class="modal-footer">
                        <button type="submit" class="btn btn-success">Lưu</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Huỷ</button>
                    </div>

                </form>

            </div>
        </div>
    </div>

    <!-- LIST -->
    <% if (list == null || list.isEmpty()) { %>
    <div class="alert alert-warning text-center">
        Không có hóa đơn nào
    </div>
    <% } else { %>

    <div class="card shadow border-0">
        <div class="card-body p-0">

            <table class="table table-hover align-middle text-center mb-0">
                <thead class="table-dark">
                <tr>
                    <th>#</th>
                    <th>Mã đơn</th>
                    <th>Tổng tiền</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
                </thead>

                <tbody>
                <% for (Bill b : list) { %>
                <tr>
                    <td><%= b.getBillsId() %>
                    </td>

                    <td class="fw-bold text-primary">
                        <%= b.getCode() %>
                    </td>

                    <td class="fw-semibold text-success">
                        <%= String.format("%,d", b.getTotal()) %> ₫
                    </td>

                    <td>
                        <% if (b.getStatus() == 0) { %>
                        <span class="badge bg-warning text-dark px-3 py-2">Waiting</span>
                        <% } else if (b.getStatus() == 1) { %>
                        <span class="badge bg-success px-3 py-2">Done</span>
                        <% } else { %>
                        <span class="badge bg-danger px-3 py-2">Cancel</span>
                        <% } %>
                    </td>

                    <td>
                        <a class="btn btn-outline-info btn-sm me-1"
                           href="bill?action=detail&id=<%= b.getBillsId() %>">
                            Detail
                        </a>

                        <% if (b.getStatus() == 0) { %>
                        <a class="btn btn-outline-success btn-sm me-1"
                           onclick="return confirm('Xác nhận chốt đơn này?')"
                           href="bill?action=complete&id=<%= b.getBillsId() %>">
                            Done
                        </a>

                        <a class="btn btn-outline-danger btn-sm"
                           onclick="return confirm('Bạn có chắc muốn huỷ?')"
                           href="bill?action=cancel&id=<%= b.getBillsId() %>">
                            Cancel
                        </a>
                        <% } else { %>
                        <button class="btn btn-outline-secondary btn-sm" disabled>
                            Cancel
                        </button>
                        <% } %>
                    </td>
                </tr>
                <% } %></tbody>

            </table>
        </div>
    </div>

    <!-- PAGINATION -->
    <nav class="mt-4">
        <ul class="pagination justify-content-center">
            <% for (int i = 1; i <= totalPages; i++) { %>
            <li class="page-item <%= (i == currentPage ? "active" : "") %>">
                <a class="page-link" href="bill?page=<%= i %>"><%= i %>
                </a>
            </li>
            <% } %>
        </ul>
    </nav>

    <% } %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</div>

<jsp:include page="/views/layout/footer.jsp"/>