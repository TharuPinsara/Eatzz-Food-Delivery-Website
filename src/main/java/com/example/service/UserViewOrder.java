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

@WebServlet("/UserViewOrder")
public class UserViewOrder extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        String loggedUser = (String) request.getSession().getAttribute("username");
        if (loggedUser == null) {
            response.sendRedirect("/index.jsp");
            return;
        }

        // Get orderId from request
        String orderId = request.getParameter("orderId");
        if (orderId == null || orderId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/UserProfile/ViewUserOrders.jsp?error=Invalid order ID");
            return;
        }

        // Path to order_history.txt
        String orderFilePath = getServletContext().getRealPath("/") + "WEB-INF/orders/order_history.txt";
        File orderFile = new File(orderFilePath);
        boolean orderFound = false;

        // Read order details
        if (orderFile.exists() && orderFile.canRead()) {
            try (BufferedReader br = new BufferedReader(new FileReader(orderFile))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] orderDetails = line.split(",", -1);
                    if (orderDetails.length == 8 && orderDetails[0].equals(orderId)) {
                        // Verify order belongs to logged-in user
                        if (!orderDetails[1].equals(loggedUser)) {
                            response.sendRedirect(request.getContextPath() + "/UserProfile/ViewUserOrders.jsp?error=Unauthorized access");
                            return;
                        }
                        // Set order attributes
                        request.setAttribute("orderId", orderDetails[0]);
                        request.setAttribute("username", orderDetails[1]);
                        request.setAttribute("email", orderDetails[2]);
                        request.setAttribute("address", orderDetails[3]);
                        request.setAttribute("totalPrice", orderDetails[4]);
                        request.setAttribute("date", orderDetails[5]);
                        request.setAttribute("status", orderDetails[6]);
                        request.setAttribute("items", orderDetails[7]);
                        orderFound = true;
                        break;
                    }
                }
            } catch (IOException e) {
                System.out.println("Error reading orders: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/UserProfile/ViewUserOrders.jsp?error=Error reading orders: " + e.getMessage());
                return;
            }
        } else {
            System.out.println("Order file does not exist or cannot be read at: " + orderFilePath);
        }

        // Fetch phone from users.txt if order is found
        String phone = "";
        if (orderFound) {
            String userFilePath = getServletContext().getRealPath("/") + "WEB-INF/users.txt";
            File userFile = new File(userFilePath);
            if (userFile.exists() && userFile.canRead()) {
                try (BufferedReader br = new BufferedReader(new FileReader(userFile))) {
                    String line;
                    while ((line = br.readLine()) != null) {
                        String[] userDetails = line.split(",", -1);
                        if (userDetails.length >= 4 && userDetails[0].equals(loggedUser)) {
                            phone = userDetails[3]; // Phone is the 4th field (index 3)
                            System.out.println("Found phone for user " + loggedUser + ": " + phone);
                            break;
                        } else {
                            System.out.println("Skipping malformed user line for " + loggedUser + ": " + line);
                        }
                    }
                } catch (IOException e) {
                    System.out.println("Error reading users: " + e.getMessage());
                }
            } else {
                System.out.println("User file does not exist or cannot be read at: " + userFilePath);
            }
            request.setAttribute("phone", phone != null ? phone : "");
            System.out.println("Set phone attribute: " + phone);
        }

        // Forward to JSP or show error
        if (orderFound) {
            request.getRequestDispatcher("/UserProfile/UserViewOrder.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/UserProfile/ViewUserOrders.jsp?error=Order not found");
        }
    }
}
