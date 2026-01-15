/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.marketplace.controller;

import com.marketplace.dao.*;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

/**
 *
 * @author Afifah Isnarudin
 */
@WebServlet("/DeleteServlet")
public class DeleteServlet extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        String type = request.getParameter("type"); // item or cart
        
        if (idStr == null) return;
        int id = Integer.parseInt(idStr);

        if ("cart".equals(type)) { 
            new CartDAO().deleteCartItem(id);
            response.sendRedirect("cart.jsp");
        } else {
            new ItemDAO().deleteItem(id);
            response.sendRedirect("seller_dashboard.jsp");
        }
    }
}
