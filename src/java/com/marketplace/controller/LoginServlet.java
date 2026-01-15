package com.marketplace.controller;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

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
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String studentId = request.getParameter("studentId");
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();
        User user = dao.loginUser(studentId, password);

        if (user != null) {
            // LOGIN SUCCESS: Create a Session
            HttpSession session = request.getSession();
            session.setAttribute("loggedUser", user); // We save the whole User object in the session

            // Redirect to the Dashboard or Home
            response.sendRedirect("dashboard.jsp");
        } else {
            // LOGIN FAILED: Go back to login page with error
            response.sendRedirect("login.jsp?status=fail");
        }
    }
}