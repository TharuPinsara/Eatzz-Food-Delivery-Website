package com.example.userlogin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.*;

@WebServlet("/CreateUserServlet")
public class CreateUserServlet extends HttpServlet {

    private static final String USER_FILE = "WEB-INF/users.txt";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

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
            response.sendRedirect(request.getContextPath() + "/AdminPage/AddUser.jsp?error=Invalid input. Please try again.");
            return;
        }

        String filePath = getServletContext().getRealPath(USER_FILE);

        // Check if user already exists
        if (isUserExists(username, filePath)) {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AddUser.jsp?error=User already exists!");
            return;
        }

        // Append new user to file
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath, true))) {
            writer.write(user.toString());
            writer.newLine();
        }

        // Redirect to Add User page with success message
        response.sendRedirect(request.getContextPath() + "/AdminPage/AddUser.jsp?success=User added successfully!");
    }

    private boolean isUserExists(String username, String filePath) throws IOException {
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                try {
                    User existingUser = User.fromString(line);
                    if (existingUser.getUsername().equalsIgnoreCase(username)) {
                        return true; // User already exists
                    }
                } catch (IllegalArgumentException e) {
                    // Skip invalid lines
                    continue;
                }
            }
        }
        return false;
    }
}