package com.polycoffee.Servlet;

import com.polycoffee.DAO.DrinkDAO;
import com.polycoffee.Entity.CartItem;
import com.polycoffee.Entity.Drink;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet({"/cart", "/cart/*"})
public class CartServlet extends HttpServlet {

    private DrinkDAO drinkDAO = new DrinkDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();

        if (uri.contains("cancel-buynow")) {
            req.getSession().removeAttribute("buyNowItem");
            resp.sendRedirect(req.getContextPath() + "/cart");
        } else if (uri.endsWith("/cart") || uri.endsWith("/cart/") || uri.contains("view")) {
            req.getRequestDispatcher("/views/user/cart.jsp").forward(req, resp);
        } else if (uri.contains("remove")) {
            removeItem(req, resp);
        } else if (uri.contains("update")) {
            updateItem(req, resp);
        }
    }

    // ĐÃ MỞ KHÓA DOPOST - NGUYÊN NHÂN GÂY TRẮNG MÀN HÌNH
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        if (uri.contains("add")) {
            addItem(req, resp);
        }
    }

    private void addItem(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        try {
            int drinkId = Integer.parseInt(req.getParameter("drinkId"));
            int quantity = Integer.parseInt(req.getParameter("quantity"));
            String redirect = req.getParameter("redirect");
            HttpSession session = req.getSession();
            Drink drink = drinkDAO.findById(drinkId);

            if (drink == null) { resp.sendRedirect(req.getContextPath() + "/drink"); return; }

            // ================= LUỒNG "MUA NGAY" =================
            if ("checkout".equals(redirect)) {
                CartItem buyNowItem = new CartItem();
                buyNowItem.setDrinkId(drink.getDrinksId());
                buyNowItem.setName(drink.getName());
                buyNowItem.setPrice(drink.getPrice());
                buyNowItem.setImage(drink.getImage());
                buyNowItem.setQuantity(quantity);

                session.setAttribute("buyNowItem", buyNowItem);
                resp.sendRedirect(req.getContextPath() + "/cart");
                return;
            }

            // ================= LUỒNG "THÊM VÀO GIỎ" =================
            Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
            if (cart == null) cart = new HashMap<>();

            if (cart.containsKey(drinkId)) {
                CartItem item = cart.get(drinkId);
                item.setQuantity(item.getQuantity() + quantity);
            } else {
                CartItem item = new CartItem();
                item.setDrinkId(drink.getDrinksId());
                item.setName(drink.getName());
                item.setPrice(drink.getPrice());
                item.setImage(drink.getImage());
                item.setQuantity(quantity);
                cart.put(drinkId, item);
            }

            session.setAttribute("cart", cart);
            int totalItems = cart.values().stream().mapToInt(CartItem::getQuantity).sum();
            session.setAttribute("cartCount", totalItems);

            if ("menu".equals(redirect)) {
                session.setAttribute("message", "Đã thêm món thành công!");
                resp.sendRedirect(req.getContextPath() + "/drink");
            } else {
                resp.sendRedirect(req.getContextPath() + "/cart");
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (!resp.isCommitted()) resp.sendRedirect(req.getContextPath() + "/drink?error=1");
        }
    }

    private void removeItem(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int drinkId = Integer.parseInt(req.getParameter("id"));
        HttpSession session = req.getSession();
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");

        if (cart != null) {
            cart.remove(drinkId);
            session.setAttribute("cart", cart);
            int totalItems = cart.values().stream().mapToInt(CartItem::getQuantity).sum();
            session.setAttribute("cartCount", totalItems);
        }
        resp.sendRedirect(req.getContextPath() + "/cart");
    }

    private void updateItem(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int drinkId = Integer.parseInt(req.getParameter("id"));
        int qtyChange = Integer.parseInt(req.getParameter("qty"));

        HttpSession session = req.getSession();
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");

        if (cart != null && cart.containsKey(drinkId)) {
            CartItem item = cart.get(drinkId);
            int newQty = item.getQuantity() + qtyChange;

            if (newQty > 0) {
                item.setQuantity(newQty);
            } else {
                cart.remove(drinkId);
            }

            session.setAttribute("cart", cart);
            int totalItems = cart.values().stream().mapToInt(CartItem::getQuantity).sum();
            session.setAttribute("cartCount", totalItems);
        }
        resp.sendRedirect(req.getContextPath() + "/cart");
    }
}