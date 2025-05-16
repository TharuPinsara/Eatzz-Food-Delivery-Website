<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.*, java.util.*" %>
<% if (session.getAttribute("storeAdminUser") == null) {
    response.sendRedirect("/RestaurantPage/Admin/StoreAdminLogin.jsp");
    return;
} %>
<html>
<head>
    <title>Store Orders</title>
    <link rel="stylesheet" href="/RestaurantPage/Admin/common.css">
    <link rel="stylesheet" href="/RestaurantPage/Admin/admin-pages.css">
    <style>
        .orders-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .orders-table th, .orders-table td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        .orders-table th {
        { background-color: #da0000; color: white; }

        .orders-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .error {
            color: red;
        }
    </style>
</head>
<body>
<jsp:include page="/RestaurantPage/Admin/StoreAdminSidebar.jsp" />
<div class="content">
    <h1>Store Orders</h1>
    <p class="welcome">Viewing orders for store: <%= session.getAttribute("storeName") %></p>
    <%
        String storeName = (String) session.getAttribute("storeName");
        String orderFilePath = application.getRealPath("/") + "WEB-INF/orders/order_history.txt";
        File orderFile = new File(orderFilePath);
        List<String[]> storeOrders = new ArrayList<>();

        try {
            if (orderFile.exists() && orderFile.canRead()) {
                try (BufferedReader br = new BufferedReader(new FileReader(orderFile))) {
                    String line;
                    while ((line = br.readLine()) != null) {
                        String[] orderDetails = line.split(",", -1);
                        if (orderDetails.length == 8) {
                            String items = orderDetails[7];
                            String[] itemList = items.split(";");
                            for (String item : itemList) {
                                String[] itemDetails = item.split("\\|", -1);
                                if (itemDetails.length >= 2 && itemDetails[1].equals(storeName)) {
                                    storeOrders.add(orderDetails);
                                    break;
                                }
                            }
                        }
                    }
                }
            } else {
    %>
    <p class="error">Order file not found or cannot be read at: <%= orderFilePath %></p>
    <%
        }
    } catch (IOException e) {
    %>
    <p class="error">Error reading orders: <%= e.getMessage() %></p>
    <%
        }
    %>
    <% if (storeOrders.isEmpty()) { %>
    <p>No orders found for this store.</p>
    <% } else { %>
    <table class="orders-table">
        <thead>
        <tr>
            <th>Order ID</th>
            <th>Username</th>
            <th>Email</th>
            <th>Address</th>
            <th>Total Price (LKR)</th>
            <th>Date</th>
            <th>Status</th>
            <th>Items</th>
        </tr>
        </thead>
        <tbody>
        <% for (String[] order : storeOrders) { %>
        <tr>
            <td><%= order[0] %></td>
            <td><%= order[1] %></td>
            <td><%= order[2] %></td>
            <td><%= order[3] %></td>
            <td><%= order[4] %></td>
            <td><%= order[5] %></td>
            <td><%= order[6] %></td>
            <td>
                <%
                    String[] items = order[7].split(";");
                    for (String item : items) {
                        String[] itemDetails = item.split("\\|", -1);
                        if (itemDetails.length >= 4 && itemDetails[1].equals(storeName)) {
                            out.println(itemDetails[0] + " (Qty: " + itemDetails[2] + ", Price: " + itemDetails[3] + ")<br>");
                        }
                    }
                %>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } %>
</div>
</body>
</html>
