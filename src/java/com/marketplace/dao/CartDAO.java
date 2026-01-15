/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.marketplace.dao;

import com.marketplace.model.CartItem;
import com.marketplace.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author Afifah Isnarudin
 */
public class CartDAO {
    
    // Add to Cart
    public boolean addToCart(int userId, int itemId) {
        String sql = "INSERT INTO cart (user_id, item_id) VALUES (?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, itemId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public List<CartItem> getCartItems(int userId) {
        List<CartItem> list = new ArrayList<CartItem>();
        String sql = "SELECT c.cart_id, i.item_id, i.item_name, i.price, i.item_photo, u.name as seller_name, u.user_id as seller_id " +
                     "FROM cart c JOIN items i ON c.item_id = i.item_id " +
                     "JOIN users u ON i.seller_id = u.user_id " +
                     "WHERE c.user_id = ? AND i.qty > 0 AND i.status = 'Available'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CartItem item = new CartItem();
                item.setCartId(rs.getInt("cart_id"));
                item.setItemId(rs.getInt("item_id"));
                item.setItemName(rs.getString("item_name"));
                item.setPrice(rs.getDouble("price"));
                item.setItemPhoto(rs.getString("item_photo"));
                item.setSellerName(rs.getString("seller_name"));
                item.setSellerId(rs.getInt("seller_id"));
                list.add(item);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean deleteCartItem(int cartId) {
        String sql = "DELETE FROM cart WHERE cart_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
}