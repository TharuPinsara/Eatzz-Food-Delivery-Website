package com.example.menu.foodapp;

import com.example.restaurant.Restaurant;
import com.example.restaurant.RestaurantUtil;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AddFoodItemServlet", value = "/AddFoodItemServlet")
public class AddFoodItemServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Extract form parameters
        String name = request.getParameter("name");
        String priceStr = request.getParameter("price");
        String store = request.getParameter("store");
        String imageUrl = request.getParameter("image_url");

        // Validate input
        if (name == null || name.trim().isEmpty() ||
                priceStr == null || priceStr.trim().isEmpty() ||
                store == null || store.trim().isEmpty() ||
                imageUrl == null || imageUrl.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AddFoodItem.jsp?error=missingFields");
            return;
        }

        double price;
        try {
            price = Double.parseDouble(priceStr);
            if (price < 0) {
                throw new NumberFormatException("Price cannot be negative.");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AddFoodItem.jsp?error=invalidPrice");
            return;
        }

        ServletContext context = getServletContext();

        // Check for duplicate food item name
        List<FoodItem> foodItems;
        try {
            foodItems = FoodItemFileUtil.loadFoodItems(context);
            for (FoodItem item : foodItems) {
                if (item.getName().equalsIgnoreCase(name.trim())) {
                    response.sendRedirect(request.getContextPath() + "/AdminPage/AddFoodItem.jsp?error=duplicateName");
                    return;
                }
            }
        } catch (IOException e) {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AddFoodItem.jsp?error=loadFailed");
            return;
        }

        // Check if store exists in Restaurant.txt, add if not
        try {
            List<Restaurant> restaurants = RestaurantUtil.loadRestaurants(context);
            boolean storeExists = restaurants.stream().anyMatch(r -> r.getName().equalsIgnoreCase(store.trim()));
            if (!storeExists) {
                Restaurant newRestaurant = new Restaurant(store.trim(), "Unknown", "N/A");
                RestaurantUtil.addRestaurant(context, newRestaurant);
            }
        } catch (IOException e) {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AddFoodItem.jsp?error=restaurantSaveFailed");
            return;
        }

        // Create FoodItem object
        FoodItem foodItem = new FoodItem(
                name.trim(),
                price,
                store.trim(),
                imageUrl.trim()
        );

        // Add new food item to the list and save
        try {
            foodItems.add(foodItem);
            FoodItemFileUtil.saveFoodItems(context, foodItems);
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?success=foodAdded");
        } catch (IOException e) {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AddFoodItem.jsp?error=saveFailed");
        }
    }
}