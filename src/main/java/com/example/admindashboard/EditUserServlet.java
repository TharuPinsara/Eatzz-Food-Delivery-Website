// Admin Page Edit User
package com.example.admindashboard;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Base64;
import com.example.userlogin.User;

@WebServlet("/EditUserServlet")
public class EditUserServlet extends HttpServlet {
    private static final String USER_FILE = "WEB-INF/users.txt";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");

        // Check if the username was provided
        if (username == null || username.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Username is required");
            return;
        }

        String filePath = getServletContext().getRealPath(USER_FILE);
        User targetUser = null;

        // Read user data from the file
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                try {
                    User user = User.fromString(line);
                    if (user.getUsername().equals(username)) {
                        targetUser = user;
                        break;
                    }
                } catch (IllegalArgumentException e) {
                    // Skip invalid lines
                    continue;
                }
            }
        }

        // Check if the user exists in the file
        if (targetUser != null) {
            request.setAttribute("username", targetUser.getUsername());
            request.setAttribute("password", targetUser.getPassword()); // Decoded password
            request.setAttribute("email", targetUser.getEmail()); // Decoded email
            request.setAttribute("phone", targetUser.getPhone());
            request.setAttribute("address", targetUser.getAddress());
            request.getRequestDispatcher("/AdminPage/EditUser.jsp").forward(request, response);
        } else {
            // User not found
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username"); // Old username
        String newPassword = request.getParameter("password");
        String newEmail = request.getParameter("email");
        String newPhone = request.getParameter("phone");
        String newAddress = request.getParameter("address");

        // Encode password and email
        String encodedPassword = Base64.getEncoder().encodeToString(newPassword.getBytes());
        String encodedEmail = Base64.getEncoder().encodeToString(newEmail.getBytes());

        String filePath = getServletContext().getRealPath(USER_FILE);
        List<String> updatedUsers = new ArrayList<>();
        boolean userUpdated = false;

        // Read and update the user information
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] details = line.split(",", -1);
                if (details.length >= 5 && details[0].equals(username)) {
                    // Update user attributes with encoded password and email
                    updatedUsers.add(username + "," + encodedPassword + "," + encodedEmail + "," + newPhone + "," + newAddress);
                    userUpdated = true;
                } else {
                    updatedUsers.add(line);
                }
            }
        }

        // Write back the updated list to the file if the user was found and updated
        if (userUpdated) {
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
                for (String user : updatedUsers) {
                    writer.write(user);
                    writer.newLine();
                }
            }

            // Redirect to Admin Dashboard with a success message
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?success=userEdited");
        } else {
            // If user was not updated, send an error
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found or could not be updated");
        }
    }
}