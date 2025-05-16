<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.menu.foodapp.FoodItem, com.example.menu.foodapp.FoodItemFileUtil, java.util.List" %>
<% if (session.getAttribute("storeAdminUser") == null) {
    response.sendRedirect("/RestaurantPage/Admin/StoreAdminLogin.jsp");
    return;
} %>
<html>
<head>
    <title>Store Dashboard</title>
    <link rel="stylesheet" href="/RestaurantPage/Admin/common.css">
    <link rel="stylesheet" href="/RestaurantPage/Admin/admin-pages.css">
</head>
<body>
<jsp:include page="/RestaurantPage/Admin/StoreAdminSidebar.jsp" />
<div class="content">
    <h1>Store Dashboard</h1>
    <p class="welcome">Welcome, <%= session.getAttribute("storeAdminUser") %>!</p>
    <div class="overview">
        <h3>Overview</h3>
        <%
            try {
                String storeName = (String) session.getAttribute("storeName");
                List<FoodItem> foodItems = FoodItemFileUtil.loadFoodItems(application);
                long totalFoodItems = foodItems.stream()
                        .filter(item -> item.getStoreName().equals(storeName))
                        .count();
        %>
        <p>Total Food Items: <%= totalFoodItems %></p>
        <%
        } catch (Exception e) {
        %>
        <p class="error">Error loading food items: <%= e.getMessage() %></p>
        <%
            }
        %>
    </div>
</div>
</body>
</html>