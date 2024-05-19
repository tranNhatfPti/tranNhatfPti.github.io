/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class FeedBack {
    private int feedBackID, customerID, productCode;
    private String content, adminResponse, feedbackDate;
    private int evaluate;

    public FeedBack() {
    }

    public FeedBack(int customerID, int productCode, String content, String adminResponse, String feedbackDate, int evaluate) {
        this.customerID = customerID;
        this.productCode = productCode;
        this.content = content;
        this.adminResponse = adminResponse;
        this.feedbackDate = feedbackDate;
        this.evaluate = evaluate;
    }    

    public FeedBack(int feedBackID, int customerID, int productCode, String content, String adminResponse, String feedbackDate, int evaluate) {
        this.feedBackID = feedBackID;
        this.customerID = customerID;
        this.productCode = productCode;
        this.content = content;
        this.adminResponse = adminResponse;
        this.feedbackDate = feedbackDate;
        this.evaluate = evaluate;
    }

    public int getFeedBackID() {
        return feedBackID;
    }

    public void setFeedBackID(int feedBackID) {
        this.feedBackID = feedBackID;
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

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getAdminResponse() {
        return adminResponse;
    }

    public void setAdminResponse(String adminResponse) {
        this.adminResponse = adminResponse;
    }

    public String getFeedbackDate() {
        return feedbackDate;
    }

    public void setFeedbackDate(String feedbackDate) {
        this.feedbackDate = feedbackDate;
    }

    public int getEvaluate() {
        return evaluate;
    }

    public void setEvaluate(int evaluate) {
        this.evaluate = evaluate;
    }
    
    
}
