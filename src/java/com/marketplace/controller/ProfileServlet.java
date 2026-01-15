/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.marketplace.controller;

import com.marketplace.dao.UserDAO;
import com.marketplace.model.User;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

/**
 *
 * @author Afifah Isnarudin
 */
@WebServlet("/ProfileServlet")
@MultipartConfig(fileSizeThreshold=1024*1024*2, maxFileSize=1024*1024*10, maxRequestSize=1024*1024*50)
public class ProfileServlet extends HttpServlet {

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
        UserDAO dao = new UserDAO();

        // Path resolution: Target the 'uploads' folder in the deployed web app
        String appPath = request.getServletContext().getRealPath("");
        String savePath = appPath + File.separator + "uploads";
        File fileSaveDir = new File(savePath);
        if (!fileSaveDir.exists()) fileSaveDir.mkdirs();

        if ("activate_seller".equals(action)) {
            String verifyId = request.getParameter("verifyId");
            
            // Security: Check if entered ID matches session ID
            if (!verifyId.equals(user.getIdentificationNo())) {
                response.sendRedirect("become_seller.jsp?error=IdMismatch");
                return;
            }

            Part part = request.getPart("qrPhoto");
            String fileName = "default_qr.png";
            
            if (part != null && part.getSubmittedFileName() != null && !part.getSubmittedFileName().isEmpty()) {
                // FIXED: Sanitize filename to remove absolute paths from client-side
                fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                part.write(savePath + File.separator + fileName);
            }

            if (dao.activateSeller(user.getUserId(), fileName)) {
                user.setIsSeller(true);
                user.setPaymentQr(fileName);
                response.sendRedirect("seller_dashboard.jsp?msg=Activated");
            } else {
                response.sendRedirect("become_seller.jsp?error=DbError");
            }
        }
        else if ("edit_profile".equals(action)) {
            String oldPassInput = request.getParameter("oldPassword");
            String newPass = request.getParameter("password");
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");

            if (oldPassInput == null || !oldPassInput.equals(user.getPassword())) {
                response.sendRedirect("edit-profile.jsp?error=WrongOldPassword");
                return;
            }

            if(newPass == null || newPass.trim().isEmpty()) newPass = user.getPassword();

            Part part = request.getPart("qrPhoto");
            String finalQr = user.getPaymentQr();
            
            if (part != null && part.getSubmittedFileName() != null && !part.getSubmittedFileName().isEmpty()) {
                finalQr = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                part.write(savePath + File.separator + finalQr);
            }

            if (dao.updateProfileComplete(user.getUserId(), name, newPass, phone, finalQr)) {
                user.setName(name); user.setPassword(newPass); user.setPhoneNumber(phone); user.setPaymentQr(finalQr);
                response.sendRedirect("dashboard.jsp?status=Success");
            }
        }
    }
}