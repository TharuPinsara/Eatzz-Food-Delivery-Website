//Admin Page Create User

package com.example.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.*;
import java.util.regex.Pattern;

@WebServlet("/CreateUserServlet")
public class CreateUserServlet extends HttpServlet {

    private static final Pattern EMAIL_REGEX = Pattern.compile("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$");
    private static final Pattern PHONE_REGEX = Pattern.compile("^[0-9]{10}$");
    private static final String USER_FILE = "WEB-INF/users.txt";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // Validate email and phone
        if (!isValidEmail(email) || !isValidPhone(phone)) {
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
            writer.write(username + "," + password + "," + email + "," + phone + "," + address);
            writer.newLine();
        }

        // Redirect to Add User page with success message
        response.sendRedirect(request.getContextPath() + "/AdminPage/AddUser.jsp?success=User added successfully!");
    }

    private boolean isValidEmail(String email) {
        return EMAIL_REGEX.matcher(email).matches();
    }

    private boolean isValidPhone(String phone) {
        return PHONE_REGEX.matcher(phone).matches();
    }

    private boolean isUserExists(String username, String filePath) throws IOException {
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] details = line.split(",");
                if (details[0].equalsIgnoreCase(username)) {
                    return true; // User already exists
                }
            }
        }
        return false;
    }
}