<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.restaurant.Restaurant" %>
<%
    if (session.getAttribute("adminUser") == null) {
        response.sendRedirect("/AdminPage/admin_login.jsp");
        return;
    }
    Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
    if (restaurant == null) {
        response.sendRedirect("/AdminPage/AdminDashboard.jsp?error=notFound");
        return;
    }
%>
<html>
<head>
    <title>Edit Restaurant</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/AdminPage/AdminCss/StyleDashboard.css">
    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #e4e7eb 100%);
            font-family: 'Montserrat', sans-serif;
            margin: 0;
            display: flex;
            min-height: 100vh;
        }
        .content {
            margin-left: 260px;
            padding: 30px;
            width: 100%;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
            margin-right: 30px;
            margin-top: 30px;
        }
        h1 {
            font-size: 28px;
            color: #2d2d2d;
            font-weight: 600;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 20px;
            max-width: 500px;
        }
        .form-group label {
            display: block;
            font-weight: 500;
            margin-bottom: 8px;
            color: #424242;
        }
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #bdbdbd;
            border-radius: 6px;
            font-size: 14px;
            background: #fff;
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        .form-group input:focus {
            border-color: #e53935;
            box-shadow: 0 0 5px rgba(229, 57, 53, 0.3);
            outline: none;
        }
        .submit-btn {
            background-color: #e53935;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: background-color 0.3s, transform 0.2s;
        }
        .submit-btn:hover {
            background-color: #ff6f61;
            transform: translateY(-2px);
        }
        .error {
            color: #d32f2f;
            background: #ffebee;
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .success {
            color: #2e7d32;
            background: #e8f5e9;
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 14px;
        }
    </style>
</head>
<body>
<jsp:include page="/AdminPage/AdminSideBar.jsp"/>
<div class="content">
    <h1>Edit Restaurant</h1>
    <% if (request.getParameter("error") != null) { %>
    <div class="error">
        <%= request.getParameter("error").equals("duplicate") ? "Restaurant name already exists." :
                request.getParameter("error").equals("invalid") ? "Please fill all fields correctly." : "Failed to update restaurant." %>
    </div>
    <% } else if (request.getParameter("success") != null) { %>
    <div class="success">Restaurant updated successfully!</div>
    <% } %>
    <form action="<%= request.getContextPath() %>/EditRestaurantServlet" method="post">
        <input type="hidden" name="originalName" value="<%= restaurant.getName() %>">
        <div class="form-group">
            <label for="name">Restaurant Name:</label>
            <input type="text" id="name" name="name" value="<%= restaurant.getName() %>" required>
        </div>
        <div class="form-group">
            <label for="address">Address:</label>
            <input type="text" id="address" name="address" value="<%= restaurant.getAddress() %>" required>
        </div>
        <div class="form-group">
            <label for="phoneNumber">Phone Number:</label>
            <input type="text" id="phoneNumber" name="phoneNumber" value="<%= restaurant.getPhoneNumber() %>" required>
        </div>
        <button type="submit" class="submit-btn">Update Restaurant</button>
    </form>
</div>
</body>
</html>