<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*,java.util.*" %>
<%@ include file="/Header/HeaderBar.jsp" %>
<%
    // Check if "username" attribute exists in the session; if not, redirect to the login page
    String loggedUser = (String) session.getAttribute("username");
    if (loggedUser == null) {
        response.sendRedirect("/index.jsp");
        return;
    }

    // Load delivery details into a map for quick lookup
    Map<String, String> deliveryStatusMap = new HashMap<>();
    String deliveryFilePath = application.getRealPath("/") + "WEB-INF/delivery_details.txt";
    File deliveryFile = new File(deliveryFilePath);
    if (deliveryFile.exists() && deliveryFile.canRead()) {
        try (BufferedReader reader = new BufferedReader(new FileReader(deliveryFile))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] details = line.split(",");
                if (details.length >= 3) {
                    deliveryStatusMap.put(details[0], details[2]);
                }
            }
        } catch (IOException e) {
            // Log error (in production, use a proper logging framework)
            System.err.println("Error reading delivery_details.txt: " + e.getMessage());
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/UserProfile/StyleViewOrders2.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body>
<div class="orders-container">
    <h2>My Orders</h2>
    <table id="orderTable" class="order-table">
        <thead>
        <tr>
            <th><i class="fa fa-hashtag"></i> Order ID</th>
            <th><i class="fa fa-money-bill"></i> Total Price (LKR)</th>
            <th><i class="fa fa-calendar"></i> Date</th>
            <th><i class="fa fa-info-circle"></i> Status</th>
            <th><i class="fa fa-box"></i> Delivery Status</th>
            <th><i class="fa fa-shopping-cart"></i> Items</th>
            <th><i class="fa fa-cog"></i> Actions</th>
        </tr>
        </thead>
        <tbody>
        <%
            String orderFilePath = application.getRealPath("/") + "WEB-INF/orders/order_history.txt";
            File orderFile = new File(orderFilePath);
            boolean hasData = false;

            if (orderFile.exists()) {
                if (orderFile.canRead()) {
                    try (BufferedReader br = new BufferedReader(new FileReader(orderFile))) {
                        String line;
                        while ((line = br.readLine()) != null) {
                            String[] orderDetails = line.split(",", -1);
                            if (orderDetails.length >= 8 && orderDetails[1].equals(loggedUser)) {
                                hasData = true;
                                String items = orderDetails[7];
                                String formattedItems = "";
                                if (!items.isEmpty()) {
                                    String[] itemList = items.split(";");
                                    for (String item : itemList) {
                                        String[] itemDetails = item.split("\\|", -1);
                                        if (itemDetails.length >= 4) {
                                            formattedItems += itemDetails[0] + " (" + itemDetails[1] + ", Qty: " + itemDetails[2] + ", Price: " + itemDetails[3] + ")<br>";
                                        }
                                    }
                                } else {
                                    formattedItems = "No items";
                                }
                                String deliveryStatus = deliveryStatusMap.getOrDefault(orderDetails[0], "Processing");
        %>
        <tr>
            <td><%= orderDetails[0] %></td>
            <td><%= orderDetails[4] %></td>
            <td><%= orderDetails[5] %></td>
            <td><%= orderDetails[6] %></td>
            <td><%= deliveryStatus %></td>
            <td><%= formattedItems %></td>
            <td>
                <div class="action-form">
                    <form method="GET" action="<%= request.getContextPath() %>/UserViewOrder">
                        <input type="hidden" name="orderId" value="<%= orderDetails[0] %>">
                        <button type="submit" class="view-btn"><i class="fa fa-eye"></i> View Details</button>
                    </form>
                </div>
            </td>
        </tr>
        <%
                }
            }
            if (!hasData) {
        %>
        <tr>
            <td colspan="7"><i class="fa fa-exclamation-circle"></i> No orders found for this user</td>
        </tr>
        <%
            }
        } catch (IOException e) {
        %>
        <tr>
            <td colspan="7"><i class="fa fa-exclamation-circle"></i> Error reading orders file: <%= e.getMessage() %></td>
        </tr>
        <%
            }
        } else {
        %>
        <tr>
            <td colspan="7"><i class="fa fa-exclamation-circle"></i> No permission to read orders file</td>
        </tr>
        <%
            }
        } else {
        %>
        <tr>
            <td colspan="7"><i class="fa fa-exclamation-circle"></i> Order file not found at: <%= orderFilePath %></td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>
    <a href="<%= request.getContextPath() %>/UserProfile/profile.jsp" class="back-btn"><i class="fa fa-arrow-left"></i> Back to Profile</a>
</div>
</body>
</html>