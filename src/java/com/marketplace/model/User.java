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
public class User implements Serializable {
    private int userId;
    private String identificationNo;
    private String idType;
    private String name;
    private String password;
    private String phoneNumber;
    private boolean isSeller;
    private String paymentQr;

    public User() {}

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getIdentificationNo() { return identificationNo; }
    public void setIdentificationNo(String id) { this.identificationNo = id; }
    public String getIdType() { return idType; }
    public void setIdType(String idType) { this.idType = idType; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phone) { this.phoneNumber = phone; }
    public boolean isIsSeller() { return isSeller; }
    public void setIsSeller(boolean isSeller) { this.isSeller = isSeller; }
    public String getPaymentQr() { return paymentQr; }
    public void setPaymentQr(String qr) { this.paymentQr = qr; }

    public void setUserType(String type) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    public void setSeller(boolean b) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
}