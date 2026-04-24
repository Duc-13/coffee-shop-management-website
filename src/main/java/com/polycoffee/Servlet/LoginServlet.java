package com.polycoffee.Servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.polycoffee.Entity.User;
import com.polycoffee.DAO.UserDAO;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    UserDAO dao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email");
        String pass  = req.getParameter("password");

        // 1. Tìm user theo email (không quan tâm pass trước)
        User u = dao.findByEmail(email);

        // 2. Email không tồn tại
        if (u == null) {
            req.setAttribute("error", "Email không tồn tại trong hệ thống!");
            req.setAttribute("emailValue", email);
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
            return;
        }

        // 3. Tài khoản đang bị khóa?
        if (u.isCurrentlyLocked()) {
            long secs = u.getRemainingLockSeconds();
            req.setAttribute("error",     buildLockMessage(secs));
            req.setAttribute("remaining", secs);
            req.setAttribute("emailValue", email);
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
            return;
        }

        // 4. Kiểm tra mật khẩu
        boolean passOk = u.getPassword() != null && u.getPassword().trim().equals(pass.trim());

        if (!passOk) {
            // Ghi nhận lần sai vào DB (DAO tự tính có khóa không)
            dao.recordFailedAttempt(email);

            // Đọc lại trạng thái mới nhất từ DB
            User updated = dao.findByEmail(email);
            int attempts = updated != null ? updated.getFailedAttempts() : (u.getFailedAttempts() + 1);

            String errMsg;
            if (updated != null && updated.isCurrentlyLocked()) {
                long secs = updated.getRemainingLockSeconds();
                req.setAttribute("remaining", secs);
                errMsg = "Bạn đã nhập sai " + attempts + " lần. " + buildLockMessage(secs);
            } else {
                int left = 5 - attempts;
                errMsg = "Sai mật khẩu! Còn " + left + " lần thử trước khi tài khoản bị khóa.";
            }

            req.setAttribute("error",      errMsg);
            req.setAttribute("emailValue", email);
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);

        } else {
            // 5. Đăng nhập thành công → reset đếm
            dao.resetFailedAttempts(email);
            req.getSession().setAttribute("user", u);
            resp.sendRedirect(req.getContextPath() + "/dashboard");
        }
    }

    private String buildLockMessage(long secs) {
        long m = secs / 60, s = secs % 60;
        String time = m > 0 ? m + " phút " + s + " giây" : s + " giây";
        return "Tài khoản bị khóa! Vui lòng thử lại sau " + time + ".";
    }
}