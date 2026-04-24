package com.polycoffee.DAO;

import com.polycoffee.Entity.BestSellingDrink;
import com.polycoffee.Entity.RevenueByDay;
import com.polycoffee.Util.JdbcUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StatisticDAO {

    // Bài 2: Thống kê 5 món bán chạy nhất [cite: 487, 536]
    public List<BestSellingDrink> getTop5Drinks(java.sql.Date fromDate, java.sql.Date toDate) {
        List<BestSellingDrink> list = new ArrayList<>();
        String sql = "{CALL sp_top_5_best_selling_drinks(?, ?)}";
        try (ResultSet rs = JdbcUtil.executeQuery(sql, fromDate, toDate)) {
            while (rs.next()) {
                list.add(new BestSellingDrink(
                        rs.getInt("drink_id"),
                        rs.getString("drink_name"),
                        rs.getInt("total_quantity_sold"),
                        rs.getLong("total_revenue")
                ));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Bài 3: Thống kê doanh thu theo ngày [cite: 518, 555]
    public List<RevenueByDay> getRevenue(java.sql.Date fromDate, java.sql.Date toDate) {
        List<RevenueByDay> list = new ArrayList<>();
        String sql = "{CALL sp_revenue_by_day(?, ?)}";
        try (ResultSet rs = JdbcUtil.executeQuery(sql, fromDate, toDate)) {
            while (rs.next()) {
                list.add(new RevenueByDay(
                        rs.getDate("revenue_date"),
                        rs.getInt("total_bills"),
                        rs.getLong("total_revenue")
                ));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}