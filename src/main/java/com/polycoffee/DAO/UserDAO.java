package com.polycoffee.DAO;

import java.sql.*;
import java.util.*;
import com.polycoffee.Entity.User;
import com.polycoffee.Util.JdbcUtil;

public class UserDAO {

    private static final int  MAX_ATTEMPTS  = 5;
    private static final long LOCK_MINUTES  = 5;

    // ── Đăng nhập (chỉ tìm theo email — KHÔNG kiểm tra pass ở đây) ──
    // Trả về User nếu tìm thấy email, null nếu không có
    public User findByEmail(String email) {
        String sql = "SELECT * FROM USERS WHERE RTRIM(Email) = ?";
        try {
            ResultSet rs = JdbcUtil.executeQuery(sql, email);
            if (rs.next()) return mapFull(rs);
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // ── Ghi nhận đăng nhập sai → tăng failed_attempts, có thể set khóa ──
    public void recordFailedAttempt(String email) {
        // Lấy số lần sai hiện tại
        String selectSql = "SELECT Failed_Attempts FROM USERS WHERE RTRIM(Email) = ?";
        int current = 0;
        try {
            ResultSet rs = JdbcUtil.executeQuery(selectSql, email);
            if (rs.next()) current = rs.getInt("Failed_Attempts");
        } catch (Exception e) { e.printStackTrace(); }

        int newAttempts = current + 1;

        if (newAttempts >= MAX_ATTEMPTS) {
            // Khóa: set Locked_Until = bây giờ + 5 phút
            Timestamp lockUntil = new Timestamp(
                    System.currentTimeMillis() + LOCK_MINUTES * 60 * 1000L
            );
            String updateSql = "UPDATE USERS SET Failed_Attempts = ?, Locked_Until = ? WHERE RTRIM(Email) = ?";
            JdbcUtil.executeUpdate(updateSql, newAttempts, lockUntil, email);
        } else {
            // Chưa đủ ngưỡng, chỉ tăng đếm
            String updateSql = "UPDATE USERS SET Failed_Attempts = ? WHERE RTRIM(Email) = ?";
            JdbcUtil.executeUpdate(updateSql, newAttempts, email);
        }
    }

    // ── Reset đếm sau khi đăng nhập thành công ───────────────────────
    public void resetFailedAttempts(String email) {
        String sql = "UPDATE USERS SET Failed_Attempts = 0, Locked_Until = NULL WHERE RTRIM(Email) = ?";
        JdbcUtil.executeUpdate(sql, email);
    }

    // ── Hàm login cũ (giữ lại để không ảnh hưởng code khác) ─────────
    public User login(String email, String pass) {
        String sql = "SELECT * FROM USERS WHERE RTRIM(Email)=? AND RTRIM(Password)=?";
        try {
            ResultSet rs = JdbcUtil.executeQuery(sql, email, pass);
            if (rs.next()) return mapFull(rs);
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // ── Các hàm cũ giữ nguyên ────────────────────────────────────────

    public List<User> findStaff(String name, String email, int role, int page, int size) {
        String sql = "SELECT * FROM USERS WHERE Full_name LIKE ? AND Email LIKE ? "
                + "AND (Role = ? OR ? = -1) ORDER BY Users_ID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        List<User> list = new ArrayList<>();
        try {
            ResultSet rs = JdbcUtil.executeQuery(sql, "%"+name+"%", "%"+email+"%", role, role, (page-1)*size, size);
            while (rs.next()) {
                User u = new User();
                u.setUsersId(rs.getInt("Users_ID"));
                u.setFullName(rs.getString("Full_name"));
                u.setEmail(rs.getString("Email"));
                u.setRole(rs.getInt("Role"));
                list.add(u);
            }
        } catch (Exception e) {} return list;
    }

    public int countStaff(String name, String email, int role) {
        String sql = "SELECT COUNT(*) FROM USERS WHERE Full_name LIKE ? AND Email LIKE ? AND (Role = ? OR ? = -1)";
        try {
            ResultSet rs = JdbcUtil.executeQuery(sql, "%"+name+"%", "%"+email+"%", role, role);
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {} return 0;
    }

    public boolean updatePass(String email, String newPass) {
        return JdbcUtil.executeUpdate("UPDATE USERS SET Password=? WHERE Email=?", newPass, email) > 0;
    }

    public User findById(int id) {
        String sql = "SELECT * FROM USERS WHERE Users_ID = ?";
        try {
            ResultSet rs = JdbcUtil.executeQuery(sql, id);
            if (rs.next()) return mapFull(rs);
        } catch (Exception e) {}
        return null;
    }

    public void create(User u) {
        String sql = "INSERT INTO USERS (Full_name, Email, Password, Role, Phone, Active) VALUES (?, ?, ?, ?, ?, ?)";
        JdbcUtil.executeUpdate(sql, u.getFullName(), u.getEmail(), u.getPassword(), u.getRole(), "", true);
    }

    public void update(User u) {
        String sql = "UPDATE USERS SET Full_name=?, Email=?, Password=?, Phone=?, Role=? WHERE Users_ID=?";
        JdbcUtil.executeUpdate(sql, u.getFullName(), u.getEmail(), u.getPassword(), u.getPhone(), u.getRole(), u.getUsersId());
    }

    public void deleteById(int id) {
        JdbcUtil.executeUpdate("DELETE FROM USERS WHERE Users_ID=?", id);
    }

    // ── Helper: map ResultSet → User (bao gồm cả lockout fields) ─────
    private User mapFull(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUsersId(rs.getInt("Users_ID"));
        u.setFullName(rs.getString("Full_name"));
        u.setEmail(rs.getString("Email"));
        u.setPassword(rs.getString("Password"));
        u.setRole(rs.getInt("Role"));
        // Lockout — dùng try/catch riêng: nếu chưa chạy SQL thêm cột thì không bị crash
        try {
            u.setFailedAttempts(rs.getInt("Failed_Attempts"));
            u.setLockedUntil(rs.getTimestamp("Locked_Until"));
        } catch (Exception ignored) {}
        return u;
    }
}