package com.example;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/EditFoodItemServlet")
public class EditFoodItemServlet extends HttpServlet {
    private static final String FOOD_FILE = "WEB-INF/fooditems.txt";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String foodName = request.getParameter("name");

        if (foodName == null || foodName.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?error=noNameProvided");
            return;
        }

        String filePath = getServletContext().getRealPath(FOOD_FILE);

        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] details = line.split(",");
                if (details.length >= 4 && details[0].equals(foodName)) {
                    request.setAttribute("name", details[0]);
                    request.setAttribute("price", details[1]);
                    request.setAttribute("store", details[2]);
                    request.setAttribute("image_url", details[3]);
                    request.getRequestDispatcher("/AdminPage/EditFoodItem.jsp").forward(request, response);
                    return;
                }
            }
        }
        response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?error=foodNotFound");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String price = request.getParameter("price");
        String store = request.getParameter("store");
        String imageUrl = request.getParameter("image_url");

        if (name == null || price == null || store == null || imageUrl == null) {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?error=missingFields");
            return;
        }

        String filePath = getServletContext().getRealPath(FOOD_FILE);
        List<String> updatedItems = new ArrayList<>();
        boolean itemUpdated = false;

        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] details = line.split(",");
                if (details.length >= 4 && details[0].equals(name)) {
                    updatedItems.add(String.join(",", name, price, store, imageUrl));
                    itemUpdated = true;
                } else {
                    updatedItems.add(line);
                }
            }
        }

        if (itemUpdated) {
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
                for (String item : updatedItems) {
                    writer.write(item);
                    writer.newLine();
                }
            }
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?success=foodUpdated");
        } else {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?error=updateFailed");
        }
    }
}