<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% if (session.getAttribute("storeAdminUser") == null) {
    response.sendRedirect("/RestaurantPage/Admin/StoreAdminLogin.jsp");
    return;
} %>
<html>
<head>
    <title>Add Food</title>
    <link rel="stylesheet" href="/RestaurantPage/Admin/common.css">
    <link rel="stylesheet" href="/RestaurantPage/Admin/admin-pages.css">
</head>
<body>
<jsp:include page="/RestaurantPage/Admin/StoreAdminSidebar.jsp" />
<div class="content">
    <h1>Add Food</h1>
    <% if (request.getParameter("error") != null) { %>
    <div class="error">
        <%= request.getParameter("error").equals("missingFields") ? "Fill all fields." :
                request.getParameter("error").equals("invalidPrice") ? "Invalid price." :
                        request.getParameter("error").equals("duplicateName") ? "Food name exists." : "Error." %>
    </div>
    <% } else if (request.getParameter("success") != null) { %>
    <div class="success">Food added!</div>
    <% } %>
    <form action="/StoreAdminAddFoodServlet" method="post">
        <div class="form-group">
            <label for="name">Name:</label>
            <input type="text" id="name" name="name" required>
        </div>
        <div class="form-group">
            <label for="price">Price (LKR):</label>
            <input type="number" id="price" name="price" step="0.01" min="0" required>
        </div>
        <div class="form-group">
            <label for="image_url">Image URL:</label>
            <input type="text" id="image_url" name="image_url" required>
        </div>
        <button type="submit" class="submit-btn">Add</button>
    </form>
</div>
</body>
</html>