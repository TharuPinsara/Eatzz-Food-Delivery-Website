// Admin Page Edit User
package com.example;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
        Map<String, String[]> userData = new HashMap<>();

        // Read user data from the file
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] details = line.split(",");
                // Ensure the file contains enough data, including the address field
                if (details.length >= 5) {
                    userData.put(details[0], new String[] { details[1], details[2], details[3], details[4] });
                }
            }
        }

        // Check if the user exists in the file
        if (userData.containsKey(username)) {
            String[] details = userData.get(username); // Retrieve the user's data from the map
            request.setAttribute("username", username);
            request.setAttribute("password", details[0]);
            request.setAttribute("email", details[1]);
            request.setAttribute("phone", details[2]);
            request.setAttribute("address", details[3]); // Pass the address to the JSP
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

        String filePath = getServletContext().getRealPath(USER_FILE);
        List<String> updatedUsers = new ArrayList<>();
        boolean userUpdated = false;

        // Read and update the user information
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] details = line.split(",");

                // Check if this line corresponds to the user being edited
                if (details.length >= 4 && details[0].equals(username)) {
                    // Update user attributes
                    updatedUsers.add(username + "," + newPassword + "," + newEmail + "," + newPhone + "," + newAddress);
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