package com.polycoffee.Servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import org.apache.commons.beanutils.BeanUtils;

import com.polycoffee.DAO.UserDAO;
import com.polycoffee.Entity.User;
import com.polycoffee.Util.Mailer;

@WebServlet({"/staff", "/staff/index", "/staff/create", "/staff/update", "/staff/delete", "/staff/edit/*", "/staff/reset-pass"})
public class StaffServlet extends HttpServlet {
    UserDAO dao = new UserDAO();

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();
        User form = new User();
        String message = "";


        try {
            BeanUtils.populate(form, req.getParameterMap());
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            if (path.contains("edit")) {
                int id = Integer.parseInt(req.getPathInfo().substring(1));
                form = dao.findById(id);
                message = "Đang chỉnh sửa nhân viên: " + form.getEmail();
            } else if (path.contains("create")) {
                dao.create(form);
                message = "Thêm nhân viên mới thành công!";
                form = new User();
            } else if (path.contains("update")) {
                dao.update(form);
                message = "Cập nhật thông tin thành công!";
            } else if (path.contains("delete")) {
                String idStr = req.getParameter("usersid");
                int id = (idStr != null && !idStr.isEmpty()) ? Integer.parseInt(idStr) : form.getUsersId();
                dao.deleteById(id);
                message = "Đã xóa nhân viên!";
                form = new User();
            } else if (path.contains("reset-pass")) {
                String email = req.getParameter("resetEmail");
                String newPass = Long.toHexString(System.currentTimeMillis()).substring(0, 8);
                if (dao.updatePass(email, newPass)) {
                    try {
                        Mailer.send(email, "Mật khẩu mới PolyCoffee", "Mật khẩu đăng nhập mới của bạn là: " + newPass);
                        message = "Đã gửi mật khẩu mới tới: " + email;
                    } catch (Exception e) {
                        message = "Lỗi gửi mail (Kiểm tra lại cấu hình Mailer): " + e.getMessage();
                    }
                }
            }
        } catch (Exception e) {
            message = "Lỗi thao tác: " + e.getMessage();
        }


        String searchName = req.getParameter("search_name") == null ? "" : req.getParameter("search_name");
        String searchEmail = req.getParameter("search_email") == null ? "" : req.getParameter("search_email");
        int searchRole = (req.getParameter("search_role") == null || req.getParameter("search_role").isEmpty()) ? -1 : Integer.parseInt(req.getParameter("search_role"));
        int page = (req.getParameter("page") == null || req.getParameter("page").isEmpty()) ? 1 : Integer.parseInt(req.getParameter("page"));

        List<User> list = dao.findStaff(searchName, searchEmail, searchRole, page, 10);
        int totalPages = (int) Math.ceil((double) dao.countStaff(searchName, searchEmail, searchRole) / 10);

        // Đẩy dữ liệu sang JSP
        req.setAttribute("staffList", list);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("currentPage", page);
        req.setAttribute("userForm", form);
        req.setAttribute("message", message);

        req.getRequestDispatcher("/views/admin/staff.jsp").forward(req, resp);
    }
}