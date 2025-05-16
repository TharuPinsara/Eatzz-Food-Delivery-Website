<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.restaurant.Restaurant, com.example.restaurant.RestaurantUtil" %>
<%
  if (session.getAttribute("adminUser") == null) {
    response.sendRedirect("/AdminPage/AdminLogin.jsp");
    return;
  }
  String name = request.getParameter("name");
  Restaurant restaurant = null;
  if (name != null) {
    try {
      for (Restaurant r : RestaurantUtil.loadRestaurants(application)) {
        if (r.getName().equals(name)) {
          restaurant = r;
          break;
        }
      }
    } catch (Exception e) {}
  }
  if (restaurant == null) {
    response.sendRedirect("/AdminPage/ViewStores.jsp");
    return;
  }
%>
<html>
<head>
  <title>Edit Store</title>
  <link rel="stylesheet" href="/RestaurantPage/Admin/common.css">
  <link rel="stylesheet" href="/RestaurantPage/Admin/dashboard.css">
</head>
<body>
<jsp:include page="/RestaurantPage/Admin/Sidebar.jsp" />
<div class="content">
  <h1>Edit Store</h1>
  <% if (request.getParameter("error") != null) { %>
  <div class="error"><%= request.getParameter("error").equals("duplicate") ? "Store name exists." : "Update failed." %></div>
  <% } else if (request.getParameter("success") != null) { %>
  <div class="success">Store updated!</div>
  <% } %>
  <form action="/EditStoreServlet" method="post">
    <input type="hidden" name="originalName" value="<%= restaurant.getName() %>">
    <div class="form-group">
      <label for="name">Name:</label>
      <input type="text" id="name" name="name" value="<%= restaurant.getName() %>" required>
    </div>
    <div class="form-group">
      <label for="address">Address:</label>
      <input type="text" id="address" name="address" value="<%= restaurant.getAddress() %>" required>
    </div>
    <div class="form-group">
      <label for="phoneNumber">Phone:</label>
      <input type="text" id="phoneNumber" name="phoneNumber" value="<%= restaurant.getPhoneNumber() %>" required>
    </div>
    <button type="submit" class="submit-btn">Update</button>
  </form>
</div>
</body>
</html>