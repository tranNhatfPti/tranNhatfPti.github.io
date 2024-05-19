/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class OrderDetails {
    private int orderID, productCode;
    private String sizeOrder, colorOrder;
    private int quantityOrder, discountFromCode;

    public OrderDetails() {
    }

    public OrderDetails(int orderID, int productCode, String sizeOrder, String colorOrder, int quantityOrder, int discountFromCode) {
        this.orderID = orderID;
        this.productCode = productCode;
        this.sizeOrder = sizeOrder;
        this.colorOrder = colorOrder;
        this.quantityOrder = quantityOrder;
        this.discountFromCode = discountFromCode;
    }

    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public int getProductCode() {
        return productCode;
    }

    public void setProductCode(int productCode) {
        this.productCode = productCode;
    }

    public String getSizeOrder() {
        return sizeOrder;
    }

    public void setSizeOrder(String sizeOrder) {
        this.sizeOrder = sizeOrder;
    }

    public String getColorOrder() {
        return colorOrder;
    }

    public void setColorOrder(String colorOrder) {
        this.colorOrder = colorOrder;
    }

    public int getQuantityOrder() {
        return quantityOrder;
    }

    public void setQuantityOrder(int quantityOrder) {
        this.quantityOrder = quantityOrder;
    }

    public int getDiscountFromCode() {
        return discountFromCode;
    }

    public void setDiscountFromCode(int discountFromCode) {
        this.discountFromCode = discountFromCode;
    }
    
    
}
