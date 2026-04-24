package com.polycoffee.DAO;

import java.sql.*;
import java.util.*;
import com.polycoffee.Entity.Bill;
import com.polycoffee.Entity.BillDetail;
import com.polycoffee.Entity.CartItem;
import com.polycoffee.Util.JdbcUtil;

public class BillDAO {


	public int create(Bill bill) {

		String sql = "INSERT INTO BILLS(Code, Total, Status, Users_ID, Payment_Method) OUTPUT Inserted.Bills_ID VALUES (?, ?, ?, ?, ?)";

		try (
				Connection conn = JdbcUtil.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
		) {
			ps.setString(1, bill.getCode());
			ps.setInt(2, bill.getTotal());
			ps.setInt(3, bill.getStatus());
			ps.setInt(4, bill.getUsersId());
			ps.setString(5, bill.getPayment_Method());


			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				return rs.getInt(1);
			}

		} catch (Exception e) {
			System.out.println("LỖI LƯU HÓA ĐƠN SQL SERVER:");
			e.printStackTrace();
		}
		return -1;
	}

	// ================= FIND ALL + PAGINATION =================
	public List<Bill> findAll(int page, int size) {
		String sql = "SELECT * FROM BILLS ORDER BY Created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
		List<Bill> list = new ArrayList<>();

		try (Connection conn = JdbcUtil.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, (page - 1) * size);
			ps.setInt(2, size);

			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				Bill b = new Bill();
				b.setBillsId(rs.getInt("Bills_ID"));
				b.setCode(rs.getString("Code"));
				b.setCreatedAt(rs.getTimestamp("Created_at"));
				b.setTotal(rs.getInt("Total"));
				b.setStatus(rs.getInt("Status"));
				b.setUsersId(rs.getInt("Users_ID"));
				list.add(b);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	// ================= COUNT =================
	public int count() {
		String sql = "SELECT COUNT(*) FROM BILLS";
		try (Connection conn = JdbcUtil.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql);
			 ResultSet rs = ps.executeQuery()) {

			if (rs.next()) return rs.getInt(1);

		} catch (Exception e) {}
		return 0;
	}

	public void complte(int id) {
		String sql = "UPDATE BILLS SET Status = 1 WHERE Bills_ID = ?";
		try (Connection conn = JdbcUtil.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, id);
			ps.executeUpdate();

		} catch (Exception e) {}
	}

	// ================= CANCEL =================
	public void cancel(int id) {
		String sql = "UPDATE BILLS SET Status = -1 WHERE Bills_ID = ?";
		try (Connection conn = JdbcUtil.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, id);
			ps.executeUpdate();

		} catch (Exception e) {}
	}

	// ================= FIND BY ID =================
	public Bill findById(int id) {
		String sql = """
        SELECT b.*, u.Full_name AS FullName
        FROM BILLS b
        JOIN USERS u ON b.Users_ID = u.Users_ID
        WHERE b.Bills_ID = ?
    """;

		try (Connection conn = JdbcUtil.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				Bill b = new Bill();
				b.setBillsId(rs.getInt("Bills_ID"));
				b.setCode(rs.getString("Code"));
				b.setCreatedAt(rs.getTimestamp("Created_at"));
				b.setTotal(rs.getInt("Total"));
				b.setStatus(rs.getInt("Status"));
				b.setUsersId(rs.getInt("Users_ID"));


				b.setFullName(rs.getString("FullName"));

				return b;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	public boolean createBillDetails(int billId, Map<Integer, CartItem> cart) {
		String sql = "INSERT INTO BILL_DETAILS (Bills_ID, Drinks_ID, Quantity, Price) VALUES (?, ?, ?, ?)";

		try (
				Connection conn = JdbcUtil.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
		) {
			for (CartItem item : cart.values()) {
				ps.setInt(1, billId);
				ps.setInt(2, item.getDrinkId());
				ps.setInt(3, item.getQuantity());
				ps.setInt(4, item.getPrice());
				ps.addBatch();
			}

			int[] results = ps.executeBatch();
			return results.length == cart.size();

		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	public List<Bill> findByUserId(int userId) {
		List<Bill> list = new ArrayList<>();
		String sql = "SELECT * FROM BILLS WHERE Users_ID = ? ORDER BY Created_at DESC";

		try (Connection conn = JdbcUtil.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, userId);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Bill b = new Bill();
				b.setBillsId(rs.getInt("Bills_ID"));
				b.setCode(rs.getString("Code"));
				b.setTotal(rs.getInt("Total"));
				b.setStatus(rs.getInt("Status"));
				b.setUsersId(rs.getInt("Users_ID"));
				b.setCreatedAt(rs.getTimestamp("Created_at"));
				list.add(b);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
}