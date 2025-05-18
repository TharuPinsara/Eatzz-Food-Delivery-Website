package com.example.menu.foodapp;

public class FoodItem {
    private String name;
    private double price;
    private String storeName;
    private String imagePath;

    public FoodItem(String name, double price, String storeName, String imagePath) {
        this.name = name;
        this.price = price;
        this.storeName = storeName;
        this.imagePath = imagePath;
    }

    public String getName() {
        return name;
    }

    public double getPrice() {
        return price;
    }

    public String getStoreName() {
        return storeName;
    }

    public String getImagePath() {
        return imagePath;
    }

    @Override
    public String toString() {
        return "FoodItem{" +
                "name='" + name + '\'' +
                ", price=" + price +
                ", storeName='" + storeName + '\'' +
                ", imagePath='" + imagePath + '\'' +
                '}';
    }
}