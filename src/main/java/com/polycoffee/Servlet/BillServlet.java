package com.polycoffee.Servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.polycoffee.DAO.*;
import com.polycoffee.Entity.*;

@WebServlet("/bill")
public class BillServlet extends HttpServlet {

    BillDAO billDAO = new BillDAO();
    BillDetailDAO detailDAO = new BillDetailDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User u = (User) req.getSession().getAttribute("user");

        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");

        // ================= ADMIN =================
        if (u.getRole() == 0) {

            // DETAIL
            if ("detail".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));

                Bill bill = billDAO.findById(id);
                List<BillDetail> details = detailDAO.findByBillId(id);

                req.setAttribute("bill", bill);
                req.setAttribute("details", details);

                req.getRequestDispatcher("/views/admin/bill-detail.jsp").forward(req, resp);
                return;
            }

            if ("complete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                billDAO.complte(id);
                resp.sendRedirect(req.getContextPath() + "/bill");
                return;
            }


            if ("cancel".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                billDAO.cancel(id);
                resp.sendRedirect(req.getContextPath() + "/bill");
                return;
            }

            // LIST
            int page = 1;
            int size = 10;

            if (req.getParameter("page") != null) {
                page = Integer.parseInt(req.getParameter("page"));
            }

            List<Bill> list = billDAO.findAll(page, size);
            int total = billDAO.count();
            int totalPages = (int) Math.ceil((double) total / size);

            req.setAttribute("list", list);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);

            req.getRequestDispatcher("/views/admin/bill.jsp").forward(req, resp);
            return;
        }

        // ================= STAFF (Vai trò nhân viên) =================
        if (u.getRole() == 1) {
            // THÊM ĐOẠN NÀY: Xử lý các nút bấm thay đổi trạng thái
            if ("complete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                billDAO.complte(id); // Nhớ kiểm tra trong DAO là 'complte' hay 'complete'
                resp.sendRedirect(req.getContextPath() + "/bill");
                return;
            }

            if ("cancel".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                billDAO.cancel(id);
                resp.sendRedirect(req.getContextPath() + "/bill");
                return;
            }

            // Xử lý xem chi tiết đơn hàng cho Staff (Giữ nguyên của bạn)
            if ("detail".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Bill bill = billDAO.findById(id);

                if (bill != null && bill.getUsersId() == u.getUsersId()) {
                    List<BillDetail> details = detailDAO.findByBillId(id);
                    req.setAttribute("bill", bill);
                    req.setAttribute("details", details);
                    req.getRequestDispatcher("/views/staff/bill-detail.jsp").forward(req, resp);
                    return;
                }
            }

            // LẤY DANH SÁCH ĐƠN HÀNG (Giữ nguyên của bạn)
            List<Bill> list = billDAO.findByUserId(u.getUsersId());
            req.setAttribute("list", list);
            req.getRequestDispatcher("/views/staff/bill.jsp").forward(req, resp);
            return;
        }

        // ================= USER =================
        if (u.getRole() == 2) {


            if ("detail".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Bill bill = billDAO.findById(id);


                if (bill != null && bill.getUsersId() == u.getUsersId()) {
                    List<BillDetail> details = detailDAO.findByBillId(id);
                    req.setAttribute("bill", bill);
                    req.setAttribute("details", details);

                    req.getRequestDispatcher("/views/user/bill-detail.jsp").forward(req, resp);
                    return;
                }
            }


            List<Bill> list = billDAO.findByUserId(u.getUsersId());
            req.setAttribute("list", list);
            req.getRequestDispatcher("/views/user/bill.jsp").forward(req, resp);
            return;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        User u = (User) req.getSession().getAttribute("user");

        if ("create".equals(action)) {
            try {
                Bill b = new Bill();
                b.setCode(req.getParameter("code"));
                b.setTotal(Integer.parseInt(req.getParameter("total")));
                b.setStatus(Integer.parseInt(req.getParameter("status")));

                // Lấy phương thức thanh toán từ form (Tiền mặt/Chuyển khoản)
                b.setPayment_Method(req.getParameter("paymentMethod"));

                // DÙNG CHUNG: Luôn lưu ID của người đang thực hiện thao tác vào cột UsersId
                // Nếu là khách tự đặt -> Lưu ID khách
                // Nếu là nhân viên bán tại quầy -> Lưu ID nhân viên
                b.setUsersId(u.getUsersId());

                // QUAN TRỌNG: Phải gọi DAO để insert vào Database
                billDAO.create(b);

                // Nếu thành công, có thể gán thông báo
                req.getSession().setAttribute("message", "Tạo hóa đơn thành công!");

            } catch (Exception e) {
                e.printStackTrace();
            }
            resp.sendRedirect(req.getContextPath() + "/bill");
        }
    }
}