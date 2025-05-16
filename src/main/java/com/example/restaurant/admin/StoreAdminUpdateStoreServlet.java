package com.example.restaurant.admin;

import com.example.restaurant.Restaurant;
import com.example.restaurant.RestaurantUtil;
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

@WebServlet("/StoreAdminUpdateStoreServlet")
public class StoreAdminUpdateStoreServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String storeName = (String) session.getAttribute("storeName");
        String originalName = request.getParameter("originalName");
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String phoneNumber = request.getParameter("phoneNumber");

        if (name == null || name.trim().isEmpty() || address == null || address.trim().isEmpty() ||
                phoneNumber == null || phoneNumber.trim().isEmpty()) {
            response.sendRedirect("/RestaurantPage/Admin/StoreAdminDetails.jsp?error=invalid");
            return;
        }

        if (!originalName.equals(storeName)) {
            response.sendRedirect("/RestaurantPage/Admin/StoreAdminDetails.jsp?error=invalid");
            return;
        }

        ServletContext context = getServletContext();
        List<Restaurant> restaurants;
        try {
            restaurants = RestaurantUtil.loadRestaurants(context);
        } catch (IOException e) {
            response.sendRedirect("/RestaurantPage/Admin/StoreAdminDetails.jsp?error=failed");
            return;
        }

        for (Restaurant r : restaurants) {
            if (r.getName().equalsIgnoreCase(name.trim()) && !r.getName().equals(originalName)) {
                response.sendRedirect("/RestaurantPage/Admin/StoreAdminDetails.jsp?error=duplicate");
                return;
            }
        }

        boolean updated = false;
        List<Restaurant> updatedRestaurants = new ArrayList<>();
        for (Restaurant r : restaurants) {
            if (r.getName().equals(originalName)) {
                updatedRestaurants.add(new Restaurant(name.trim(), address.trim(), phoneNumber.trim()));
                updated = true;
            } else {
                updatedRestaurants.add(r);
            }
        }

        if (!updated) {
            response.sendRedirect("/RestaurantPage/Admin/StoreAdminDetails.jsp?error=failed");
            return;
        }

        try {
            RestaurantUtil.saveRestaurants(context, updatedRestaurants);
            session.setAttribute("storeName", name.trim());
            response.sendRedirect("/RestaurantPage/Admin/StoreAdminDetails.jsp?success=updated");
        } catch (IOException e) {
            response.sendRedirect("/RestaurantPage/Admin/StoreAdminDetails.jsp?error=failed");
        }
    }
}