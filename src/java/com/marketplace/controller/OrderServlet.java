package com.marketplace.controller;

import com.marketplace.dao.OrderDAO;
import com.marketplace.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        OrderDAO dao = new OrderDAO();

        if ("placeOrder".equals(action)) {
            try {
                int itemId = Integer.parseInt(request.getParameter("itemId"));
                String paymentMethod = request.getParameter("paymentMethod");

                if (dao.createOrder(user.getUserId(), itemId, paymentMethod)) {
                    // Store success message in session so it survives the redirect
                    session.setAttribute("successMsg", "Your interest has been sent to the seller!");
                    response.sendRedirect("dashboard.jsp");
                } else {
                    response.sendRedirect("checkout.jsp?id=" + itemId + "&error=Fail");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("home.jsp");
            }
        } else if ("updateStatus".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String status = request.getParameter("status");
            dao.updateOrderStatus(orderId, status);
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
