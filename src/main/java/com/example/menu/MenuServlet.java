package com.example.menu;

import com.example.util.QuickSort;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<MenuItem> menuItems = new ArrayList<>();
        menuItems.add(new MenuItem("Cheese Pizza", 1200));
        menuItems.add(new MenuItem("Veg Burger", 950));
        menuItems.add(new MenuItem("Chicken Biryani", 1450));
        menuItems.add(new MenuItem("Pasta Alfredo", 1300));
        menuItems.add(new MenuItem("Chocolate Cake", 800));
        menuItems.add(new MenuItem("Greek Salad", 750));
        menuItems.add(new MenuItem("Grilled Salmon", 1800));

        // Sort the menu items by price using QuickSort
        List<MenuItem> sortedMenuItems = QuickSort.sortMenuItemsByPrice(menuItems);

        // Pass the sorted list to the JSP page
        request.setAttribute("menuItems", sortedMenuItems);
        request.getRequestDispatcher("/MenuPage.jsp").forward(request, response);
    }
}