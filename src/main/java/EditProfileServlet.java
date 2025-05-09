package com.example;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/EditProfileServlet")
public class EditProfileServlet extends HttpServlet {

    private static final String USER_FILE = "WEB-INF/users.txt";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String originalUsername = request.getParameter("originalUsername");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        String filePath = getServletContext().getRealPath(USER_FILE);
        List<String> users = new ArrayList<>();
        boolean userFound = false;

        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] userDetails = line.split(",");
                if (userDetails[0].equals(originalUsername)) {
                    users.add(username + "," + password + "," + email + "," + phone + "," + address);
                    userFound = true;
                } else {
                    users.add(line);
                }
            }
        }

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            if (userFound) {
                for (String u : users) {
                    writer.write(u);
                    writer.newLine();
                }
                request.setAttribute("message", "Profile updated successfully!");
            } else {
                request.setAttribute("error", "User not found.");
            }
        }

        // Forward back to the editUser.jsp page with a success/error message
        request.getRequestDispatcher("/UserProfile/editUser.jsp").forward(request, response);
    }
}