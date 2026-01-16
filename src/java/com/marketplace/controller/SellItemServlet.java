package com.marketplace.controller;

import com.marketplace.dao.ItemDAO;
import com.marketplace.model.Item;
import com.marketplace.model.User;
import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/SellItemServlet")
@MultipartConfig(fileSizeThreshold=1024*1024*2, maxFileSize=1024*1024*10, maxRequestSize=1024*1024*50)
public class SellItemServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");
        
        if (user == null) { 
            response.sendRedirect("login.jsp"); 
            return; 
        }

        try {
            String appPath = request.getServletContext().getRealPath("/");
            String savePath = appPath.endsWith(File.separator) ? appPath + "uploads" : appPath + File.separator + "uploads";
            
            File fileSaveDir = new File(savePath);
            if (!fileSaveDir.exists()) fileSaveDir.mkdirs();

            // Price Validation
            String priceStr = request.getParameter("price");
            double price = 0.0;
            try {
                price = Double.parseDouble(priceStr.replaceAll("[^0-9.]", ""));
                if (price <= 0) throw new Exception();
            } catch (Exception e) {
                response.sendRedirect("sell-item.jsp?error=InvalidPrice");
                return;
            }

            // Handle Image Part
            String fileName = "default.png";
            try {
                Part part = request.getPart("itemPhoto");
                if (part != null && part.getSubmittedFileName() != null && !part.getSubmittedFileName().isEmpty()) {
                    fileName = part.getSubmittedFileName();
                    part.write(savePath + File.separator + fileName);
                }
            } catch (Exception e) {
                response.sendRedirect("sell-item.jsp?error=UploadError");
                return;
            }

            Item item = new Item();
            item.setItemName(request.getParameter("itemName"));
            item.setDescription(request.getParameter("description"));
            item.setPrice(price);
            item.setCategoryId(parseInteger(request.getParameter("categoryId"), 5)); 
            item.setQty(parseInteger(request.getParameter("qty"), 1)); 
            item.setPreferredPayment(request.getParameter("preferredPayment"));
            item.setItemPhoto(fileName);
            item.setSellerId(user.getUserId());

            if (new ItemDAO().addItem(item)) {
                response.sendRedirect("seller_dashboard.jsp?msg=AddSuccess");
            } else {
                response.sendRedirect("sell-item.jsp?error=DbError");
            }
        } catch (Exception e) {
            e.printStackTrace(); 
            response.sendRedirect("sell-item.jsp?error=InvalidInput");
        }
    }

    private int parseInteger(String val, int defaultVal) {
        if (val == null || val.trim().isEmpty()) return defaultVal;
        try {
            return Integer.parseInt(val.replaceAll("[^0-9]", ""));
        } catch (Exception e) { return defaultVal; }
    }
}
