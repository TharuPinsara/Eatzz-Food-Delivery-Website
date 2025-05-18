//Admin Page Delete User

package com.example.admindashboard;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {
    private static final String USER_FILE = "WEB-INF/users.txt";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String usernameToDelete = request.getParameter("username");

        String filePath = getServletContext().getRealPath(USER_FILE);
        List<String> updatedUsers = new ArrayList<>();

        // Read and remove the user
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] details = line.split(",");
                if (!details[0].equals(usernameToDelete)) {
                    updatedUsers.add(line);
                }
            }
        }

        // Write back the updated list
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            for (String user : updatedUsers) {
                writer.write(user);
                writer.newLine();
            }
        }

        // Redirect to Admin Dashboard with a success message
        response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?success=userDeleted");
    }
}