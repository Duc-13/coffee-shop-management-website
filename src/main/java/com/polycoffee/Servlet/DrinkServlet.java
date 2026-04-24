package com.polycoffee.Servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.polycoffee.DAO.CategoryDAO;
import com.polycoffee.DAO.DrinkDAO;
import com.polycoffee.Entity.Category;
import com.polycoffee.Entity.Drink;
import com.polycoffee.Entity.User;

@MultipartConfig
@WebServlet({"/drink", "/drink/edit", "/drink/delete", "/drink/save"})
public class DrinkServlet extends HttpServlet {

    DrinkDAO dao = new DrinkDAO();
    CategoryDAO cdao = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String uri = req.getRequestURI();

        // 🔐 CHECK LOGIN
        User u = (User) req.getSession().getAttribute("user");
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 📂 CATEGORY (cho admin filter)
        List<Category> categories = cdao.findAll();
        req.setAttribute("categories", categories);

        // 🗑 DELETE (ADMIN ONLY)
        if (uri.contains("delete")) {
            if (u.getRole() != 0) {
                resp.sendRedirect(req.getContextPath() + "/drink");
                return;
            }

            try {
                String idStr = req.getParameter("id");
                if (idStr != null && !idStr.isEmpty()) {
                    dao.delete(Integer.parseInt(idStr));
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            resp.sendRedirect(req.getContextPath() + "/drink");
            return;
        }

        // ✏ EDIT (ADMIN ONLY)
        if (uri.contains("edit")) {
            if (u.getRole() != 0) {
                resp.sendRedirect(req.getContextPath() + "/drink");
                return;
            }

            try {
                String idStr = req.getParameter("id");
                if (idStr != null && !idStr.isEmpty()) {
                    Drink d = dao.findById(Integer.parseInt(idStr));
                    req.setAttribute("drinkDetail", d);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // 🔍 SEARCH + FILTER
        String name = req.getParameter("name") == null ? "" : req.getParameter("name");

        String cateParam = req.getParameter("categoryId");
        int categoryId = (cateParam == null || cateParam.isEmpty()) ? -1 : Integer.parseInt(cateParam);

        String statusParam = req.getParameter("status");
        int status = (statusParam == null || statusParam.isEmpty()) ? -1 : Integer.parseInt(statusParam);

        // 📄 PAGINATION
        int page = 1;
        try {
            String pageStr = req.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                page = Integer.parseInt(pageStr);
            }
        } catch (Exception e) {
            page = 1;
        }

        int pageSize = 10;

        List<Drink> list = dao.search(name, categoryId, status, page, pageSize);
        int totalDrinks = dao.count(name, categoryId, status);
        int totalPages = (int) Math.ceil((double) totalDrinks / pageSize);

        // 📦 DATA SEND TO VIEW
        req.setAttribute("drinkList", list); // admin/staff
        req.setAttribute("list", list);      // user menu
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("currentPage", page);
        req.setAttribute("name", name);
        req.setAttribute("categoryId", categoryId);
        req.setAttribute("status", status);

        // 🎯 ROLE BASED VIEW
        if (u.getRole() == 0) {
            req.getRequestDispatcher("/views/admin/drink.jsp").forward(req, resp);
        } else if (u.getRole() == 1) {
            req.getRequestDispatcher("/views/staff/drink.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/views/user/menu.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String uri = req.getRequestURI();

        // 🔐 CHECK LOGIN
        User u = (User) req.getSession().getAttribute("user");
        if (u == null || u.getRole() != 0) {
            resp.sendRedirect(req.getContextPath() + "/drink");
            return;
        }

        // 💾 SAVE (ADMIN ONLY)
        if (uri.contains("save")) {
            try {
                String idStr = req.getParameter("id");
                String drinkName = req.getParameter("drinkName");
                String priceStr = req.getParameter("price");
                String description = req.getParameter("description");
                String categoryIdStr = req.getParameter("categoryId");
                boolean active = req.getParameter("active") != null;

                if (drinkName == null || drinkName.isEmpty() ||
                        priceStr == null || priceStr.isEmpty() ||
                        categoryIdStr == null || categoryIdStr.isEmpty()) {

                    resp.sendRedirect(req.getContextPath() + "/drink?error=missing_data");
                    return;
                }

                Drink d = new Drink();
                d.setName(drinkName);
                d.setPrice(Integer.parseInt(priceStr.trim()));
                d.setDescription(description);
                d.setCategoryId(Integer.parseInt(categoryIdStr.trim()));
                d.setActive(active);

                // 📷 IMAGE UPLOAD
                Part part = req.getPart("imageFile");
                String fileName = (part != null) ? part.getSubmittedFileName() : "";

                if (fileName != null && !fileName.isEmpty()) {
                    fileName = java.nio.file.Paths.get(fileName).getFileName().toString();
                    String uniqueFileName = System.currentTimeMillis() + "_" + fileName;

                    d.setImage(uniqueFileName);

                    String uploadPath = req.getServletContext().getRealPath("/images");
                    java.io.File uploadDir = new java.io.File(uploadPath);

                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }

                    java.nio.file.Path filePath =
                            new java.io.File(uploadDir, uniqueFileName).toPath();

                    try (java.io.InputStream inputStream = part.getInputStream()) {
                        java.nio.file.Files.copy(inputStream, filePath,
                                java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                    }

                } else {
                    d.setImage(req.getParameter("currentImage"));
                }

                // ➕ INSERT / UPDATE
                if (idStr == null || idStr.trim().isEmpty() || idStr.trim().equals("0")) {
                    dao.insert(d);
                } else {
                    d.setDrinksId(Integer.parseInt(idStr.trim()));
                    dao.update(d);
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        resp.sendRedirect(req.getContextPath() + "/drink");
    }
}