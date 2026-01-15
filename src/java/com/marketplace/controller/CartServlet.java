/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.marketplace.controller;

import com.marketplace.dao.*;
import com.marketplace.model.*;
import java.io.IOException;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

/**
 *
 * @author Afifah Isnarudin
 */
@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");
        if (user == null) { response.sendRedirect("login.jsp"); return; }
        
        String action = request.getParameter("action");
        CartDAO cartDao = new CartDAO();

        if ("add".equals(action)) {
            cartDao.addToCart(user.getUserId(), Integer.parseInt(request.getParameter("itemId")));
            response.sendRedirect("cart.jsp");
        } 
        else if ("delete".equals(action)) { // Requirement 5 fix
            int cartId = Integer.parseInt(request.getParameter("cartId"));
            cartDao.deleteCartItem(cartId);
            response.sendRedirect("cart.jsp");
        }
        else if ("checkout".equals(action)) {
            int sellerId = Integer.parseInt(request.getParameter("sellerId"));
            String method = request.getParameter("paymentMethod");
            List<CartItem> all = cartDao.getCartItems(user.getUserId());
            List<Integer> targets = new ArrayList<Integer>();
            for(CartItem c : all) if(c.getSellerId() == sellerId) targets.add(c.getItemId());
            
            if (new OrderDAO().checkout(user.getUserId(), sellerId, method, targets)) {
                response.sendRedirect("dashboard.jsp?status=OrderPlaced");
            }
        }
    }
}