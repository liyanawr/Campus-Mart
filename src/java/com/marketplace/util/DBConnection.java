/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.marketplace.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author Afifah Isnarudin
 */
public class DBConnection {
    
    private static final String URL = "jdbc:derby://localhost:1527/StudentMarketplace";
    
    private static final String USERNAME = "app"; 
    private static final String PASSWORD = "app"; 

    public static Connection getConnection() {
        Connection con = null;
        try {
            // Load the Java DB Driver
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            
            // Establish connection
            con = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            System.out.println("Database connected successfully!");
            
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("Database Connection Failed: " + e.getMessage());
            e.printStackTrace();
        }
        return con;
    }
}
