/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.marketplace.dao;

import com.marketplace.model.Order;
import com.marketplace.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author Afifah Isnarudin
 */
public class OrderDAO {
    
    // Modification: Sales tracking with integrated ratings and buyer contact
    public List<Order> getSellerSales(int sellerId) {
        List<Order> list = new ArrayList<Order>();
        String sql = "SELECT o.*, i.item_name, i.price, u.phone_number as buyer_phone, " +
                     "r.score, r.comment " +
                     "FROM orders o " +
                     "JOIN items i ON o.item_id = i.item_id " +
                     "JOIN users u ON o.buyer_id = u.user_id " +
                     "LEFT JOIN ratings r ON o.order_id = r.order_id " +
                     "WHERE o.seller_id = ? ORDER BY o.order_id DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, sellerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setOrderId(rs.getInt("order_id"));
                o.setItemName(rs.getString("item_name"));
                o.setPrice(rs.getDouble("price"));
                o.setBuyerPhone(rs.getString("buyer_phone"));
                o.setPaymentMethod(rs.getString("payment_method"));
                o.setStatus(rs.getString("status"));
                o.setIsRated(rs.getObject("score") != null);
                
                // If rated, we combine the info for the Seller to see
                if(o.isIsRated()) {
                    o.setPaymentMethod(o.getPaymentMethod() + " (" + rs.getInt("score") + "⭐: " + rs.getString("comment") + ")");
                }
                list.add(o);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // Modification 7: Fix checkout compilation error
    public String getPaymentPreferenceByItemId(int itemId) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT preferred_payment FROM items WHERE item_id = ?")) {
            ps.setInt(1, itemId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString("preferred_payment");
        } catch (Exception e) { e.printStackTrace(); }
        return "BOTH";
    }

    public boolean updateOrderStatus(int orderId, String newStatus) {
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);
            PreparedStatement ps = con.prepareStatement("UPDATE orders SET status = ? WHERE order_id = ?");
            ps.setString(1, newStatus);
            ps.setInt(2, orderId);
            ps.executeUpdate();

            if ("Available".equals(newStatus)) {
                String resSql = "UPDATE items SET status = 'Available', qty = 1 " +
                                "WHERE item_id = (SELECT item_id FROM orders WHERE order_id = ?)";
                PreparedStatement psRes = con.prepareStatement(resSql);
                psRes.setInt(1, orderId);
                psRes.executeUpdate();
                ps.setString(1, "Cancelled");
                ps.executeUpdate();
            }
            con.commit();
            return true;
        } catch (Exception e) {
            try { if(con!=null) con.rollback(); } catch(Exception ex){}
            return false;
        }
    }

    public boolean checkout(int buyerId, int sellerId, String paymentMethod, List<Integer> itemIds) {
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);
            String oSql = "INSERT INTO orders (buyer_id, item_id, seller_id, payment_method, status) VALUES (?, ?, ?, ?, 'Pending')";
            String iSql = "UPDATE items SET status = 'Sold', qty = 0 WHERE item_id = ?";
            String cSql = "DELETE FROM cart WHERE item_id = ?";
            PreparedStatement psO = con.prepareStatement(oSql);
            PreparedStatement psI = con.prepareStatement(iSql);
            PreparedStatement psC = con.prepareStatement(cSql);
            for (int id : itemIds) {
                psO.setInt(1, buyerId); psO.setInt(2, id); psO.setInt(3, sellerId); psO.setString(4, paymentMethod);
                psO.addBatch(); psI.setInt(1, id); psI.addBatch(); psC.setInt(1, id); psC.addBatch();
            }
            psO.executeBatch(); psI.executeBatch(); psC.executeBatch();
            con.commit(); return true;
        } catch (Exception e) { try { if(con!=null) con.rollback(); } catch(Exception ex){} return false; }
    }

    public boolean addRating(int orderId, int score, String comment) {
        String sql = "INSERT INTO ratings (order_id, score, comment) VALUES (?, ?, ?)";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId); ps.setInt(2, score); ps.setString(3, comment); return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public List<Order> getBuyerHistory(int buyerId) {
        List<Order> list = new ArrayList<Order>();
        String sql = "SELECT o.*, i.item_name, i.price, u.phone_number as seller_phone, (SELECT count(*) FROM ratings r WHERE r.order_id = o.order_id) as rCount FROM orders o JOIN items i ON o.item_id = i.item_id JOIN users u ON o.seller_id = u.user_id WHERE o.buyer_id = ? ORDER BY o.order_id DESC";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, buyerId); ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order(); o.setOrderId(rs.getInt("order_id")); o.setItemName(rs.getString("item_name"));
                o.setPrice(rs.getDouble("price")); o.setSellerPhone(rs.getString("seller_phone"));
                o.setPaymentMethod(rs.getString("payment_method")); o.setStatus(rs.getString("status"));
                o.setIsRated(rs.getInt("rCount") > 0); list.add(o);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
    public boolean createOrder(int buyerId, int itemId, String paymentMethod) {
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // 1. Get the seller ID for the item
            int sellerId = -1;
            PreparedStatement psS = con.prepareStatement("SELECT seller_id FROM items WHERE item_id = ?");
            psS.setInt(1, itemId);
            ResultSet rs = psS.executeQuery();
            if (rs.next()) {
                sellerId = rs.getInt("seller_id");
            }

            // 2. Insert the order
            String oSql = "INSERT INTO orders (buyer_id, item_id, seller_id, payment_method, status) VALUES (?, ?, ?, ?, 'Pending')";
            PreparedStatement psO = con.prepareStatement(oSql);
            psO.setInt(1, buyerId);
            psO.setInt(2, itemId);
            psO.setInt(3, sellerId);
            psO.setString(4, paymentMethod);
            psO.executeUpdate();

            // 3. Mark item as Sold and remove from all carts
            PreparedStatement psI = con.prepareStatement("UPDATE items SET status = 'Sold', qty = 0 WHERE item_id = ?");
            psI.setInt(1, itemId);
            psI.executeUpdate();

            PreparedStatement psC = con.prepareStatement("DELETE FROM cart WHERE item_id = ?");
            psC.setInt(1, itemId);
            psC.executeUpdate();

            con.commit();
            return true;
        } catch (Exception e) {
            try { if(con != null) con.rollback(); } catch(Exception ex){}
            e.printStackTrace();
            return false;
        }
    }
}
