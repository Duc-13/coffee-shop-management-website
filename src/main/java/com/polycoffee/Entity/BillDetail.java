package com.polycoffee.Entity;

public class BillDetail {
	private int billsId;
	private int drinksId;
	private int quantity;
	private int price;
	private String drinkName;

	public BillDetail() {}

	public BillDetail(int billsId, int drinksId, int quantity, int price) {
		this.billsId = billsId;
		this.drinksId = drinksId;
		this.quantity = quantity;
		this.price = price;
	}

	public int getBillsId() {
		return billsId;
	}

	public void setBillsId(int billsId) {
		this.billsId = billsId;
	}

	public int getDrinksId() {
		return drinksId;
	}

	public void setDrinksId(int drinksId) {
		this.drinksId = drinksId;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}

	//
	public String getDrinkName() {
		return drinkName;
	}

	public void setDrinkName(String drinkName) {
		this.drinkName = drinkName;
	}
}