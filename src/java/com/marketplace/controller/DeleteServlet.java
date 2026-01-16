package com.marketplace.controller;

import com.marketplace.dao.*;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/DeleteServlet")
public class DeleteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        String type = request.getParameter("type"); 
        
        if (idStr == null) return;
        int id = Integer.parseInt(idStr);

        if ("cart".equals(type)) { 
            new CartDAO().deleteCartItem(id);
            response.sendRedirect("cart.jsp");
        } else {
            new ItemDAO().deleteItem(id);
            response.sendRedirect("seller_dashboard.jsp?msg=DeleteSuccess");
        }
    }
}
