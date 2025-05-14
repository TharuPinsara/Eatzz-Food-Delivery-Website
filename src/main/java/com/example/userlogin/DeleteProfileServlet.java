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

@WebServlet("/DeleteProfileServlet")
public class DeleteProfileServlet extends HttpServlet {
    private static final String USER_FILE = "/WEB-INF/users.txt";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the username from the form
        String usernameToDelete = request.getParameter("username");
        System.err.println("DeleteProfileServlet: Attempting to delete user: " + usernameToDelete);

        // Get the logged-in user from the session
        HttpSession session = request.getSession(false);
        String loggedUser = (session != null) ? (String) session.getAttribute("username") : null;

        // Verify the user is logged in and deleting their own account
        if (loggedUser == null || !loggedUser.equals(usernameToDelete)) {
            System.err.println("DeleteProfileServlet: Unauthorized action - loggedUser=" + loggedUser + ", usernameToDelete=" + usernameToDelete);
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=Unauthorized%20action");
            return;
        }

        // Path to users.txt
        String filePath = getServletContext().getRealPath(USER_FILE);
        File file = new File(filePath);
        List<String> updatedUsers = new ArrayList<>();

        // Check if file exists
        if (!file.exists()) {
            System.err.println("DeleteProfileServlet: users.txt not found at: " + filePath);
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=User%20data%20file%20not%20found");
            return;
        }

        // Read and remove the user
        boolean userFound = false;
        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] details = line.split(",");
                if (!details[0].equals(usernameToDelete)) {
                    updatedUsers.add(line);
                } else {
                    userFound = true;
                }
            }
        } catch (IOException e) {
            System.err.println("DeleteProfileServlet: Error reading users.txt: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=Error%20deleting%20account");
            return;
        }

        if (!userFound) {
            System.err.println("DeleteProfileServlet: User not found in users.txt: " + usernameToDelete);
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=User%20not%20found");
            return;
        }

        // Write back the updated list
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
            for (String user : updatedUsers) {
                writer.write(user);
                writer.newLine();
            }
            System.err.println("DeleteProfileServlet: User deleted successfully: " + usernameToDelete);
        } catch (IOException e) {
            System.err.println("DeleteProfileServlet: Error writing to users.txt: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=Error%20deleting%20account");
            return;
        }

        // Invalidate the session to log out the user
        if (session != null) {
            System.err.println("DeleteProfileServlet: Invalidating session for user: " + loggedUser);
            session.invalidate();
        }

        // Redirect to the login page with a success message
        response.sendRedirect(request.getContextPath() + "/index.jsp?success=Account%20deleted%20successfully");
    }
}