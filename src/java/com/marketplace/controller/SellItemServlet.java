package com.marketplace.controller;

import com.marketplace.dao.ItemDAO;
import com.marketplace.model.Item;
import com.marketplace.model.User;
import java.io.*;
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
            // Define your absolute path clearly
            String savePath = "C:\\Users\\Nadiratul Liyana\\Documents\\UITM DEGREE\\sem 4 classes\\CSC584\\StudentMarketplace\\web\\uploads";
            
            File fileSaveDir = new File(savePath);
            if (!fileSaveDir.exists()) {
                fileSaveDir.mkdirs();
            }

            String priceStr = request.getParameter("price");
            double price = Double.parseDouble(priceStr.replaceAll("[^0-9.]", ""));

            String fileName = "default.png";
            Part part = request.getPart("itemPhoto");
            
            if (part != null && part.getSubmittedFileName() != null && !part.getSubmittedFileName().isEmpty()) {
                fileName = System.currentTimeMillis() + "_" + part.getSubmittedFileName();
                File fileToSave = new File(fileSaveDir, fileName);
                
                // MANUAL STREAMING FIX: Avoids the GlassFish doubled path error
                try (InputStream input = part.getInputStream();
                     OutputStream output = new FileOutputStream(fileToSave)) {
                    byte[] buffer = new byte[4096];
                    int bytesRead;
                    while ((bytesRead = input.read(buffer)) != -1) {
                        output.write(buffer, 0, bytesRead);
                    }
                } catch (IOException io) {
                    System.err.println("Streaming Error to: " + fileToSave.getAbsolutePath());
                    io.printStackTrace();
                    response.sendRedirect("sell-item.jsp?error=UploadError");
                    return;
                }
            }

            Item item = new Item();
            item.setItemName(request.getParameter("itemName"));
            item.setDescription(request.getParameter("description"));
            item.setPrice(price);
            item.setCategoryId(Integer.parseInt(request.getParameter("categoryId"))); 
            item.setQty(Integer.parseInt(request.getParameter("qty"))); 
            item.setPreferredPayment(request.getParameter("preferredPayment"));
            item.setItemPhoto(fileName);
            item.setSellerId(user.getUserId());

            if (new ItemDAO().addItem(item)) {
                session.setAttribute("successMsg", "Item listed successfully!");
                response.sendRedirect("seller_dashboard.jsp");
            } else {
                response.sendRedirect("sell-item.jsp?error=DbError");
            }
        } catch (Exception e) {
            e.printStackTrace(); 
            response.sendRedirect("sell-item.jsp?error=InvalidInput");
        }
    }
}
