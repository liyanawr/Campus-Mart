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
public class Item implements Serializable {
    private int itemId;
    private String itemName;
    private String description;
    private double price;
    private String status;
    private String itemPhoto;
    private String preferredPayment;
    private int sellerId;
    private int categoryId;
    private String categoryName;
    private int qty;

    public Item() {}

    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }
    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }
    public String getDescription() { return description; }
    public void setDescription(String desc) { this.description = desc; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getItemPhoto() { return itemPhoto; }
    public void setItemPhoto(String photo) { this.itemPhoto = photo; }
    public String getPreferredPayment() { return preferredPayment; }
    public void setPreferredPayment(String pay) { this.preferredPayment = pay; }
    public int getSellerId() { return sellerId; }
    public void setSellerId(int id) { this.sellerId = id; }
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int id) { this.categoryId = id; }
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String name) { this.categoryName = name; }
    public int getQty() { return qty; }
    public void setQty(int qty) { this.qty = qty; }
}