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
import java.util.Base64;
import com.example.userlogin.User;

@WebServlet("/EditUserOrder")
public class EditUserOrder extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        String loggedUser = (String) request.getSession().getAttribute("username");
        if (loggedUser == null) {
            response.sendRedirect("/index.jsp");
            return;
        }

        // Get parameters
        String orderId = request.getParameter("orderId");
        String newAddress = request.getParameter("address");
        String newPhone = request.getParameter("phone");

        if (orderId == null || orderId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/UserProfile/UserViewOrder.jsp?orderId=" + URLEncoder.encode("", "UTF-8") + "&error=" + URLEncoder.encode("Invalid order ID", "UTF-8"));
            return;
        }

        if (newAddress == null || newAddress.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/UserProfile/UserViewOrder.jsp?orderId=" + URLEncoder.encode(orderId, "UTF-8") + "&error=" + URLEncoder.encode("Address is required", "UTF-8"));
            return;
        }

        // Validate phone number format (optional, allow empty)
        if (newPhone != null && !newPhone.isEmpty() && !newPhone.matches("[0-9]{10}")) {
            response.sendRedirect(request.getContextPath() + "/UserProfile/UserViewOrder.jsp?orderId=" + URLEncoder.encode(orderId, "UTF-8") + "&error=" + URLEncoder.encode("Phone number must be 10 digits", "UTF-8"));
            return;
        }

        // Sanitize inputs (remove commas to prevent CSV injection)
        newAddress = newAddress.replace(",", "");
        newPhone = newPhone != null ? newPhone.replace(",", "") : "";

        // Log input parameters
        System.out.println("Processing EditUserOrder: orderId=" + orderId + ", newAddress=" + newAddress + ", newPhone=" + newPhone);

        // Path to order_history.txt
        String orderFilePath = getServletContext().getRealPath("/") + "WEB-INF/orders/order_history.txt";
        File orderFile = new File(orderFilePath);
        List<String> updatedOrders = new ArrayList<>();
        boolean orderFound = false;
        boolean isAuthorized = false;
        boolean isNotDelivered = false;
        String currentEmail = "";

        // Update address in order_history.txt (keep 8 fields)
        if (orderFile.exists() && orderFile.canRead()) {
            try (BufferedReader br = new BufferedReader(new FileReader(orderFile))) {
                String line;
                while ((line = br.readLine()) != null) {
                    System.out.println("Checking order line: " + line);
                    String[] orderDetails = line.split(",", -1);
                    if (orderDetails.length == 8 && orderDetails[0].trim().equals(orderId.trim())) {
                        orderFound = true;
                        if (orderDetails[1].equalsIgnoreCase(loggedUser)) {
                            isAuthorized = true;
                            if (!orderDetails[6].equals("Delivered")) {
                                isNotDelivered = true;
                                // Decode email to preserve it
                                currentEmail = orderDetails[2];
                                try {
                                    currentEmail = new String(Base64.getDecoder().decode(orderDetails[2]));
                                } catch (IllegalArgumentException e) {
                                    // Email is not Base64-encoded, use as is
                                }
                                // Update address only (keep 8 fields)
                                String updatedLine = orderDetails[0] + "," + orderDetails[1] + "," + orderDetails[2] + "," +
                                        newAddress + "," + orderDetails[4] + "," + orderDetails[5] + "," +
                                        orderDetails[6] + "," + orderDetails[7];
                                updatedOrders.add(updatedLine);
                                System.out.println("Updated order line: " + updatedLine);
                                continue;
                            }
                        }
                    }
                    updatedOrders.add(line);
                }
            } catch (IOException e) {
                System.out.println("Error reading orders: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/UserProfile/UserViewOrder.jsp?orderId=" + URLEncoder.encode(orderId, "UTF-8") + "&error=" + URLEncoder.encode("Error reading orders: " + e.getMessage(), "UTF-8"));
                return;
            }
        } else {
            System.out.println("Order file does not exist or cannot be read at: " + orderFilePath);
            response.sendRedirect(request.getContextPath() + "/UserProfile/UserViewOrder.jsp?orderId=" + URLEncoder.encode(orderId, "UTF-8") + "&error=" + URLEncoder.encode("Order file not found", "UTF-8"));
            return;
        }

        // Handle order errors
        if (!orderFound) {
            System.out.println("Order not found: " + orderId);
            response.sendRedirect(request.getContextPath() + "/UserProfile/UserViewOrder.jsp?orderId=" + URLEncoder.encode(orderId, "UTF-8") + "&error=" + URLEncoder.encode("Order not found", "UTF-8"));
            return;
        }
        if (!isAuthorized) {
            System.out.println("Unauthorized action for user: " + loggedUser);
            response.sendRedirect(request.getContextPath() + "/UserProfile/UserViewOrder.jsp?orderId=" + URLEncoder.encode(orderId, "UTF-8") + "&error=" + URLEncoder.encode("Unauthorized action", "UTF-8"));
            return;
        }
        if (!isNotDelivered) {
            System.out.println("Cannot edit delivered order: " + orderId);
            response.sendRedirect(request.getContextPath() + "/UserProfile/UserViewOrder.jsp?orderId=" + URLEncoder.encode(orderId, "UTF-8") + "&error=" + URLEncoder.encode("Cannot edit delivered order", "UTF-8"));
            return;
        }

        // Write updated orders back to order_history.txt
        if (orderFile.canWrite()) {
            try (BufferedWriter bw = new BufferedWriter(new FileWriter(orderFile))) {
                for (String line : updatedOrders) {
                    bw.write(line);
                    bw.newLine();
                }
                System.out.println("Successfully wrote updated orders to: " + orderFilePath);
            } catch (IOException e) {
                System.out.println("Error writing orders: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/UserProfile/UserViewOrder.jsp?orderId=" + URLEncoder.encode(orderId, "UTF-8") + "&error=" + URLEncoder.encode("Unable to update order: " + e.getMessage(), "UTF-8"));
                return;
            }
        } else {
            System.out.println("Cannot write to order file at: " + orderFilePath);
            response.sendRedirect(request.getContextPath() + "/UserProfile/UserViewOrder.jsp?orderId=" + URLEncoder.encode(orderId, "UTF-8") + "&error=" + URLEncoder.encode("Unable to update order due to file permissions", "UTF-8"));
            return;
        }

        // Path to users.txt
        String userFilePath = getServletContext().getRealPath("/") + "WEB-INF/users.txt";
        File userFile = new File(userFilePath);
        List<String> updatedUsers = new ArrayList<>();
        boolean userFound = false;

        // Update phone in users.txt
        if (userFile.exists() && userFile.canRead()) {
            try (BufferedReader br = new BufferedReader(new FileReader(userFile))) {
                String line;
                while ((line = br.readLine()) != null) {
                    System.out.println("Checking user line: " + line);
                    try {
                        User user = User.fromString(line);
                        if (user.getUsername().equalsIgnoreCase(loggedUser)) {
                            userFound = true;
                            // Encode password and email
                            String encodedPassword = Base64.getEncoder().encodeToString(user.getPassword().getBytes());
                            String encodedEmail = Base64.getEncoder().encodeToString(user.getEmail().getBytes());
                            // Update phone (index 3), preserve other fields
                            String updatedLine = user.getUsername() + "," + encodedPassword + "," + encodedEmail + "," + newPhone + "," + user.getAddress();
                            updatedUsers.add(updatedLine);
                            System.out.println("Updated user line: " + updatedLine);
                            continue;
                        }
                        updatedUsers.add(line);
                    } catch (IllegalArgumentException e) {
                        System.out.println("Skipping invalid user line: " + line);
                        updatedUsers.add(line);
                    }
                }
            } catch (IOException e) {
                System.out.println("Error reading users: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/UserProfile/UserViewOrder.jsp?orderId=" + URLEncoder.encode(orderId, "UTF-8") + "&error=" + URLEncoder.encode("Error reading users: " + e.getMessage(), "UTF-8"));
                return;
            }
        } else {
            System.out.println("User file does not exist or cannot be read at: " + userFilePath);
            response.sendRedirect(request.getContextPath() + "/UserProfile/UserViewOrder.jsp?orderId=" + URLEncoder.encode(orderId, "UTF-8") + "&error=" + URLEncoder.encode("User file not found", "UTF-8"));
            return;
        }

        // Handle user errors
        if (!userFound) {
            System.out.println("User not found: " + loggedUser);
            response.sendRedirect(request.getContextPath() + "/UserProfile/UserViewOrder.jsp?orderId=" + URLEncoder.encode(orderId, "UTF-8") + "&error=" + URLEncoder.encode("User not found", "UTF-8"));
            return;
        }

        // Write updated users back to users.txt
        if (userFile.canWrite()) {
            try (BufferedWriter bw = new BufferedWriter(new FileWriter(userFile))) {
                for (String line : updatedUsers) {
                    bw.write(line);
                    bw.newLine();
                }
                System.out.println("Successfully wrote updated users to: " + userFilePath);
            } catch (IOException e) {
                System.out.println("Error writing users: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/UserProfile/UserViewOrder.jsp?orderId=" + URLEncoder.encode(orderId, "UTF-8") + "&error=" + URLEncoder.encode("Unable to update user: " + e.getMessage(), "UTF-8"));
            }
        } else {
            System.out.println("Cannot write to user file at: " + userFilePath);
            response.sendRedirect(request.getContextPath() + "/UserProfile/UserViewOrder.jsp?orderId=" + URLEncoder.encode(orderId, "UTF-8") + "&error=" + URLEncoder.encode("Unable to update user due to file permissions", "UTF-8"));
            return;
        }

        // Redirect to success
        System.out.println("Redirecting to success for orderId: " + orderId);
        response.sendRedirect(request.getContextPath() + "/UserProfile/UserViewOrder.jsp?orderId=" + URLEncoder.encode(orderId, "UTF-8") + "&success=orderUpdated");
    }
}