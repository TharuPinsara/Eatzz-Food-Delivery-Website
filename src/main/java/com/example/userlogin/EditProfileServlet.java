package com.example;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/EditProfileServlet")
public class EditProfileServlet extends HttpServlet {

    private static final String USER_FILE = "WEB-INF/users.txt";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve form parameters
        String originalUsername = request.getParameter("originalUsername");
        String newUsername = request.getParameter("username");
        String newPassword = request.getParameter("password");
        String newEmail = request.getParameter("email");
        String newPhone = request.getParameter("phone");
        String newAddress = request.getParameter("address");

        // Validate required fields
        if (newUsername == null || newUsername.trim().isEmpty() ||
                newEmail == null || newEmail.trim().isEmpty() ||
                newPhone == null || newPhone.trim().isEmpty() ||
                newAddress == null || newAddress.trim().isEmpty()) {
            request.setAttribute("error", "All fields except password are required.");
            request.getRequestDispatcher("/UserProfile/editUser.jsp").forward(request, response);
            return;
        }

        String filePath = getServletContext().getRealPath(USER_FILE);
        List<String> users = new ArrayList<>();
        boolean userFound = false;
        String existingPassword = "";

        // Read user data
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] userDetails = line.split(",", -1);
                if (userDetails.length >= 5 && userDetails[0].equals(originalUsername)) {
                    // Store existing password
                    existingPassword = userDetails[1];
                    // Use new password if provided, otherwise keep existing
                    String passwordToUse = (newPassword != null && !newPassword.trim().isEmpty()) ? newPassword : existingPassword;
                    users.add(newUsername + "," + passwordToUse + "," + newEmail + "," + newPhone + "," + newAddress);
                    userFound = true;
                } else {
                    users.add(line);
                }
            }
        } catch (IOException e) {
            request.setAttribute("error", "Error reading users.txt: " + e.getMessage());
            request.getRequestDispatcher("/UserProfile/editUser.jsp").forward(request, response);
            return;
        }

        // Write updated users back to file
        if (userFound) {
            synchronized (this) {
                try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
                    for (String user : users) {
                        writer.write(user);
                        writer.newLine();
                    }
                } catch (IOException e) {
                    request.setAttribute("error", "Error writing to users.txt: " + e.getMessage());
                    request.getRequestDispatcher("/UserProfile/editUser.jsp").forward(request, response);
                    return;
                }
            }

            // Update session attributes
            HttpSession session = request.getSession();
            session.setAttribute("username", newUsername);
            session.setAttribute("email", newEmail);
            session.setAttribute("phone", newPhone);
            session.setAttribute("address", newAddress);

            request.setAttribute("message", "Profile updated successfully!");
        } else {
            request.setAttribute("error", "User not found.");
        }

        // Forward back to editUser.jsp
        request.getRequestDispatcher("/UserProfile/editUser.jsp").forward(request, response);
    }
}