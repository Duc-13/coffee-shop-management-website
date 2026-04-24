package com.polycoffee.DAO;

import java.sql.*;
import java.util.*;
import com.polycoffee.Entity.BillDetail;
import com.polycoffee.Util.JdbcUtil;

public class BillDetailDAO {

	public void create(BillDetail bd) {
		String sql = "INSERT INTO BILL_DETAILS(Bills_ID, Drinks_ID, Quantity, Price) VALUES (?, ?, ?, ?)";

		try (
				Connection conn = JdbcUtil.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
		) {
			ps.setInt(1, bd.getBillsId());
			ps.setInt(2, bd.getDrinksId());
			ps.setInt(3, bd.getQuantity());
			ps.setInt(4, bd.getPrice());

			ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// ================= FIND BY BILL =================
	public List<BillDetail> findByBillId(int billId) {
		String sql = """
        SELECT bd.*, d.Name AS drink_name
        FROM BILL_DETAILS bd
        JOIN DRINKS d ON bd.Drinks_ID = d.Drinks_ID
        WHERE bd.Bills_ID = ?
    """;

		List<BillDetail> list = new ArrayList<>();

		try (Connection conn = JdbcUtil.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, billId);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				BillDetail bd = new BillDetail();
				bd.setBillsId(rs.getInt("Bills_ID"));
				bd.setDrinksId(rs.getInt("Drinks_ID"));
				bd.setQuantity(rs.getInt("Quantity"));
				bd.setPrice(rs.getInt("Price"));

				// FIX CHUẨN
				bd.setDrinkName(rs.getString("drink_name"));

				list.add(bd);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}
	}