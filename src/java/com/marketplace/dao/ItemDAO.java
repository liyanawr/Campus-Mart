/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.marketplace.dao;

import com.marketplace.model.Item;
import com.marketplace.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author Afifah Isnarudin
 */
public class ItemDAO {
    
    public boolean addItem(Item item) {
        String sql = "INSERT INTO items (item_name, description, price, status, item_photo, preferred_payment, seller_id, category_id, qty) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, item.getItemName());
            ps.setString(2, item.getDescription());
            ps.setDouble(3, item.getPrice());
            ps.setString(4, "Available");
            ps.setString(5, item.getItemPhoto());
            ps.setString(6, item.getPreferredPayment());
            ps.setInt(7, item.getSellerId());
            ps.setInt(8, item.getCategoryId());
            ps.setInt(9, item.getQty());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean updateItem(Item item) {
        // Modification 1 & 6: Added QTY and Preferred Payment to update
        String sql = "UPDATE items SET item_name=?, description=?, price=?, status=?, qty=?, preferred_payment=? WHERE item_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, item.getItemName());
            ps.setString(2, item.getDescription());
            ps.setDouble(3, item.getPrice());
            ps.setString(4, item.getStatus());
            ps.setInt(5, item.getQty());
            ps.setString(6, item.getPreferredPayment());
            ps.setInt(7, item.getItemId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // Rest of existing methods (searchItems, getItemById, getItemsBySellerId, deleteItem) stay the same...
    public List<Item> searchItems(String query, String category, String sort) {
        List<Item> list = new ArrayList<Item>();
        String sql = "SELECT i.*, c.category_name FROM items i JOIN categories c ON i.category_id = c.category_id WHERE i.status = 'Available' AND i.qty > 0";
        if (query != null && !query.isEmpty()) sql += " AND (UPPER(i.item_name) LIKE UPPER(?) OR UPPER(i.description) LIKE UPPER(?))";
        if (category != null && !category.equals("0")) sql += " AND i.category_id = " + category;
        if ("cheap".equals(sort)) sql += " ORDER BY i.price ASC";
        else if ("pricey".equals(sort)) sql += " ORDER BY i.price DESC";
        else sql += " ORDER BY i.item_id DESC";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            if (query != null && !query.isEmpty()) { ps.setString(1, "%" + query + "%"); ps.setString(2, "%" + query + "%"); }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public Item getItemById(int id) {
        String sql = "SELECT i.*, c.category_name FROM items i JOIN categories c ON i.category_id = c.category_id WHERE i.item_id = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public List<Item> getItemsBySellerId(int sellerId) {
        List<Item> list = new ArrayList<Item>();
        String sql = "SELECT i.*, c.category_name FROM items i JOIN categories c ON i.category_id = c.category_id WHERE i.seller_id = ? ORDER BY i.item_id DESC";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, sellerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean deleteItem(int id) {
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps1 = con.prepareStatement("DELETE FROM cart WHERE item_id = ?");
            ps1.setInt(1, id); ps1.executeUpdate();
            PreparedStatement ps2 = con.prepareStatement("DELETE FROM items WHERE item_id = ?");
            ps2.setInt(1, id); return ps2.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    private Item mapRow(ResultSet rs) throws SQLException {
        Item i = new Item();
        i.setItemId(rs.getInt("item_id"));
        i.setItemName(rs.getString("item_name"));
        i.setDescription(rs.getString("description"));
        i.setPrice(rs.getDouble("price"));
        i.setStatus(rs.getString("status"));
        i.setItemPhoto(rs.getString("item_photo"));
        i.setPreferredPayment(rs.getString("preferred_payment"));
        i.setSellerId(rs.getInt("seller_id"));
        i.setCategoryId(rs.getInt("category_id"));
        i.setCategoryName(rs.getString("category_name"));
        i.setQty(rs.getInt("qty"));
        return i;
    }
}