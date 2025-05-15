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

        if (username == null || password == null || storeName == null ||
                username.trim().isEmpty() || password.trim().isEmpty() || storeName.trim().isEmpty()) {
            response.sendRedirect("/RestaurantPage/Admin/StoreAdminRegister.jsp?error=invalid");
            return;
        }

        ServletContext context = getServletContext();
        String filePath = context.getRealPath("/WEB-INF/store_admin_users.txt");
        File file = new File(filePath);

        if (!file.exists()) {
            file.getParentFile().mkdirs();
            file.createNewFile();
        }

        List<String> users = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
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
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
            for (String user : users) {
                writer.write(user);
                writer.newLine();
            }
            response.sendRedirect("/RestaurantPage/Admin/StoreAdminLogin.jsp?success=registered");
        } catch (IOException e) {
            response.sendRedirect("/RestaurantPage/Admin/StoreAdminRegister.jsp?error=failed");
        }
    }
}