package com.polycoffee.Servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.polycoffee.DAO.UserDAO;

@WebServlet("/forgot-pass")
public class ForgotPassServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    UserDAO dao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/views/forgot.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String newPass = req.getParameter("newpass");
        String confirmPass = req.getParameter("confirmpass");

        // CHECK CONFIRM PASSWORD (SERVER)
        if (!newPass.equals(confirmPass)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            req.getRequestDispatcher("/views/forgot.jsp").forward(req, resp);
            return;
        }

        boolean result = dao.updatePass(email, newPass);

        if (result) {
            req.setAttribute("msg", "Đổi mật khẩu thành công!");
        } else {
            req.setAttribute("error", "Email không tồn tại!");
        }

        req.getRequestDispatcher("/views/forgot.jsp").forward(req, resp);
    }
}