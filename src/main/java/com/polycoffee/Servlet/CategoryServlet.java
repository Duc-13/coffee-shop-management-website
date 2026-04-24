package com.polycoffee.Servlet;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.polycoffee.DAO.CategoryDAO;
import com.polycoffee.Entity.Category;
import com.polycoffee.Entity.User;

@WebServlet("/category")
public class CategoryServlet extends HttpServlet {

	CategoryDAO dao = new CategoryDAO();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		User u = (User) req.getSession().getAttribute("user");

		if (u == null || u.getRole() != 0) {
			resp.sendRedirect(req.getContextPath() + "/home");
			return;
		}

		String action = req.getParameter("action");

		//LOAD FORM EDIT
		if ("edit".equals(action)) {
			int id = Integer.parseInt(req.getParameter("id"));
			Category c = dao.findById(id);
			req.setAttribute("item", c);
		}

		// Delete
		if ("delete".equals(action)) {
			int id = Integer.parseInt(req.getParameter("id"));
			dao.deleteById(id);
			resp.sendRedirect("category");
			return;
		}

		// LOAD LIST
		req.setAttribute("list", dao.findAll());
		req.getRequestDispatcher("/views/admin/category.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		String action = req.getParameter("action");

		String name = req.getParameter("name");
		boolean active = req.getParameter("active") != null;

		Category c = new Category();
		c.setName(name);
		c.setActive(active);

		// CREATE
		if ("create".equals(action)) {
			dao.create(c);
		}

		// UPDATE
		if ("update".equals(action)) {
			int id = Integer.parseInt(req.getParameter("id"));
			c.setCategoryId(id);
			dao.update(c);
		}

		resp.sendRedirect("category");
	}
}