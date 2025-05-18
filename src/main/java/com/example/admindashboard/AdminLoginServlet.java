package com.example.admindashboard;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {
    // Use AdminUser for admin credentials
    private final AdminUser adminUser = AdminUser.createAdminUser();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve username and password from the login form
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Validate credentials against adminUser
        if (adminUser.getUsername().equals(username) && adminUser.getPassword().equals(password)) {
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