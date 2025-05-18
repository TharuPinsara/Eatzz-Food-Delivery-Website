package com.example.checkout;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve cart data from form parameters
        List<CartItem> cartItems = new ArrayList<>();
        String[] ids = request.getParameterValues("cart.id");
        String[] names = request.getParameterValues("cart.name");
        String[] prices = request.getParameterValues("cart.price");
        String[] images = request.getParameterValues("cart.image");
        String[] stores = request.getParameterValues("cart.store");
        String[] quantities = request.getParameterValues("cart.quantity");

        // Validate form parameters
        if (ids != null && names != null && prices != null && images != null && stores != null && quantities != null
                && ids.length == names.length && ids.length == prices.length && ids.length == images.length
                && ids.length == stores.length && ids.length == quantities.length) {
            for (int i = 0; i < ids.length; i++) {
                try {
                    CartItem item = new CartItem();
                    item.id = ids[i];
                    item.name = names[i];
                    item.price = Double.parseDouble(prices[i]);
                    item.image = images[i];
                    item.store = stores[i];
                    item.quantity = Integer.parseInt(quantities[i]);
                    // Validate item data
                    if (item.quantity <= 0 || item.price < 0 || item.id.isEmpty() || item.name.isEmpty()) {
                        System.out.println("Invalid item data at index " + i);
                        continue;
                    }
                    cartItems.add(item);
                } catch (NumberFormatException e) {
                    System.out.println("Parsing error at index " + i + ": " + e.getMessage());
                    continue; // Skip invalid items
                }
            }
        }

        // Check if cart is empty
        if (cartItems.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No valid cart items");
            return;
        }

        // Retrieve user information from session
        HttpSession session = request.getSession();
        String userName = (String) session.getAttribute("username");
        String userEmail = (String) session.getAttribute("email");
        String userAddress = (String) session.getAttribute("address");
        String userPhone = (String) session.getAttribute("phone");

        // Fallback to defaults if session data is missing (e.g., user not logged in)
        if (userName == null || userEmail == null || userAddress == null || userPhone == null) {
            System.out.println("User not logged in, using default user data");
            userName = "Guest User";
            userEmail = "guest@example.com";
            userAddress = "N/A";
            userPhone = "N/A";
        }

        // Calculate total price
        double totalPrice = cartItems.stream()
                .mapToDouble(item -> item.price * item.quantity)
                .sum();

        // Generate order ID (timestamp-based hash)
        String orderId = "ORD-" + Math.abs((System.currentTimeMillis() + userEmail).hashCode());

        // Order details
        String orderDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        String orderStatus = "Pending";

        // Store orderId and totalPrice in session for PaymentGatewayServlet
        session.setAttribute("orderId", orderId);
        session.setAttribute("totalPrice", totalPrice);

        // Prepare order data for JSP
        request.setAttribute("orderId", orderId);
        request.setAttribute("userName", userName);
        request.setAttribute("userEmail", userEmail);
        request.setAttribute("userAddress", userAddress);
        request.setAttribute("userPhone", userPhone);
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("totalPrice", totalPrice);
        request.setAttribute("orderDate", orderDate);
        request.setAttribute("orderStatus", orderStatus);

        // Save order to order_history.txt
        saveOrderToFile(request.getServletContext().getRealPath("/"), orderId, userName, userEmail, userAddress, cartItems, totalPrice, orderDate, orderStatus);

        // Forward to CheckoutPage.jsp
        request.getRequestDispatcher("/Checkout/CheckoutPage.jsp").forward(request, response);
    }

    private void saveOrderToFile(String contextPath, String orderId, String userName, String userEmail, String userAddress, List<CartItem> cartItems, double totalPrice, String orderDate, String orderStatus) {
        // Use a dedicated directory for order history
        String filePath = contextPath + "WEB-INF/orders/order_history.txt";
        try {
            File file = new File(filePath);
            file.getParentFile().mkdirs(); // Create directories if needed
            try (FileWriter writer = new FileWriter(file, true)) {
                // Format: orderId,userName,userEmail,userAddress,totalPrice,orderDate,orderStatus,items
                StringBuilder itemsString = new StringBuilder();
                for (CartItem item : cartItems) {
                    itemsString.append(item.name)
                            .append("|")
                            .append(item.store)
                            .append("|")
                            .append(item.quantity)
                            .append("|")
                            .append(item.price)
                            .append(";");
                }
                String orderLine = String.format("%s,%s,%s,%s,%.2f,%s,%s,%s\n",
                        orderId, userName, userEmail, userAddress, totalPrice, orderDate, orderStatus, itemsString.toString());
                writer.write(orderLine);
            }
        } catch (IOException e) {
            System.err.println("Error writing to order_history.txt: " + e.getMessage());
            e.printStackTrace();
        }
    }
}