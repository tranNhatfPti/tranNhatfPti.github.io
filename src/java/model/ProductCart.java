package model;

public class ProductCart {
    private int customerID, productCode;
    private String productName, size, color;
    private double price;
    private int quantity;
    private String image;

    public ProductCart() {
    }

    public ProductCart(int customerID, int productCode, String productName, String size, String color, double price, int quantity, String image) {
        this.customerID = customerID;
        this.productCode = productCode;
        this.productName = productName;
        this.size = size;
        this.color = color;
        this.price = price;
        this.quantity = quantity;
        this.image = image;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public int getProductCode() {
        return productCode;
    }

    public void setProductCode(int productCode) {
        this.productCode = productCode;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }
 
}
