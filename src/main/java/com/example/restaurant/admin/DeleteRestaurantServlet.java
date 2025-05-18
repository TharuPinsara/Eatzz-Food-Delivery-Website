package com.example.restaurant.admin;

import com.example.restaurant.Restaurant;
import com.example.restaurant.RestaurantUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/DeleteRestaurantServlet")
public class DeleteRestaurantServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        if (name == null || name.trim().isEmpty()) {
            response.sendRedirect("/AdminPage/AdminDashboard.jsp?error=invalid");
            return;
        }

        List<Restaurant> restaurants;
        try {
            restaurants = RestaurantUtil.loadRestaurants(getServletContext());
        } catch (IOException e) {
            response.sendRedirect("/AdminPage/AdminDashboard.jsp?error=loadFailed");
            return;
        }

        List<Restaurant> updatedRestaurants = new ArrayList<>();
        boolean deleted = false;
        for (Restaurant r : restaurants) {
            if (!r.getName().equals(name)) {
                updatedRestaurants.add(r);
            } else {
                deleted = true;
            }
        }

        if (!deleted) {
            response.sendRedirect("/AdminPage/AdminDashboard.jsp?error=notFound");
            return;
        }

        try {
            RestaurantUtil.saveRestaurants(getServletContext(), updatedRestaurants);
            response.sendRedirect("/AdminPage/AdminDashboard.jsp?success=restaurantDeleted");
        } catch (IOException e) {
            response.sendRedirect("/AdminPage/AdminDashboard.jsp?error=saveFailed");
        }
    }
}
