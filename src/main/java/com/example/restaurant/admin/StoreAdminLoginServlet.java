package com.example.restaurant.admin;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

@WebServlet("/StoreAdminLoginServlet")
public class StoreAdminLoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            response.sendRedirect("/RestaurantPage/Admin/StoreAdminLogin.jsp?error=invalid");
            return;
        }

        ServletContext context = getServletContext();
        String filePath = context.getRealPath("/WEB-INF/store_admin_users.txt");
        boolean authenticated = false;
        String storeName = null;

        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length == 3 && parts[0].trim().equals(username) && parts[1].trim().equals(password)) {
                    authenticated = true;
                    storeName = parts[2].trim();
                    break;
                }
            }
        }

        if (authenticated) {
            HttpSession session = request.getSession();
            session.setAttribute("storeAdminUser", username);
            session.setAttribute("storeName", storeName);
            response.sendRedirect("/RestaurantPage/Admin/StoreAdminDashboard.jsp");
        } else {
            response.sendRedirect("/RestaurantPage/Admin/StoreAdminLogin.jsp?error=invalid");
        }
    }
}