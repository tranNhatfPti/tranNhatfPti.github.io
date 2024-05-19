package model;

public class ProductDetail {
    private int productCode, quantity;
    private String size, color;

    public ProductDetail() {
    }

    public ProductDetail(int productCode, int quantity, String size, String color) {
        this.productCode = productCode;
        this.quantity = quantity;
        this.size = size;
        this.color = color;
    }

    public int getProductCode() {
        return productCode;
    }

    public void setProductCode(int productCode) {
        this.productCode = productCode;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
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
