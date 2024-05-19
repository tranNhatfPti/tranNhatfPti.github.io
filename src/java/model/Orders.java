/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class Orders {
    private int orderID, customerID, shipperID;
    private String orderDate, shippedDate;
    private double shippingTotal;
    private String shipAddress;
    private int status;

    public Orders() {
    }

    public Orders(int customerID, int shipperID, String orderDate, String shippedDate, double shippingTotal, String shipAddress, int status) {
        this.customerID = customerID;
        this.shipperID = shipperID;
        this.orderDate = orderDate;
        this.shippedDate = shippedDate;
        this.shippingTotal = shippingTotal;
        this.shipAddress = shipAddress;
        this.status = status;
    }
    
    public Orders(int orderID, int customerID, int shipperID, String orderDate, String shippedDate, double shippingTotal, String shipAddress, int status) {
        this.orderID = orderID;
        this.customerID = customerID;
        this.shipperID = shipperID;
        this.orderDate = orderDate;
        this.shippedDate = shippedDate;
        this.shippingTotal = shippingTotal;
        this.shipAddress = shipAddress;
        this.status = status;
    }

    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public int getShipperID() {
        return shipperID;
    }

    public void setShipperID(int shipperID) {
        this.shipperID = shipperID;
    }

    public String getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(String orderDate) {
        this.orderDate = orderDate;
    }

    public String getShippedDate() {
        return shippedDate;
    }

    public void setShippedDate(String shippedDate) {
        this.shippedDate = shippedDate;
    }

    public double getShippingTotal() {
        return shippingTotal;
    }

    public void setShippingTotal(double shippingTotal) {
        this.shippingTotal = shippingTotal;
    }

    public String getShipAddress() {
        return shipAddress;
    }

    public void setShipAddress(String shipAddress) {
        this.shipAddress = shipAddress;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }
    
    
}
