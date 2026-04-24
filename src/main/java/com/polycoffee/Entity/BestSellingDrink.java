package com.polycoffee.Entity;

public class BestSellingDrink {
    private int drinkId;
    private String drinkName;
    private int totalQuantitySold;
    private long totalRevenue;

    // Constructor không tham số
    public BestSellingDrink() {}

    // Constructor đầy đủ tham số [cite: 522]
    public BestSellingDrink(int drinkId, String drinkName, int totalQuantitySold, long totalRevenue) {
        this.drinkId = drinkId;
        this.drinkName = drinkName;
        this.totalQuantitySold = totalQuantitySold;
        this.totalRevenue = totalRevenue;
    }

    // Getter và Setter [cite: 523, 524]
    public int getDrinkId() { return drinkId; }
    public void setDrinkId(int drinkId) { this.drinkId = drinkId; }

    public String getDrinkName() { return drinkName; }
    public void setDrinkName(String drinkName) { this.drinkName = drinkName; }

    public int getTotalQuantitySold() { return totalQuantitySold; }
    public void setTotalQuantitySold(int totalQuantitySold) { this.totalQuantitySold = totalQuantitySold; }

    public long getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(long totalRevenue) { this.totalRevenue = totalRevenue; }
}