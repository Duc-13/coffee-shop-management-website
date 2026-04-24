package com.polycoffee.DAO;

import java.sql.*;
import java.util.*;
import com.polycoffee.Entity.Category;
import com.polycoffee.Util.JdbcUtil;

public class CategoryDAO implements CrudDAO<Category, Integer> {

    @Override
    public List<Category> findAll() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM CATEGORY";

        try (
                Connection conn = JdbcUtil.getConnection();
                Statement st = conn.createStatement();
                ResultSet rs = st.executeQuery(sql);
        ) {
            while (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getInt("Category_ID"));
                c.setName(rs.getString("Name"));
                c.setActive(rs.getBoolean("Active"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Category findById(Integer id) {
        String sql = "SELECT * FROM CATEGORY WHERE Category_ID=?";

        try (
                Connection conn = JdbcUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
        ) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getInt("Category_ID"));
                c.setName(rs.getString("Name"));
                c.setActive(rs.getBoolean("Active"));
                return c;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int create(Category c) {
        String sql = "INSERT INTO CATEGORY(Name, Active) VALUES (?, ?)";

        try (
                Connection conn = JdbcUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
        ) {
            ps.setString(1, c.getName());
            ps.setBoolean(2, c.isActive());
            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int update(Category c) {
        String sql = "UPDATE CATEGORY SET Name=?, Active=? WHERE Category_ID=?";

        try (
                Connection conn = JdbcUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
        ) {
            ps.setString(1, c.getName());
            ps.setBoolean(2, c.isActive());
            ps.setInt(3, c.getCategoryId());
            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int deleteById(Integer id) {
        String sql = "DELETE FROM CATEGORY WHERE Category_ID=?";

        try (
                Connection conn = JdbcUtil.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
        ) {
            ps.setInt(1, id);
            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}