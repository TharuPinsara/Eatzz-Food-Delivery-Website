package com.example.restaurant.admin;

import com.example.menu.foodapp.FoodItem;
import com.example.menu.foodapp.FoodItemFileUtil;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/StoreAdminAddFoodServlet")
public class StoreAdminAddFoodServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String storeName = (String) session.getAttribute("storeName");
        String name = request.getParameter("name");
        String priceStr = request.getParameter("price");
        String imageUrl = request.getParameter("image_url");

        if (name == null || name.trim().isEmpty() || priceStr == null || priceStr.trim().isEmpty() || 
            imageUrl == null || imageUrl.trim().isEmpty()) {
            response.sendRedirect("/RestaurantPage/Admin/StoreAdminAddFood.jsp?error=missingFields");
            return;
        }

        double price;
        try {
            price = Double.parseDouble(priceStr.trim());
            if (price < 0) {
                response.sendRedirect("/RestaurantPage/Admin/StoreAdminAddFood.jsp?error=invalidPrice");
                return;
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("/RestaurantPage/Admin/StoreAdminAddFood.jsp?error=invalidPrice");
            return;
        }

        ServletContext context = getServletContext();
        List<FoodItem> foodItems;
        try {
            foodItems = FoodItemFileUtil.loadFoodItems(context);
        } catch (IOException e) {
            response.sendRedirect("/RestaurantPage/Admin/StoreAdminAddFood.jsp?error=loadFailed");
            return;
        }

        for (FoodItem item : foodItems) {
            if (item.getName().equalsIgnoreCase(name.trim()) && item.getStoreName().equals(storeName)) {
                response.sendRedirect("/RestaurantPage/Admin/StoreAdminAddFood.jsp?error=duplicateName");
                return;
            }
        }

        FoodItem newItem = new FoodItem(name.trim(), price, storeName, imageUrl.trim());
        foodItems.add(newItem);

        try {
            FoodItemFileUtil.saveFoodItems(context, foodItems);
            response.sendRedirect("/RestaurantPage/Admin/StoreAdminAddFood.jsp?success=added");
        } catch (IOException e) {
            response.sendRedirect("/RestaurantPage/Admin/StoreAdminAddFood.jsp?error=saveFailed");
        }
    }
}