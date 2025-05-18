<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.menu.foodapp.FoodItem, com.example.menu.foodapp.FoodItemFileUtil, java.util.List" %>
<%
    if (session.getAttribute("storeAdminUser") == null) {
        response.sendRedirect("/RestaurantPage/Admin/StoreAdminLogin.jsp");
        return;
    }
    String storeName = (String) session.getAttribute("storeName");
%>
<html>
<head>
    <title>Edit Food</title>
    <link rel="stylesheet" href="/RestaurantPage/Admin/common.css">
    <link rel="stylesheet" href="/RestaurantPage/Admin/admin-pages.css">
</head>
<body>
<jsp:include page="/RestaurantPage/Admin/StoreAdminSidebar.jsp" />
<div class="content">
    <h1>Edit Food</h1>
    <%
        try {
            List<FoodItem> foodItems = FoodItemFileUtil.loadFoodItems(application);
            List<FoodItem> storeItems = new java.util.ArrayList<>();
            for (FoodItem item : foodItems) {
                if (item.getStoreName().equals(storeName)) {
                    storeItems.add(item);
                }
            }
            if (storeItems.isEmpty()) {
    %>
    <p class="no-items">No food items found.</p>
    <%
    } else {
    %>
    <table>
        <tr><th>Name</th><th>Price</th><th>Image</th><th>Action</th></tr>
        <% for (FoodItem item : storeItems) { %>
        <tr>
            <td><%= item.getName() %></td>
            <td><%= String.format("%.2f", item.getPrice()) %></td>
            <td><%= item.getImagePath() %></td>
            <td><a href="/RestaurantPage/Admin/StoreAdminEditFoodItem.jsp?name=<%= java.net.URLEncoder.encode(item.getName(), "UTF-8") %>" class="edit-btn">Edit</a></td>
        </tr>
        <% } %>
    </table>
    <%
        }
    } catch (Exception e) {
    %>
    <p class="no-items">Error: <%= e.getMessage() %></p>
    <% } %>
</div>
</body>
</html>