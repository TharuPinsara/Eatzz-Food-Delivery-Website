package com.example.userlogin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.*;
import java.util.Base64;

@WebServlet("/CreateUserServlet")
public class CreateUserServlet extends HttpServlet {

    private static final String USER_FILE = "WEB-INF/users.txt";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String encodedPassword = request.getParameter("password");
        String encodedEmail = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // Validate that password and email are Base64-encoded
        String password, email;
        try {
            password = new String(Base64.getDecoder().decode(encodedPassword));
            email = new String(Base64.getDecoder().decode(encodedEmail));
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AddUser.jsp?error=Invalid Base64 encoding for password or email.");
            return;
        }

        // Create User object and validate
        User user;
        try {
            user = new User();
            user.setUsername(username);
            user.setPassword(password);
            user.setEmail(email);
            user.setPhone(phone);
            user.setAddress(address);
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AddUser.jsp?error=Invalid input: " + e.getMessage());
            return;
        }

        String filePath = getServletContext().getRealPath(USER_FILE);

        // Check if user already exists
        if (isUserExists(username, filePath)) {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AddUser.jsp?error=User already exists!");
            return;
        }

        // Append new user to file with encoded password and email
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath, true))) {
            writer.write(username + "," + encodedPassword + "," + encodedEmail + "," + phone + "," + address);
            writer.newLine();
        } catch (IOException e) {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AddUser.jsp?error=Error writing to users file: " + e.getMessage());
            return;
        }

        // Redirect to Add User page with success message
        response.sendRedirect(request.getContextPath() + "/AdminPage/AddUser.jsp?success=User added successfully!");
    }

    private boolean isUserExists(String username, String filePath) throws IOException {
        File file = new File(filePath);
        if (!file.exists()) {
            file.getParentFile().mkdirs();
            file.createNewFile();
        }
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] details = line.split(",", -1);
                if (details.length >= 1 && details[0].equalsIgnoreCase(username)) {
                    return true; // User already exists
                }
            }
        }
        return false;
    }
}