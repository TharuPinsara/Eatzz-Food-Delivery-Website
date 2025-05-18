package com.example.menu.foodapp;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/DeleteFoodItemServlet")
public class DeleteFoodItemServlet extends HttpServlet {
    private static final String FOOD_FILE = "WEB-INF/fooditems.txt";
    private static final Logger LOGGER = Logger.getLogger(DeleteFoodItemServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String foodName = request.getParameter("name");
        String tab = request.getParameter("tab");

        if (foodName == null || foodName.trim().isEmpty()) {
            LOGGER.warning("No food name provided for deletion.");
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?tab=" + (tab != null ? tab : "food") + "&error=noNameProvided");
            return;
        }

        // Decode URL-encoded foodName to handle special characters
        foodName = URLDecoder.decode(foodName.trim(), "UTF-8");
        LOGGER.info("Received foodName for deletion: '" + foodName + "'");

        String filePath = getServletContext().getRealPath(FOOD_FILE);
        List<String> updatedItems = new ArrayList<>();
        boolean itemFound = false;

        // Read the existing food items
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] details = line.split(",", -1); // Comma-separated values
                if (details.length >= 4) {
                    String itemName = details[0].trim();
                    LOGGER.fine("Checking item: '" + itemName + "' (raw: '" + details[0] + "')");
                    if (itemName.equalsIgnoreCase(foodName) || itemName.equals(foodName)) {
                        itemFound = true; // Skip this line to delete the item
                        LOGGER.info("Found and marked for deletion: '" + itemName + "'");
                    } else {
                        updatedItems.add(line);
                    }
                } else {
                    LOGGER.warning("Invalid line format: '" + line + "'");
                    updatedItems.add(line); // Keep invalid lines to avoid data loss
                }
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error reading fooditems.txt: " + filePath, e);
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?tab=" + (tab != null ? tab : "food") + "&error=loadFailed");
            return;
        }

        if (!itemFound) {
            LOGGER.warning("Food item not found: '" + foodName + "'");
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?tab=" + (tab != null ? tab : "food") + "&error=foodNotFound");
            return;
        }

        // Write the updated list back to the file
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            for (String item : updatedItems) {
                writer.write(item);
                writer.newLine();
            }
            LOGGER.info("Successfully deleted food item: '" + foodName + "'");
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?tab=" + (tab != null ? tab : "food") + "&success=foodDeleted");
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error writing to fooditems.txt: " + filePath, e);
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?tab=" + (tab != null ? tab : "food") + "&error=saveFailed");
        }
    }
}