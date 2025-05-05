package com.example.service;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpSession;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

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
                    String[] userData = line.split(","); // Split by comma
                    if (userData.length == 4) { // Only include rows with exactly 4 elements
                        users.add(userData);
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