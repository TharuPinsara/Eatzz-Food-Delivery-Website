<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.*, java.util.ArrayList, java.util.List" %>
<% if (session.getAttribute("storeAdminUser") == null) {
    response.sendRedirect("/RestaurantPage/Admin/StoreAdminLogin.jsp");
    return;
} %>
<html>
<head>
    <title>Store Payment</title>
    <link rel="stylesheet" href="/RestaurantPage/Admin/common.css">
    <link rel="stylesheet" href="/RestaurantPage/Admin/admin-pages.css">
    <style>
        .content { padding: 20px; }
        .payment-table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        .payment-table th, .payment-table td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        .payment-table th { background-color: #da0000; color: white; } /* Changed to orange with white text for contrast */
        .payment-table td { background-color: #fff; } /* Ensure table data cells remain white for contrast */
        .total-cash { font-weight: bold; margin-top: 10px; }
        .error { color: red; }
    </style>
</head>
<body>
<jsp:include page="/RestaurantPage/Admin/StoreAdminSidebar.jsp" />
<div class="content">
    <h1>Store Payment</h1>
    <p class="welcome">Welcome, <%= session.getAttribute("storeAdminUser") %>!</p>

    <h3>Payment Logs</h3>
    <%
        String paymentFilePath = application.getRealPath("/") + "WEB-INF/payment_history.txt";
        File paymentFile = new File(paymentFilePath);
        String storeName = (String) session.getAttribute("storeName");
        double totalCash = 0.0;
        List<String[]> paymentRecords = new ArrayList<>();

        if (paymentFile.exists() && paymentFile.canRead()) {
            try (BufferedReader br = new BufferedReader(new FileReader(paymentFile))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] details = line.split(",");
                    if (details.length >= 6) { // Expecting orderId,storeName,totalPrice,commission,storePayment,date,status
                        String recordStoreName = details[1]; // Second field is storeName
                        String status = details.length > 6 ? details[6] : "Pending"; // Status is last field
                        String storePaymentStr = details[4]; // Store payment is fifth field
                        if (storeName != null && storeName.equals(recordStoreName)) {
                            try {
                                double storePayment = Double.parseDouble(storePaymentStr);
                                if ("Processed".equals(status)) {
                                    totalCash += storePayment;
                                }
                                paymentRecords.add(details);
                            } catch (NumberFormatException e) {
                                out.println("<p class='error'>Error parsing store payment for record: " + line + "</p>");
                            }
                        }
                    }
                }
            } catch (IOException e) {
                out.println("<p class='error'>Error reading payment file: " + e.getMessage() + "</p>");
            }
        } else {
            out.println("<p class='error'>Payment file not accessible at: " + paymentFilePath + "</p>");
        }
    %>

    <% if (paymentRecords.isEmpty()) { %>
    <p>No payment records found for this store.</p>
    <% } else { %>
    <table class="payment-table">
        <thead>
        <tr>
            <th>Order ID</th>
            <th>Total Price (LKR)</th>
            <th>Website Commission (LKR)</th>
            <th>Store Payment (LKR)</th>
            <th>Date</th>
            <th>Status</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (String[] details : paymentRecords) {
                String status = details.length > 6 ? details[6] : "Pending"; // Status is last field
        %>
        <tr>
            <td><%= details[0] %></td>
            <td><%= details[2] %></td> <!-- Total Price is third field -->
            <td><%= details[3] %></td> <!-- Commission is fourth field -->
            <td><%= details[4] %></td> <!-- Store Payment is fifth field -->
            <td><%= details[5] %></td> <!-- Date is sixth field -->
            <td><%= status %></td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <p class="total-cash">Total Cash for Processed Payments (LKR): <%= String.format("%.2f", totalCash) %></p>
    <% } %>
</div>
</body>
</html>