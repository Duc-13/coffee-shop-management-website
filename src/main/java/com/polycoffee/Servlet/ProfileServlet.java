package com.polycoffee.Servlet;

import com.polycoffee.Entity.User;
import com.polycoffee.DAO.UserDAO;
import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {

    private UserDAO dao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user != null) {
            // Đẩy đối tượng user từ session vào request để JSP dùng EL ${item...}
            req.setAttribute("item", user);
            req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
        } else {
            // Chưa đăng nhập thì đá về trang Login
            resp.sendRedirect(req.getContextPath() + "/LoginServlet");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 1. Đồng bộ hóa tiếng Việt
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        try {
            HttpSession session = req.getSession();
            User currentUser = (User) session.getAttribute("user");

            if (currentUser == null) {
                resp.sendRedirect(req.getContextPath() + "/LoginServlet");
                return;
            }

            // 2. Lấy dữ liệu từ Form (name phải khớp với các thẻ <input> trong JSP)
            String fullname = req.getParameter("fullname");
            String password = req.getParameter("password");
            String phone = req.getParameter("phone");
            String email = req.getParameter("email");

            // 3. Cập nhật các giá trị mới vào đối tượng đang giữ trong Session
            currentUser.setFullName(fullname);
            currentUser.setPassword(password);
            currentUser.setPhone(phone);
            currentUser.setEmail(email);

            // 4. Thực thi Update vào SQL Server thông qua DAO
            // (Đảm bảo hàm update trong UserDAO đã nhận thêm tham số Phone)
            dao.update(currentUser);

            // 5. Ghi đè lại đối tượng đã sửa vào Session để các trang khác (Header) cập nhật theo
            session.setAttribute("user", currentUser);

            // 6. Gửi thông báo và dữ liệu về lại trang JSP
            req.setAttribute("message", "Cập nhật thông tin thành công!");
            req.setAttribute("item", currentUser);
            req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
        }
    }
}