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
@WebServlet(name = "OrderServlet", urlPatterns = {"/OrderServlet"})
public class OrderServlet extends HttpServlet {

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
        String action = request.getParameter("action");
        OrderDAO dao = new OrderDAO();
        
        if ("updateStatus".equals(action)) {
            int id = Integer.parseInt(request.getParameter("orderId"));
            String status = request.getParameter("status");
            dao.updateOrderStatus(id, status);
            response.sendRedirect("seller_dashboard.jsp?status=OrderUpdated");
        } else if ("rate".equals(action)) {
            int id = Integer.parseInt(request.getParameter("orderId"));
            int score = Integer.parseInt(request.getParameter("score"));
            String comm = request.getParameter("comment");
            dao.addRating(id, score, comm);
            response.sendRedirect("dashboard.jsp?status=Rated");
        }
    }
}
