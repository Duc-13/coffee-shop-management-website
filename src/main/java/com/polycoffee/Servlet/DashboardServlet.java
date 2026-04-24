package com.polycoffee.Servlet;

import com.polycoffee.Entity.User;
import com.polycoffee.DAO.StatisticDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private StatisticDAO dao = new StatisticDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");

        if(user == null || user.getRole() != 0){
            resp.sendRedirect(req.getContextPath() + "/drink");
            return;
        }

        String fromStr = req.getParameter("from");
        String toStr = req.getParameter("to");

        java.sql.Date sqlFrom;
        java.sql.Date sqlTo;

        // Dịch Chuỗi sang Ngày. Nếu người dùng không nhập thì nhét 1 khoảng thời gian siêu to khổng lồ vào.
        try {
            if (fromStr == null || fromStr.trim().isEmpty()) {
                sqlFrom = java.sql.Date.valueOf("1900-01-01");
            } else {
                sqlFrom = java.sql.Date.valueOf(fromStr);
            }

            if (toStr == null || toStr.trim().isEmpty()) {
                sqlTo = java.sql.Date.valueOf("2100-12-31");
            } else {
                sqlTo = java.sql.Date.valueOf(toStr);
            }
        } catch (Exception e) {
            sqlFrom = java.sql.Date.valueOf("1900-01-01");
            sqlTo = java.sql.Date.valueOf("2100-12-31");
        }

        req.setAttribute("topDrinks", dao.getTop5Drinks(sqlFrom, sqlTo));
        req.setAttribute("revenues", dao.getRevenue(sqlFrom, sqlTo));

        req.getRequestDispatcher("/views/admin/dashboard.jsp").forward(req, resp);
    }
}