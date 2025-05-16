package com.example.restaurant.admin;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/StoreAdminRegisterServlet")
public class StoreAdminRegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String storeName = request.getParameter("storeName");
        String address = request.getParameter("address");
        String phoneNumber = request.getParameter("phoneNumber");

        // Validate all input fields
        if (username == null || password == null || storeName == null || address == null || phoneNumber == null ||
                username.trim().isEmpty() || password.trim().isEmpty() || storeName.trim().isEmpty() ||
                address.trim().isEmpty() || phoneNumber.trim().isEmpty()) {
            response.sendRedirect("/RestaurantPage/Admin/StoreAdminRegister.jsp?error=invalid");
            return;
        }

        ServletContext context = getServletContext();

        // Handle store_admin_users.txt (username, password, storeName)
        String usersFilePath = context.getRealPath("/WEB-INF/store_admin_users.txt");
        File usersFile = new File(usersFilePath);

        if (!usersFile.exists()) {
            usersFile.getParentFile().mkdirs();
            usersFile.createNewFile();
        }

        List<String> users = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(usersFile))) {
            String line;
            while ((line = reader.readLine()) != null) {
                users.add(line);
                if (line.startsWith(username.trim() + ",")) {
                    response.sendRedirect("/RestaurantPage/Admin/StoreAdminRegister.jsp?error=duplicate");
                    return;
                }
            }
        }

        users.add(username.trim() + "," + password.trim() + "," + storeName.trim());
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(usersFile))) {
            for (String user : users) {
                writer.write(user);
                writer.newLine();
            }
        } catch (IOException e) {
            response.sendRedirect("/RestaurantPage/Admin/StoreAdminRegister.jsp?error=failed");
            return;
        }

        // Handle Restaurant.txt (storeName, address, phoneNumber)
        String restaurantFilePath = context.getRealPath("/WEB-INF/Restaurant.txt");
        File restaurantFile = new File(restaurantFilePath);

        if (!restaurantFile.exists()) {
            restaurantFile.getParentFile().mkdirs();
            restaurantFile.createNewFile();
        }

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(restaurantFile, true))) {
            writer.write(storeName.trim() + "|" + address.trim() + "|" + phoneNumber.trim());
            writer.newLine();
            response.sendRedirect("/RestaurantPage/Admin/StoreAdminLogin.jsp?success=registered");
        } catch (IOException e) {
            response.sendRedirect("/RestaurantPage/Admin/StoreAdminRegister.jsp?error=failed");
        }
    }
}