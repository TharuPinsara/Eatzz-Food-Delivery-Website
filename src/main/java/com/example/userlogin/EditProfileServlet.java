package com.example.userlogin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.*;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/EditProfileServlet")
public class EditProfileServlet extends HttpServlet {
    private static final String USER_FILE = "WEB-INF/users.txt";
    private static final Logger LOGGER = Logger.getLogger(EditProfileServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        LOGGER.info("EditProfileServlet: Received POST request");

        // Retrieve form parameters
        String originalUsername = request.getParameter("originalUsername");
        String newUsername = request.getParameter("username");
        String newPassword = request.getParameter("password");
        String newEmail = request.getParameter("email");
        String newPhone = request.getParameter("phone");
        String newAddress = request.getParameter("address");

        // Validate session
        HttpSession session = request.getSession(false);
        String loggedUser = (session != null) ? (String) session.getAttribute("username") : null;
        if (loggedUser == null || !loggedUser.equals(originalUsername)) {
            LOGGER.warning("EditProfileServlet: Unauthorized access for username: " + originalUsername);
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            request.setAttribute("error", "Unauthorized access or invalid session.");
            request.getRequestDispatcher("/UserProfile/editUser.jsp").forward(request, response);
            return;
        }

        // Validate required fields
        if (newUsername == null || newUsername.trim().isEmpty() ||
                newEmail == null || newEmail.trim().isEmpty() ||
                newPhone == null || newPhone.trim().isEmpty() ||
                newAddress == null || newAddress.trim().isEmpty()) {
            LOGGER.warning("EditProfileServlet: Missing required fields");
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            request.setAttribute("error", "All fields except password are required.");
            request.getRequestDispatcher("/UserProfile/editUser.jsp").forward(request, response);
            return;
        }

        // Validate user data using User class
        User user = new User();
        try {
            user.setUsername(newUsername);
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                user.setPassword(newPassword);
            }
            user.setEmail(newEmail);
            user.setPhone(newPhone);
            user.setAddress(newAddress);
        } catch (IllegalArgumentException e) {
            LOGGER.warning("EditProfileServlet: Invalid user data: " + e.getMessage());
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            request.setAttribute("error", "Invalid input: " + e.getMessage());
            request.getRequestDispatcher("/UserProfile/editUser.jsp").forward(request, response);
            return;
        }

        String filePath = getServletContext().getRealPath(USER_FILE);
        File file = new File(filePath);
        if (!file.exists()) {
            file.getParentFile().mkdirs();
            file.createNewFile();
        }

        List<String> users = new ArrayList<>();
        boolean userFound = false;
        String existingEncodedPassword = "";

        // Read user data
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] userDetails = line.split(",", -1);
                if (userDetails.length >= 5 && userDetails[0].equals(originalUsername)) {
                    existingEncodedPassword = userDetails[1];
                    // Use new password if provided, otherwise keep existing encoded password
                    String passwordToUse = (newPassword != null && !newPassword.trim().isEmpty()) ?
                            Base64.getEncoder().encodeToString(newPassword.getBytes()) : existingEncodedPassword;
                    String encodedEmail = Base64.getEncoder().encodeToString(newEmail.getBytes());
                    users.add(newUsername + "," + passwordToUse + "," + encodedEmail + "," + newPhone + "," + newAddress);
                    userFound = true;
                    LOGGER.info("EditProfileServlet: Updated user: " + newUsername);
                } else {
                    users.add(line);
                }
            }
        } catch (IOException e) {
            LOGGER.severe("EditProfileServlet: Error reading users.txt: " + e.getMessage());
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            request.setAttribute("error", "Error reading users.txt: " + e.getMessage());
            request.getRequestDispatcher("/UserProfile/editUser.jsp").forward(request, response);
            return;
        }

        // Check if username is already taken (if changed)
        if (!originalUsername.equals(newUsername) && isUsernameTaken(newUsername, filePath)) {
            LOGGER.warning("EditProfileServlet: Username already taken: " + newUsername);
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            request.setAttribute("error", "Username already taken.");
            request.getRequestDispatcher("/UserProfile/editUser.jsp").forward(request, response);
            return;
        }

        // Write updated users back to file
        if (userFound) {
            synchronized (this) {
                try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
                    for (String userLine : users) {
                        writer.write(userLine);
                        writer.newLine();
                    }
                    LOGGER.info("EditProfileServlet: Successfully updated users.txt for user: " + newUsername);
                } catch (IOException e) {
                    LOGGER.severe("EditProfileServlet: Error writing to users.txt: " + e.getMessage());
                    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
                    request.setAttribute("error", "Error writing to users.txt: " + e.getMessage());
                    request.getRequestDispatcher("/UserProfile/editUser.jsp").forward(request, response);
                    return;
                }
            }

            // Update session attributes
            session.setAttribute("username", newUsername);
            session.setAttribute("email", newEmail);
            session.setAttribute("phone", newPhone);
            session.setAttribute("address", newAddress);

            request.setAttribute("message", "Profile updated successfully!");
        } else {
            LOGGER.warning("EditProfileServlet: User not found: " + originalUsername);
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            request.setAttribute("error", "User not found.");
        }

        // Forward back to editUser.jsp
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        request.getRequestDispatcher("/UserProfile/editUser.jsp").forward(request, response);
    }

    private boolean isUsernameTaken(String username, String filePath) throws IOException {
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] details = line.split(",", -1);
                if (details.length >= 1 && details[0].equalsIgnoreCase(username)) {
                    return true;
                }
            }
        }
        return false;
    }
}