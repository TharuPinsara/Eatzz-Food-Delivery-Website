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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/StoreAdminEditFoodServlet")
public class StoreAdminEditFoodServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String storeName = (String) session.getAttribute("storeName");
        String originalName = request.getParameter("originalName");
        String name = request.getParameter("name");
        String priceStr = request.getParameter("price");
        String imageUrl = request.getParameter("image_url");

        if (name == null || name.trim().isEmpty() || priceStr == null || priceStr.trim().isEmpty() || 
            imageUrl == null || imageUrl.trim().isEmpty()) {
            response.sendRedirect("/RestaurantPage/Admin/StoreAdminEditFoodItem.jsp?name=" + 
                java.net.URLEncoder.encode(originalName, "UTF-8") + "&error=invalid");
            return;
        }

        double price;
        try {
            price = Double.parseDouble(priceStr.trim());
            if (price < 0) {
                response.sendRedirect("/RestaurantPage/Admin/StoreAdminEditFoodItem.jsp?name=" + 
                    java.net.URLEncoder.encode(originalName, "UTF-8") + "&error=invalidPrice");
                return;
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("/RestaurantPage/Admin/StoreAdminEditFoodItem.jsp?name=" + 
                java.net.URLEncoder.encode(originalName, "UTF-8") + "&error=invalidPrice");
            return;
        }

        ServletContext context = getServletContext();
        List<FoodItem> foodItems;
        try {
            foodItems = FoodItemFileUtil.loadFoodItems(context);
        } catch (IOException e) {
            response.sendRedirect("/RestaurantPage/Admin/StoreAdminEditFoodItem.jsp?name=" + 
                java.net.URLEncoder.encode(originalName, "UTF-8") + "&error=loadFailed");
            return;
        }

        for (FoodItem item : foodItems) {
            if (item.getName().equalsIgnoreCase(name.trim()) && item.getStoreName().equals(storeName) && 
                !item.getName().equals(originalName)) {
                response.sendRedirect("/RestaurantPage/Admin/StoreAdminEditFoodItem.jsp?name=" + 
                    java.net.URLEncoder.encode(originalName, "UTF-8") + "&error=duplicate");
                return;
            }
        }

        boolean updated = false;
        List<FoodItem> updatedItems = new ArrayList<>();
        for (FoodItem item : foodItems) {
            if (item.getName().equals(originalName) && item.getStoreName().equals(storeName)) {
                updatedItems.add(new FoodItem(name.trim(), price, storeName, imageUrl.trim()));
                updated = true;
            } else {
                updatedItems.add(item);
            }
        }

        if (!updated) {
            response.sendRedirect("/RestaurantPage/Admin/StoreAdminEditFoodItem.jsp?name=" + 
                java.net.URLEncoder.encode(originalName, "UTF-8") + "&error=failed");
            return;
        }

        try {
            FoodItemFileUtil.saveFoodItems(context, updatedItems);
            response.sendRedirect("/RestaurantPage/Admin/StoreAdminEditFoodItem.jsp?name=" + 
                java.net.URLEncoder.encode(name, "UTF-8") + "&success=updated");
        } catch (IOException e) {
            response.sendRedirect("/RestaurantPage/Admin/StoreAdminEditFoodItem.jsp?name=" + 
                java.net.URLEncoder.encode(originalName, "UTF-8") + "&error=saveFailed");
        }
    }
}