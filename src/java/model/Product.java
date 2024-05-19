/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class Product {

    private int productCode, categoryID;
    private String productName, brandName;
    private double price;
    private String picture, description, gender;
    private int discount, quantitySold;

    public Product() {
    }

    public Product(int productCode, String productName) {
        this.productCode = productCode;
        this.productName = productName;
    }

    public Product(int productCode, int categoryID, String productName, String brandName, double price, String picture, String description, String gender, int discount, int quantitySold) {
        this.productCode = productCode;
        this.categoryID = categoryID;
        this.productName = productName;
        this.brandName = brandName;
        this.price = price;
        this.picture = picture;
        this.description = description;
        this.gender = gender;
        this.discount = discount;
        this.quantitySold = quantitySold;
    }

    public Product(int categoryID, String productName, String brandName, double price, String picture, String description, String gender, int discount, int quantitySold) {
        this.categoryID = categoryID;
        this.productName = productName;
        this.brandName = brandName;
        this.price = price;
        this.picture = picture;
        this.description = description;
        this.gender = gender;
        this.discount = discount;
        this.quantitySold = quantitySold;
    }

    public int getDiscount() {
        return discount;
    }

    public void setDiscount(int discount) {
        this.discount = discount;
    }

    public int getQuantitySold() {
        return quantitySold;
    }

    public void setQuantitySold(int quantitySold) {
        this.quantitySold = quantitySold;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public int getProductCode() {
        return productCode;
    }

    public void setProductCode(int productCode) {
        this.productCode = productCode;
    }

    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getPicture() {
        return picture;
    }

    public void setPicture(String picture) {
        this.picture = picture;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

}
