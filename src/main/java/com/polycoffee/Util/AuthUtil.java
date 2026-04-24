package com.polycoffee.Util;

import javax.servlet.http.*;
import com.polycoffee.Entity.User;

public class AuthUtil {

    public static final String SESSION_USER = "user";

    public static void setUser(HttpServletRequest request, User user) {
        request.getSession().setAttribute(SESSION_USER, user);
    }

    public static User getUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null ? (User) session.getAttribute(SESSION_USER) : null;
    }

    public static boolean isAuthenticated(HttpServletRequest request) {
        return getUser(request) != null;
    }

    public static boolean isAdmin(HttpServletRequest request) {
        User u = getUser(request);
        return u != null && u.getRole() == 0;
    }

    public static boolean isStaff(HttpServletRequest request) {
        User u = getUser(request);
        return u != null && u.getRole() == 1;
    }
    public static void clear(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) session.invalidate();
    }
}