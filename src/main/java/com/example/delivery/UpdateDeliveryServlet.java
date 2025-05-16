package com.example.delivery;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/UpdateDeliveryServlet")
public class UpdateDeliveryServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orderId = request.getParameter("orderId");
        String deliveryPartner = request.getParameter("deliveryPartner");
        String deliveryStatus = request.getParameter("deliveryStatus");
        String tab = request.getParameter("tab");

        // Validate inputs
        if (orderId == null || orderId.trim().isEmpty() ||
                (deliveryPartner == null && deliveryStatus == null)) {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?tab=" + (tab != null ? tab : "delivery") + "&error=Invalid input");
            return;
        }

        // Determine which field is being updated
        String updatedField = deliveryPartner != null ? "deliveryPartner" : "deliveryStatus";
        String updatedValue = deliveryPartner != null ? deliveryPartner : deliveryStatus;

        // File path for delivery_details.txt
        String deliveryFilePath = getServletContext().getRealPath("/") + "WEB-INF/delivery_details.txt";
        File deliveryFile = new File(deliveryFilePath);

        // Ensure file exists
        if (!deliveryFile.exists()) {
            deliveryFile.getParentFile().mkdirs();
            deliveryFile.createNewFile();
        }

        // Read existing records
        List<String> lines = new ArrayList<>();
        boolean recordExists = false;
        try (BufferedReader reader = new BufferedReader(new FileReader(deliveryFile))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] details = line.split(",");
                if (details.length >= 3 && details[0].equals(orderId)) {
                    // Update existing record
                    if (updatedField.equals("deliveryPartner")) {
                        lines.add(orderId + "," + updatedValue + "," + details[2]);
                    } else {
                        lines.add(orderId + "," + details[1] + "," + updatedValue);
                    }
                    recordExists = true;
                } else {
                    lines.add(line);
                }
            }
        } catch (IOException e) {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?tab=" + (tab != null ? tab : "delivery") + "&error=Error reading delivery file: " + e.getMessage());
            return;
        }

        // If no record exists, create a new one
        if (!recordExists) {
            String newRecord = orderId + ",";
            if (updatedField.equals("deliveryPartner")) {
                newRecord += updatedValue + ",Processing";
            } else {
                newRecord += "Not Assigned," + updatedValue;
            }
            lines.add(newRecord);
        }

        // Write updated records back to file
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(deliveryFile))) {
            for (String line : lines) {
                writer.write(line);
                writer.newLine();
            }
        } catch (IOException e) {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?tab=" + (tab != null ? tab : "delivery") + "&error=Error writing to delivery file: " + e.getMessage());
            return;
        }

        // Redirect back to the same tab with success message
        response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?tab=" + (tab != null ? tab : "delivery") + "&success=deliveryUpdated");
    }
}