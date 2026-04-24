package com.polycoffee.Entity;

public class Drink {
    private int drinksId;
    private String name;
    private int price;
    private String image;
    private String description;
    private boolean active;
    private int categoryId;
    private String categoryName;

    public Drink() {}

    public int getDrinksId() { return drinksId; }
    public void setDrinksId(int drinksId) { this.drinksId = drinksId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getPrice() { return price; }
    public void setPrice(int price) { this.price = price; }
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
}