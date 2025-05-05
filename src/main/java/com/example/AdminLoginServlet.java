//Admin Page Lgoin

package com.example;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve username and password from the login form
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Hardcoded admin credentials (for demonstration purposes)
        final String adminUsername = "admin";
        final String adminPassword = "admin123";

        // Validate credentials
        if (adminUsername.equals(username) && adminPassword.equals(password)) {
            // Create session for admin user
            HttpSession session = request.getSession();
            session.setAttribute("adminUser", username); // Save admin username in the session object

            // Redirect to the admin dashboard
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp");
        } else {
            // Login failed: Redirect back with an error flag
            response.sendRedirect(request.getContextPath() + "/AdminPage/admin_login.jsp?error=true");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to the login page
        response.sendRedirect(request.getContextPath() + "/AdminPage/admin_login.jsp");
    }
}