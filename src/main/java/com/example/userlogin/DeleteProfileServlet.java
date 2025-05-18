package com.example.userlogin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/DeleteProfileServlet")
public class DeleteProfileServlet extends HttpServlet {
    private static final String USER_FILE = "WEB-INF/users.txt";
    private static final Logger LOGGER = Logger.getLogger(DeleteProfileServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        LOGGER.info("DeleteProfileServlet: Received POST request");

        HttpSession session = request.getSession(false);
        String loggedUser = (session != null) ? (String) session.getAttribute("username") : null;
        String username = request.getParameter("username");

        // Validate session and username
        if (loggedUser == null || username == null || !loggedUser.equals(username)) {
            LOGGER.warning("DeleteProfileServlet: Unauthorized access or invalid session for username: " + username);
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=Unauthorized access or invalid session");
            return;
        }

        String filePath = getServletContext().getRealPath(USER_FILE);
        File file = new File(filePath);
        if (!file.exists()) {
            LOGGER.severe("DeleteProfileServlet: User database not found at: " + filePath);
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=User database not found");
            return;
        }

        // Read all users except the one to delete
        List<String> updatedUsers = new ArrayList<>();
        boolean userFound = false;

        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] details = line.split(",", -1);
                if (details.length >= 1 && details[0].equals(username)) {
                    userFound = true;
                    LOGGER.info("DeleteProfileServlet: Found user to delete: " + username);
                    continue; // Skip the user to delete
                }
                updatedUsers.add(line);
            }
        } catch (IOException e) {
            LOGGER.severe("DeleteProfileServlet: Error reading user database: " + e.getMessage());
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=Error reading user database: " + e.getMessage());
            return;
        }

        if (!userFound) {
            LOGGER.warning("DeleteProfileServlet: User not found: " + username);
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=User not found");
            return;
        }

        // Write updated user list back to file
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            for (String userLine : updatedUsers) {
                writer.write(userLine);
                writer.newLine();
            }
            LOGGER.info("DeleteProfileServlet: Successfully updated users.txt, user deleted: " + username);
        } catch (IOException e) {
            LOGGER.severe("DeleteProfileServlet: Error updating user database: " + e.getMessage());
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=Error updating user database: " + e.getMessage());
            return;
        }

        // Invalidate session and redirect with success message
        session.invalidate();
        LOGGER.info("DeleteProfileServlet: Session invalidated for user: " + username);
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.sendRedirect(request.getContextPath() + "/index.jsp?success=Account deleted successfully");
    }
}