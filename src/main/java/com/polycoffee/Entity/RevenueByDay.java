package com.polycoffee.Entity;
import java.util.Date;

public class RevenueByDay {
    private Date revenueDate;
    private int totalBills;
    private long totalRevenue;

    // Constructor không tham số
    public RevenueByDay() {}

    // Constructor đầy đủ tham số [cite: 528]
    public RevenueByDay(Date revenueDate, int totalBills, long totalRevenue) {
        this.revenueDate = revenueDate;
        this.totalBills = totalBills;
        this.totalRevenue = totalRevenue;
    }

    // Getter và Setter [cite: 529, 530]
    public Date getRevenueDate() { return revenueDate; }
    public void setRevenueDate(Date revenueDate) { this.revenueDate = revenueDate; }

    public int getTotalBills() { return totalBills; }
    public void setTotalBills(int totalBills) { this.totalBills = totalBills; }

    public long getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(long totalRevenue) { this.totalRevenue = totalRevenue; }
}