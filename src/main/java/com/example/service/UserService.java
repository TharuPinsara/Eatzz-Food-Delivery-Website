package com.example.service;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpSession;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import com.example.userlogin.User;

public class UserService {

    private final ServletContext servletContext;

    // Constructor to use servlet context for file path resolution
    public UserService(ServletContext servletContext) {
        this.servletContext = servletContext;
    }

    // Validate admin session
    public boolean isAdminLoggedIn(HttpSession session) {
        return session != null && session.getAttribute("adminUser") != null;
    }

    // Fetch the list of users from the users.txt file
    public List<String[]> getUsers() {
        List<String[]> users = new ArrayList<>();

        // Get the absolute file path for users.txt
        String usersFilePath = servletContext.getRealPath("WEB-INF/users.txt");
        File userFile = new File(usersFilePath);

        if (userFile.exists()) {
            try (BufferedReader reader = new BufferedReader(new FileReader(userFile))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    try {
                        User user = User.fromString(line);
                        // Create array with decoded values
                        String[] userData = {
                                user.getUsername(),
                                user.getPassword(), // Decoded password
                                user.getEmail(),   // Decoded email
                                user.getPhone(),
                                user.getAddress()
                        };
                        users.add(userData);
                    } catch (IllegalArgumentException e) {
                        System.err.println("Skipping invalid user line: " + line);
                        continue;
                    }
                }
            } catch (IOException e) {
                e.printStackTrace();
                System.err.println("Error reading users file: " + e.getMessage());
            }
        } else {
            System.err.println("Users file not found at path: " + usersFilePath);
        }

        return users;
    }
}