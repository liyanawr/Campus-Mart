/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.marketplace.controller;

import com.marketplace.dao.UserDAO;
import com.marketplace.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

/**
 *
 * @author Afifah Isnarudin
 */

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Trim inputs to prevent accidental spacing causing unique ID violations
            String id = request.getParameter("studentId");
            String type = request.getParameter("idType");
            String name = request.getParameter("name");
            String pass = request.getParameter("password");
            String phone = request.getParameter("phone");

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
                response.sendRedirect("login.jsp?msg=Registered");
            } else {
                // Returns false if DB unique constraint for identification_no is triggered
                response.sendRedirect("register.jsp?error=AlreadyExists");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=InvalidInput");
        }
    }
}