package com.example.service;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/DeleteUserOrder")
public class DeleteUserOrder extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        String loggedUser = (String) request.getSession().getAttribute("username");
        if (loggedUser == null) {
            response.sendRedirect("/index.jsp");
            return;
        }

        // Get orderId from request
        String orderId = request.getParameter("orderId");
        if (orderId == null || orderId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/UserProfile//UserViewOrder.jsp?orderId=" + URLEncoder.encode("", "UTF-8") + "&error=" + URLEncoder.encode("Invalid order ID", "UTF-8"));
            return;
        }

        // Path to order_history.txt
        String orderFilePath = getServletContext().getRealPath("/") + "WEB-INF/orders/order_history.txt";
        File orderFile = new File(orderFilePath);
        List<String> updatedOrders = new ArrayList<>();
        boolean orderFound = false;
        boolean isAuthorized = false;
        boolean isPending = false;

        // Read orders and filter out the target order
        if (orderFile.exists() && orderFile.canRead()) {
            try (BufferedReader br = new BufferedReader(new FileReader(orderFile))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] orderDetails = line.split(",", -1);
                    if (orderDetails.length >= 8 && orderDetails[0].equals(orderId)) {
                        orderFound = true;
                        if (orderDetails[1].equals(loggedUser)) {
                            isAuthorized = true;
                            if (orderDetails[6].equals("Pending")) {
                                isPending = true;
                                continue; // Skip this order (delete it)
                            }
                        }
                    }
                    updatedOrders.add(line);
                }
            } catch (IOException e) {
                response.sendRedirect(request.getContextPath() + "/UserProfile//UserViewOrder.jsp?orderId=" + URLEncoder.encode(orderId, "UTF-8") + "&error=" + URLEncoder.encode("Error reading orders: " + e.getMessage(), "UTF-8"));
                return;
            }
        }

        // Handle errors
        if (!orderFound) {
            response.sendRedirect(request.getContextPath() + "/UserProfile//UserViewOrder.jsp?orderId=" + URLEncoder.encode(orderId, "UTF-8") + "&error=" + URLEncoder.encode("Order not found", "UTF-8"));
            return;
        }
        if (!isAuthorized) {
            response.sendRedirect(request.getContextPath() + "/UserProfile//UserViewOrder.jsp?orderId=" + URLEncoder.encode(orderId, "UTF-8") + "&error=" + URLEncoder.encode("Unauthorized action", "UTF-8"));
            return;
        }
        if (!isPending) {
            response.sendRedirect(request.getContextPath() + "/UserProfile//UserViewOrder.jsp?orderId=" + URLEncoder.encode(orderId, "UTF-8") + "&error=" + URLEncoder.encode("Cannot delete non-pending order", "UTF-8"));
            return;
        }

        // Write updated orders back to file
        if (orderFile.canWrite()) {
            try (BufferedWriter bw = new BufferedWriter(new FileWriter(orderFile))) {
                for (String line : updatedOrders) {
                    bw.write(line);
                    bw.newLine();
                }
            } catch (IOException e) {
                response.sendRedirect(request.getContextPath() + "/UserProfile//UserViewOrder.jsp?orderId=" + URLEncoder.encode(orderId, "UTF-8") + "&error=" + URLEncoder.encode("Unable to delete order: " + e.getMessage(), "UTF-8"));
                return;
            }
            response.sendRedirect(request.getContextPath() + "/UserProfile//UserViewOrder.jsp?success=orderDeleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/UserProfile/UserViewOrder.jsp?orderId=" + URLEncoder.encode(orderId, "UTF-8") + "&error=" + URLEncoder.encode("Unable to delete order due to file permissions", "UTF-8"));
        }
    }
}