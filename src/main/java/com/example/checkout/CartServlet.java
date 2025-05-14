package com.example.checkout;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private final List<String> cartItems = new ArrayList<>(); // Holds cart items
    private double totalPrice = 0.0; // Holds the total price of cart items

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("Debug - Forwarding to cart.jsp with cartItems and totalPrice.");
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("totalPrice", totalPrice);

        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String item = request.getParameter("item");

        if ("add".equalsIgnoreCase(action) && item != null) {
            // Add item to cart
            cartItems.add(item);
            totalPrice += 10.00; // Assume each item costs $10.00
        } else if ("remove".equalsIgnoreCase(action) && item != null) {
            // Remove item from cart
            cartItems.remove(item);
            totalPrice -= 10.00; // Deduct $10.00
        }

        // Redirect back to this servlet (to reload cart view)
        response.sendRedirect("cart");
    }
}