package com.marketplace.controller;

import com.marketplace.dao.ItemDAO;
import com.marketplace.model.Item;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/EditItemServlet")
public class EditItemServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            int qty = Integer.parseInt(request.getParameter("qty"));
            String status = request.getParameter("status");

            if (qty > 0 && "Sold".equals(status)) {
                status = "Available";
            } else if (qty <= 0) {
                status = "Sold";
                qty = 0;
            }

            Item item = new Item();
            item.setItemId(itemId);
            item.setItemName(request.getParameter("itemName"));
            item.setDescription(request.getParameter("description"));
            item.setPrice(Double.parseDouble(request.getParameter("price")));
            item.setStatus(status);
            item.setQty(qty);
            item.setPreferredPayment(request.getParameter("preferredPayment"));
            
            if (new ItemDAO().updateItem(item)) {
                // SUCCESS REDIRECT
                response.sendRedirect("seller_dashboard.jsp?msg=Updated");
            } else {
                response.sendRedirect("edit-item.jsp?id=" + itemId + "&error=Fail");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("seller_dashboard.jsp?error=InvalidInput");
        }
    }
}
