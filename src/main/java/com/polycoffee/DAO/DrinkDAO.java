package com.polycoffee.DAO;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import com.polycoffee.Entity.Drink;
import com.polycoffee.Util.JdbcUtil;

public class DrinkDAO {


    public void insert(Drink d) {
        String sql = "INSERT INTO DRINKS (Name, Price, Image, Description, Active, Category_ID) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            JdbcUtil.executeUpdate(sql,
                    d.getName(),
                    d.getPrice(),
                    d.getImage(),
                    d.getDescription(),
                    d.isActive(),
                    d.getCategoryId()
            );
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public List<Drink> findAll() {
        String sql = "SELECT * FROM DRINKS";
        List<Drink> list = new ArrayList<>();

        try {
            ResultSet rs = JdbcUtil.executeQuery(sql);
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }


    public Drink findById(int id) {
        String sql = "SELECT * FROM DRINKS WHERE Drinks_ID = ?";
        try {
            ResultSet rs = JdbcUtil.executeQuery(sql, id);
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    public void update(Drink d) {
        String sql = "UPDATE DRINKS SET Name = ?, Price = ?, Image = ?, Description = ?, Active = ?, Category_ID = ? WHERE Drinks_ID = ?";
        try {
            JdbcUtil.executeUpdate(sql,
                    d.getName(),
                    d.getPrice(),
                    d.getImage(),
                    d.getDescription(),
                    d.isActive(),
                    d.getCategoryId(),
                    d.getDrinksId()
            );
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public void delete(int id) {
        String sql = "DELETE FROM DRINKS WHERE Drinks_ID = ?";
        try {
            JdbcUtil.executeUpdate(sql, id);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Drink> search(String name, int categoryId, int status, int page, int size) {
        String sql = "SELECT * FROM DRINKS WHERE Name LIKE ?";

        if (categoryId != -1) {
            sql += " AND Category_ID = " + categoryId;
        }
        if (status != -1) {
            sql += " AND Active = " + status;
        }

        sql += " ORDER BY Drinks_ID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        List<Drink> list = new ArrayList<>();
        try {
            int offset = (page - 1) * size;

            ResultSet rs = JdbcUtil.executeQuery(
                    sql,
                    "%" + name + "%",
                    offset,
                    size
            );

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ================= COUNT =================
    public int count(String name, int categoryId, int status) {
        String sql = "SELECT COUNT(*) FROM DRINKS WHERE Name LIKE ?";

        if (categoryId != -1) sql += " AND Category_ID = " + categoryId;
        if (status != -1) sql += " AND Active = " + status;

        try {
            ResultSet rs = JdbcUtil.executeQuery(sql, "%" + name + "%");
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ================= MAP RESULTSET =================
    private Drink mapRow(ResultSet rs) throws Exception {
        Drink d = new Drink();
        d.setDrinksId(rs.getInt("Drinks_ID"));
        d.setName(rs.getString("Name"));
        d.setPrice(rs.getInt("Price"));
        d.setActive(rs.getBoolean("Active"));
        d.setCategoryId(rs.getInt("Category_ID"));
        d.setImage(rs.getString("Image"));
        d.setDescription(rs.getString("Description"));
        return d;
    }
}