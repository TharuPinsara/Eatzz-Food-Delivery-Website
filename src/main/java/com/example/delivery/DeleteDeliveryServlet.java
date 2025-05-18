package com.example.delivery;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/DeleteDeliveryServlet")
public class DeleteDeliveryServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orderId = request.getParameter("orderId");

        // Validate input
        if (orderId == null || orderId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?error=Invalid order ID");
            return;
        }

        // File path for delivery_details.txt
        String deliveryFilePath = getServletContext().getRealPath("/") + "WEB-INF/delivery_details.txt";
        File deliveryFile = new File(deliveryFilePath);

        // If file doesn't exist, no action needed
        if (!deliveryFile.exists()) {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?success=deliveryDeleted");
            return;
        }

        // Read existing records, excluding the one to delete
        List<String> lines = new ArrayList<>();
        boolean recordFound = false;
        try (BufferedReader reader = new BufferedReader(new FileReader(deliveryFile))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.startsWith(orderId + ",")) {
                    lines.add(line);
                } else {
                    recordFound = true;
                }
            }
        } catch (IOException e) {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?error=Error reading delivery file: " + e.getMessage());
            return;
        }

        // Write updated records back to file
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(deliveryFile))) {
            for (String line : lines) {
                writer.write(line);
                writer.newLine();
            }
        } catch (IOException e) {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?error=Error writing to delivery file: " + e.getMessage());
            return;
        }

        // Redirect with success message if record was found and deleted, or no record existed
        response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?success=deliveryDeleted");
    }
}