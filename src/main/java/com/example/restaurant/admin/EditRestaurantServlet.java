package com.example.restaurant.admin;

import com.example.restaurant.Restaurant;
import com.example.restaurant.RestaurantUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/EditRestaurantServlet")
public class EditRestaurantServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        if (name == null || name.trim().isEmpty()) {
            response.sendRedirect("/AdminPage/AdminDashboard.jsp?tab=restaurants&error=invalid");
            return;
        }

        try {
            List<Restaurant> restaurants = RestaurantUtil.loadRestaurants(getServletContext());
            for (Restaurant r : restaurants) {
                if (r.getName().equals(name)) {
                    request.setAttribute("restaurant", r);
                    request.getRequestDispatcher("/AdminPage/EditRestaurant.jsp").forward(request, response);
                    return;
                }
            }
            response.sendRedirect("/AdminPage/AdminDashboard.jsp?tab=restaurants&error=notFound");
        } catch (Exception e) {
            response.sendRedirect("/AdminPage/AdminDashboard.jsp?tab=restaurants&error=loadFailed");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String originalName = request.getParameter("originalName");
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String phoneNumber = request.getParameter("phoneNumber");

        if (name == null || name.trim().isEmpty() || address == null || address.trim().isEmpty() ||
                phoneNumber == null || phoneNumber.trim().isEmpty()) {
            response.sendRedirect("/AdminPage/EditRestaurant.jsp?name=" +
                    java.net.URLEncoder.encode(originalName, "UTF-8") + "&error=invalid");
            return;
        }

        List<Restaurant> restaurants;
        try {
            restaurants = RestaurantUtil.loadRestaurants(getServletContext());
        } catch (IOException e) {
            response.sendRedirect("/AdminPage/EditRestaurant.jsp?tab=restaurants&name=" +
                    java.net.URLEncoder.encode(originalName, "UTF-8") + "&error=loadFailed");
            return;
        }

        for (Restaurant r : restaurants) {
            if (r.getName().equalsIgnoreCase(name.trim()) && !r.getName().equals(originalName)) {
                response.sendRedirect("/AdminPage/EditRestaurant.jsp?tab=restaurants&name=" +
                        java.net.URLEncoder.encode(originalName, "UTF-8") + "&error=duplicate");
                return;
            }
        }

        boolean updated = false;
        for (int i = 0; i < restaurants.size(); i++) {
            if (restaurants.get(i).getName().equals(originalName)) {
                restaurants.set(i, new Restaurant(name.trim(), address.trim(), phoneNumber.trim()));
                updated = true;
                break;
            }
        }

        if (!updated) {
            response.sendRedirect("/AdminPage/EditRestaurant.jsp?tab=restaurants&name=" +
                    java.net.URLEncoder.encode(originalName, "UTF-8") + "&error=failed");
            return;
        }

        try {
            RestaurantUtil.saveRestaurants(getServletContext(), restaurants);
            response.sendRedirect("/AdminPage/AdminDashboard.jsp?tab=restaurants&success=restaurantUpdated");
        } catch (IOException e) {
            response.sendRedirect("/AdminPage/EditRestaurant.jsp?tab=restaurants&name=" +
                    java.net.URLEncoder.encode(originalName, "UTF-8") + "&error=saveFailed");
        }
    }
}
