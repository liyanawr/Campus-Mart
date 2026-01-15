/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.marketplace.dao;

import com.marketplace.model.User;
import com.marketplace.util.DBConnection;
import java.sql.*;

/**
 *
 * @author Afifah Isnarudin
 */
public class UserDAO {

    public User loginUser(String id, String password) {
        String sql = "SELECT * FROM users WHERE identification_no = ? AND password = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, id);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapUser(rs);
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public User getUserByUserId(int id) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            // CRITICAL FIX: The password MUST be mapped for verification to work
            if (rs.next()) return mapUser(rs);
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public boolean updateProfileComplete(int userId, String name, String password, String phone, String qrPath) {
        String sql = "UPDATE users SET name = ?, password = ?, phone_number = ?, payment_qr = ? WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, password);
            ps.setString(3, phone);
            ps.setString(4, qrPath);
            ps.setInt(5, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
    
    public boolean activateSeller(int userId, String qrPath) {
        String sql = "UPDATE users SET is_seller = TRUE, payment_qr = ? WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, qrPath); ps.setInt(2, userId); return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean registerUser(User u) {
        // Step 1: Check if user already exists BEFORE trying to insert
        String checkSql = "SELECT count(*) FROM users WHERE identification_no = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement psCheck = con.prepareStatement(checkSql)) {
            psCheck.setString(1, u.getIdentificationNo());
            ResultSet rs = psCheck.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) return false; // ID already taken
            
            // Step 2: Perform insert including all required columns to avoid null constraints
            String sql = "INSERT INTO users (identification_no, id_type, name, password, phone_number, is_seller, payment_qr) VALUES (?, ?, ?, ?, ?, FALSE, NULL)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, u.getIdentificationNo());
            ps.setString(2, u.getIdType());
            ps.setString(3, u.getName());
            ps.setString(4, u.getPassword());
            ps.setString(5, u.getPhoneNumber());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace(); 
            return false; 
        }
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setIdentificationNo(rs.getString("identification_no"));
        u.setIdType(rs.getString("id_type"));
        u.setName(rs.getString("name"));
        u.setPassword(rs.getString("password"));
        u.setPhoneNumber(rs.getString("phone_number"));
        u.setIsSeller(rs.getBoolean("is_seller"));
        u.setPaymentQr(rs.getString("payment_qr"));
        return u;
    }
}