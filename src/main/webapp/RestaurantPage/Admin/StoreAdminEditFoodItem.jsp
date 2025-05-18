<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.menu.foodapp.FoodItem, com.example.menu.foodapp.FoodItemFileUtil" %>
<%
  if (session.getAttribute("storeAdminUser") == null) {
    response.sendRedirect("/RestaurantPage/Admin/StoreAdminLogin.jsp");
    return;
  }
  String storeName = (String) session.getAttribute("storeName");
  String name = request.getParameter("name");
  FoodItem foodItem = null;
  if (name != null) {
    try {
      for (FoodItem item : FoodItemFileUtil.loadFoodItems(application)) {
        if (item.getName().equals(name) && item.getStoreName().equals(storeName)) {
          foodItem = item;
          break;
        }
      }
    } catch (Exception e) {}
  }
  if (foodItem == null) {
    response.sendRedirect("/RestaurantPage/Admin/StoreAdminEditFood.jsp");
    return;
  }
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
  <% if (request.getParameter("error") != null) { %>
  <div class="error"><%= request.getParameter("error").equals("duplicate") ? "Food name exists." : "Update failed." %></div>
  <% } else if (request.getParameter("success") != null) { %>
  <div class="success">Food updated!</div>
  <% } %>
  <form action="/StoreAdminEditFoodServlet" method="post">
    <input type="hidden" name="originalName" value="<%= foodItem.getName() %>">
    <div class="form-group">
      <label for="name">Name:</label>
      <input type="text" id="name" name="name" value="<%= foodItem.getName() %>" required>
    </div>
    <div class="form-group">
      <label for="price">Price (LKR):</label>
      <input type="number" id="price" name="price" step="0.01" min="0" value="<%= foodItem.getPrice() %>" required>
    </div>
    <div class="form-group">
      <label for="image_url">Image URL:</label>
      <input type="text" id="image_url" name="image_url" value="<%= foodItem.getImagePath() %>" required>
    </div>
    <button type="submit" class="submit-btn">Update</button>
  </form>
</div>
</body>
</html>