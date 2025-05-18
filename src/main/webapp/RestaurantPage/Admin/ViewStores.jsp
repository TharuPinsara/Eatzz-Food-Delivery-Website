<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.restaurant.Restaurant, com.example.restaurant.RestaurantUtil, java.util.List" %>
<% if (session.getAttribute("adminUser") == null) {
    response.sendRedirect("/AdminPage/AdminLogin.jsp");
    return;
} %>
<html>
<head>
    <title>Stores</title>
    <link rel="stylesheet" href="/RestaurantPage/Admin/common.css">
    <link rel="stylesheet" href="/RestaurantPage/Admin/dashboard.css">
</head>
<body>
<jsp:include page="/RestaurantPage/Admin/Sidebar.jsp" />
<div class="content">
    <h1>Stores</h1>
    <%
        try {
            List<Restaurant> restaurants = RestaurantUtil.loadRestaurants(application);
            if (restaurants.isEmpty()) {
    %>
    <p class="no-items">No stores found.</p>
    <%
    } else {
    %>
    <table>
        <tr><th>Name</th><th>Address</th><th>Phone</th><th>Action</th></tr>
        <% for (Restaurant r : restaurants) { %>
        <tr>
            <td><%= r.getName() %></td>
            <td><%= r.getAddress() %></td>
            <td><%= r.getPhoneNumber() %></td>
            <td><a href="/AdminPage/EditStore.jsp?name=<%= java.net.URLEncoder.encode(r.getName(), "UTF-8") %>" class="edit-btn">Edit</a></td>
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