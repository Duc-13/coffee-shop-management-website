package com.polycoffee.Util;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;

@WebFilter("/*")
public class AuthFilter implements Filter {

	@Override
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest request = (HttpServletRequest) req;
		HttpServletResponse response = (HttpServletResponse) res;

		String uri = request.getRequestURI();

		// Cho phép các trang public
		if (uri.contains("login")
				|| uri.contains("register")
				|| uri.contains("forgot-pass")
				|| uri.contains("css")
				|| uri.contains("js")
				|| uri.contains("images")) {

			chain.doFilter(req, res);
			return;
		}

		// Chưa đăng nhập → về login
		if (!AuthUtil.isAuthenticated(request)) {
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}

		// Phân quyền admin
		if (uri.contains("/admin") && !AuthUtil.isAdmin(request)) {
			response.sendRedirect(request.getContextPath() + "/home");
			return;
		}

		// Phân quyền staff
		if (uri.contains("/staff")
				&& !(AuthUtil.isStaff(request) || AuthUtil.isAdmin(request))) {

			response.sendRedirect(request.getContextPath() + "/home");
			return;
		}

		// Cho đi tiếp
		chain.doFilter(req, res);
	}
}