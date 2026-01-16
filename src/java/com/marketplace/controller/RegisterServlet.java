package com.marketplace.controller;

import com.marketplace.dao.UserDAO;
import com.marketplace.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String id = request.getParameter("studentId");
            String type = request.getParameter("idType");
            String name = request.getParameter("name");
            String pass = request.getParameter("password");
            String confirmPass = request.getParameter("confirmPassword"); // New field check
            String phone = request.getParameter("phone");

            // Check if passwords match
            if (pass != null && !pass.equals(confirmPass)) {
                response.sendRedirect("register.jsp?error=PasswordMismatch");
                return;
            }

            if (id == null || id.trim().isEmpty() || pass == null || pass.isEmpty()) {
                response.sendRedirect("register.jsp?error=InvalidInput");
                return;
            }

            User u = new User();
            u.setIdentificationNo(id.trim());
            u.setIdType(type);
            u.setName(name.trim());
            u.setPassword(pass);
            u.setPhoneNumber(phone != null ? phone.trim() : "");

            UserDAO dao = new UserDAO();
            if (dao.registerUser(u)) {
                // Success message
                response.sendRedirect("login.jsp?status=Registered");
            } else {
                // Specific error for existing ID
                response.sendRedirect("register.jsp?error=AlreadyExists");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=InvalidInput");
        }
    }
}
