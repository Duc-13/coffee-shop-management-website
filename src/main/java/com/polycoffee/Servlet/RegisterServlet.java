package com.polycoffee.Servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.polycoffee.DAO.UserDAO;
import com.polycoffee.Entity.User;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    UserDAO dao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String fullname = req.getParameter("fullname");
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        try {
            User u = new User();
            u.setFullName(fullname);
            u.setEmail(email);
            u.setPassword(password);
            u.setRole(2); // CUSTOMER

            dao.create(u);

            resp.sendRedirect(req.getContextPath() + "/login");

        } catch (Exception e) {
            req.setAttribute("error", "Email đã tồn tại!");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
        }
    }
}