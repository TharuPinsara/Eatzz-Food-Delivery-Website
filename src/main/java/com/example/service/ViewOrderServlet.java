package com.example.service;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

@WebServlet("/ViewOrderServlet")
public class ViewOrderServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orderId = request.getParameter("orderId");
        String filePath = getServletContext().getRealPath("/WEB-INF/orders/order_history.txt");
        File orderFile = new File(filePath);

        if (orderId == null || orderId.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Order ID is required");
            return;
        }

        String[] orderDetails = null;
        if (orderFile.exists() && orderFile.canRead()) {
            try (BufferedReader reader = new BufferedReader(new FileReader(orderFile))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    String[] details = line.split(",", -1);
                    if (details.length >= 8 && details[0].equals(orderId)) {
                        orderDetails = details;
                        break;
                    }
                }
            }
        }

        if (orderDetails != null) {
            request.setAttribute("orderId", orderDetails[0]);
            request.setAttribute("username", orderDetails[1]);
            request.setAttribute("email", orderDetails[2]);
            request.setAttribute("address", orderDetails[3]);
            request.setAttribute("totalPrice", orderDetails[4]);
            request.setAttribute("date", orderDetails[5]);
            request.setAttribute("status", orderDetails[6]);
            request.setAttribute("items", orderDetails[7]);
            request.getRequestDispatcher("/AdminPage/ViewOrder.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?error=Order%20not%20found");
        }
    }
}