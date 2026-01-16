package com.marketplace.controller;

import com.marketplace.dao.UserDAO;
import com.marketplace.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedUser");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");

            // VALIDATION: Check if passwords match
            if (password != null && !password.equals(confirmPassword)) {
                request.setAttribute("errorMsg", "Passwords do not match. Please try again.");
                request.getRequestDispatcher("edit-profile.jsp").forward(request, response);
                return;
            }
            
            UserDAO dao = new UserDAO();
            if (dao.updateProfileComplete(user.getUserId(), name, password, phone, user.getPaymentQr())) {
                // Update session object with new values
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
            response.sendRedirect("edit-profile.jsp?error=InvalidInput");
        }
    }
}
