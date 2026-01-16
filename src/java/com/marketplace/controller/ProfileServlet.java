package com.marketplace.controller;

import com.marketplace.dao.UserDAO;
import com.marketplace.model.User;
import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ProfileServlet")
@MultipartConfig(fileSizeThreshold=1024*1024*2, maxFileSize=1024*1024*10, maxRequestSize=1024*1024*50)
public class ProfileServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        UserDAO dao = new UserDAO();

        try {
            if ("activate_seller".equals(action)) {
                String verifyId = request.getParameter("verifyId");
                
                // 1. Verify that the entered ID matches the logged-in user's ID
                if (user.getIdentificationNo() != null && user.getIdentificationNo().equals(verifyId)) {
                    String qrFileName = user.getPaymentQr(); // Keep existing if any
                    
                    // 2. Handle QR Photo Upload
                    try {
                        Part part = request.getPart("qrPhoto");
                        if (part != null && part.getSubmittedFileName() != null && !part.getSubmittedFileName().isEmpty()) {
                            String appPath = request.getServletContext().getRealPath("/");
                            String savePath = appPath.endsWith(File.separator) ? appPath + "uploads" : appPath + File.separator + "uploads";
                            
                            File fileSaveDir = new File(savePath);
                            if (!fileSaveDir.exists()) fileSaveDir.mkdirs();
                            
                            qrFileName = "qr_" + user.getUserId() + "_" + part.getSubmittedFileName();
                            part.write(savePath + File.separator + qrFileName);
                        }
                    } catch (Exception e) {
                        // Optional: log error but proceed if file is optional
                    }

                    // 3. Update Database to activate seller mode
                    if (dao.activateSeller(user.getUserId(), qrFileName)) {
                        user.setIsSeller(true);
                        user.setPaymentQr(qrFileName);
                        session.setAttribute("loggedUser", user);
                        session.setAttribute("successMsg", "Shop activated! You are now a seller.");
                        response.sendRedirect("seller_dashboard.jsp");
                    } else {
                        request.setAttribute("errorMsg", "Database error occurred during activation.");
                        request.getRequestDispatcher("become_seller.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("errorMsg", "Identification No does not match our records.");
                    request.getRequestDispatcher("become_seller.jsp").forward(request, response);
                }
                return;
            }

            // --- Default Profile Update Logic ---
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");

            if (password != null && !password.equals(confirmPassword)) {
                request.setAttribute("errorMsg", "Passwords do not match. Please try again.");
                request.getRequestDispatcher("edit-profile.jsp").forward(request, response);
                return;
            }
            
            if (dao.updateProfileComplete(user.getUserId(), name, password, phone, user.getPaymentQr())) {
                user.setName(name);
                user.setPhoneNumber(phone);
                user.setPassword(password);
                session.setAttribute("loggedUser", user);
                session.setAttribute("successMsg", "Profile information saved");
                response.sendRedirect("edit-profile.jsp");
            } else {
                request.setAttribute("errorMsg", "Failed to update profile. Database error.");
                request.getRequestDispatcher("edit-profile.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=InvalidInput");
        }
    }
}
