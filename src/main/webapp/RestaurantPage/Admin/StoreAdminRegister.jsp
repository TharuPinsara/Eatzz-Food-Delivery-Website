<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Store Manager Register</title>
    <link rel="stylesheet" href="/RestaurantPage/Admin/common.css">
    <link rel="stylesheet" href="/RestaurantPage/Admin/auth.css">
</head>
<body>
<div class="auth-container">
    <h1>Store Manager Register</h1>
    <% if (request.getParameter("error") != null) { %>
    <div class="error"><%= request.getParameter("error").equals("duplicate") ? "Username exists." : "Registration failed." %></div>
    <% } else if (request.getParameter("success") != null) { %>
    <div class="success">Registered! Please login.</div>
    <% } %>
    <form action="/StoreAdminRegisterServlet" method="post">
        <div class="form-group">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required>
        </div>
        <div class="form-group">
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
        </div>
        <div class="form-group">
            <label for="storeName">Store Name:</label>
            <input type="text" id="storeName" name="storeName" required>
        </div>
        <div class="form-group">
            <label for="address">Address:</label>
            <input type="text" id="address" name="address" required>
        </div>
        <div class="form-group">
            <label for="phoneNumber">Phone Number:</label>
            <input type="text" id="phoneNumber" name="phoneNumber" required>
        </div>
        <button type="submit" class="submit-btn">Register</button>
    </form>
    <a href="/RestaurantPage/Admin/StoreAdminLogin.jsp" class="auth-link">Login</a>
</div>
</body>
</html>