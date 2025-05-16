package com.example.restaurant;

import com.example.menu.foodapp.FoodItem;
import com.example.menu.foodapp.FoodItemFileUtil;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/Restaurants")
public class RestaurantServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/RestaurantPage/RestaurantPage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String phoneNumber = request.getParameter("phoneNumber");
        String[] foodNames = request.getParameterValues("foodName[]");
        String[] foodPrices = request.getParameterValues("foodPrice[]");
        String[] foodImages = request.getParameterValues("foodImage[]");

        // Validate restaurant inputs
        if (name == null || name.trim().isEmpty() ||
                address == null || address.trim().isEmpty() ||
                phoneNumber == null || phoneNumber.trim().isEmpty() ||
                !phoneNumber.trim().matches("\\d{10}")) { // Added phone number format validation
            response.sendRedirect(request.getContextPath() + "/RestaurantPage/AddRestaurant.jsp?error=invalidInput");
            return;
        }

        ServletContext context = getServletContext();

        // Check for duplicate restaurant
        try {
            List<Restaurant> restaurants = RestaurantUtil.loadRestaurants(context);
            for (Restaurant r : restaurants) {
                if (r.getName().equalsIgnoreCase(name.trim())) {
                    response.sendRedirect(request.getContextPath() + "/RestaurantPage/AddRestaurant.jsp?error=duplicateRestaurant");
                    return;
                }
            }
        } catch (IOException e) {
            response.sendRedirect(request.getContextPath() + "/RestaurantPage/AddRestaurant.jsp?error=loadFailed");
            return;
        }

        // Create Restaurant object
        Restaurant restaurant = new Restaurant(name.trim(), address.trim(), phoneNumber.trim());

        // Save restaurant to Restaurant.txt
        try {
            RestaurantUtil.addRestaurant(context, restaurant);
        } catch (IOException e) {
            response.sendRedirect(request.getContextPath() + "/RestaurantPage/AddRestaurant.jsp?error=restaurantSaveFailed");
            return;
        }

        // Process food items
        if (foodNames != null && foodPrices != null && foodImages != null &&
                foodNames.length == foodPrices.length && foodNames.length == foodImages.length) {
            List<FoodItem> existingFoodItems;
            try {
                existingFoodItems = FoodItemFileUtil.loadFoodItems(context);
            } catch (IOException e) {
                response.sendRedirect(request.getContextPath() + "/RestaurantPage/AddRestaurant.jsp?error=foodLoadFailed");
                return;
            }

            for (int i = 0; i < foodNames.length; i++) {
                if (foodNames[i] == null || foodNames[i].trim().isEmpty() ||
                        foodPrices[i] == null || foodPrices[i].trim().isEmpty()) {
                    continue; // Skip invalid food items
                }

                double price;
                try {
                    price = Double.parseDouble(foodPrices[i]);
                    if (price < 0) {
                        throw new NumberFormatException("Price cannot be negative.");
                    }
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/RestaurantPage/AddRestaurant.jsp?error=invalidPrice");
                    return;
                }

                // Check for duplicate food item name
                String foodName = foodNames[i].trim();
                for (FoodItem item : existingFoodItems) {
                    if (item.getName().equalsIgnoreCase(foodName)) {
                        response.sendRedirect(request.getContextPath() + "/RestaurantPage/AddRestaurant.jsp?error=duplicateFoodName");
                        return;
                    }
                }

                String imagePath = foodImages[i] != null && !foodImages[i].isEmpty() ? foodImages[i].trim() : "/images/default.jpg";
                FoodItem item = new FoodItem(foodName, price, name.trim(), imagePath);
                existingFoodItems.add(item);
            }

            // Save updated food items
            try {
                FoodItemFileUtil.saveFoodItems(context, existingFoodItems);
            } catch (IOException e) {
                response.sendRedirect(request.getContextPath() + "/RestaurantPage/AddRestaurant.jsp?error=foodSaveFailed");
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/Restaurants?success=restaurantAdded");
    }
}