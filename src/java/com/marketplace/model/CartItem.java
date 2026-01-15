/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.marketplace.model;

/**
 *
 * @author Afifah Isnarudin
 */
public class CartItem {
    private int cartId;
    private int itemId;
    private String itemName;
    private double price;
    private String itemPhoto;
    private String sellerName;
    private int sellerId;

    // Getters and Setters
    public int getCartId() { return cartId; }
    public void setCartId(int cartId) { this.cartId = cartId; }
    
    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }
    
    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }
    
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    
    public String getItemPhoto() { return itemPhoto; }
    public void setItemPhoto(String itemPhoto) { this.itemPhoto = itemPhoto; }
    
    public String getSellerName() { return sellerName; }
    public void setSellerName(String sellerName) { this.sellerName = sellerName; }
    
    public int getSellerId() { return sellerId; }
    public void setSellerId(int sellerId) { this.sellerId = sellerId; }
}
