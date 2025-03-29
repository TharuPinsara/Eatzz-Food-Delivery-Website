package com.example;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    // Path to the file where user credentials are stored
    private static final String USER_FILE = "WEB-INF/users.txt";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Debug: Log request parameters
        System.out.println("Username entered: " + username);
        System.out.println("Password entered: " + password);

        // Validate username and password by reading the file
        if (isValidUser(username, password)) {
            // Create session for user
            HttpSession session = request.getSession();
            session.setAttribute("username", username);

            // Redirect to cart.jsp
            response.sendRedirect("cart.jsp");
        } else {
            // Debug: Invalid login
            System.out.println("Invalid username or password.");
            // Redirect back to login page with an error message
            response.sendRedirect("index.jsp?error=Invalid%20username%20or%20password");
        }
    }

    // Validate user credentials from the file
    private boolean isValidUser(String username, String password) throws IOException {
        // Dynamically resolve the file path
        String absolutePath = getServletContext().getRealPath(USER_FILE);

        try (BufferedReader reader = new BufferedReader(new FileReader(absolutePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] userDetails = line.split(",");
                if (userDetails[0].trim().equals(username) && userDetails[1].trim().equals(password)) {
                    return true; // Credentials match
                }
            }
        }
        return false;
    }
}