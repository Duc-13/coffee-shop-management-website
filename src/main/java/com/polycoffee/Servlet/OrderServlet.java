package com.polycoffee.Servlet;

import com.polycoffee.DAO.BillDAO;
import com.polycoffee.Entity.CartItem;
import com.polycoffee.Entity.Bill;
import com.polycoffee.Entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet({"/order/checkout", "/order/success"})
public class OrderServlet extends HttpServlet {

    private BillDAO billDAO = new BillDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();

        try {
            User user = (User) session.getAttribute("user");
            if (user == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }


            CartItem buyNowItem = (CartItem) session.getAttribute("buyNowItem");
            Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");

            Map<Integer, CartItem> itemsToPay;


            if (buyNowItem != null) {

                itemsToPay = new HashMap<>();
                itemsToPay.put(buyNowItem.getDrinkId(), buyNowItem);
            } else {

                itemsToPay = cart;
            }

            // Nếu không có gì để thanh toán -> Đẩy về giỏ hàng
            if (itemsToPay == null || itemsToPay.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/cart");
                return;
            }


            int total = itemsToPay.values().stream()
                    .mapToInt(i -> (int) (i.getPrice() * i.getQuantity()))
                    .sum();

            String method = req.getParameter("paymentMethod");
            if (method == null) method = "Tiền mặt";

            Bill bill = new Bill();
            bill.setCode("PC" + System.currentTimeMillis());
            bill.setTotal(total);
            bill.setStatus(0);
            bill.setUsersId(user.getUsersId());
            bill.setPayment_Method(method);

            int billId = billDAO.create(bill);


            if (billId != -1) {
                billDAO.createBillDetails(billId, itemsToPay);


                session.setAttribute("lastCart", new HashMap<>(itemsToPay));
                session.setAttribute("lastTotal", total); // Gửi tổng tiền sang trang success


                if (buyNowItem != null) {
                    session.removeAttribute("buyNowItem");
                } else {
                    session.removeAttribute("cart");
                    session.removeAttribute("cartCount");
                }

                resp.sendRedirect(req.getContextPath() + "/order/success");
            } else {
                resp.sendRedirect(req.getContextPath() + "/cart?error=1");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/cart?error=1");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String uri = req.getRequestURI();
        if (uri.contains("success")) {
            HttpSession session = req.getSession();

            if (session.getAttribute("lastCart") == null) {
                resp.sendRedirect(req.getContextPath() + "/cart");
                return;
            }
            req.getRequestDispatcher("/views/user/order-success.jsp").forward(req, resp);
        } else if (uri.contains("checkout")) {
            resp.sendRedirect(req.getContextPath() + "/cart");
        }
    }
}