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
public class Category {
    private int categoryId;
    private String categoryName;

    public int getCategoryId() { return categoryId; }
    public String getCategoryName() { return categoryName; }

    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }  
}
