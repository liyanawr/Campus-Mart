/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.marketplace.model;
import java.io.Serializable;

/**
 *
 * @author Afifah Isnarudin
 */
public class Order implements Serializable {
    private int orderId;
    private int buyerId;
    private int itemId;
    private String itemName; 
    private double price;    
    private String sellerPhone; 
    private String buyerPhone; 
    private String paymentMethod;
    private String status;
    private boolean isRated; 

    public Order() {}

    // Getters and Setters
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    public int getBuyerId() { return buyerId; }
    public void setBuyerId(int buyerId) { this.buyerId = buyerId; }
    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }
    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public String getSellerPhone() { return sellerPhone; }
    public void setSellerPhone(String phone) { this.sellerPhone = phone; }
    public String getBuyerPhone() { return buyerPhone; }
    public void setBuyerPhone(String phone) { this.buyerPhone = phone; }
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String method) { this.paymentMethod = method; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public boolean isIsRated() { return isRated; }
    public void setIsRated(boolean isRated) { this.isRated = isRated; }
}