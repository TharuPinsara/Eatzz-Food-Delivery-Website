<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Store Manager Login</title>
  <link rel="stylesheet" href="/RestaurantPage/Admin/common.css">
  <link rel="stylesheet" href="/RestaurantPage/Admin/auth.css">
</head>
<body>
<div class="auth-container">
  <h1>Store Manager Login</h1>
  <% if (request.getParameter("error") != null) { %>
  <div class="error">Invalid username or password.</div>
  <% } %>
  <form action="/StoreAdminLoginServlet" method="post">
    <div class="form-group">
      <label for="username">Username:</label>
      <input type="text" id="username" name="username" required>
    </div>
    <div class="form-group">
      <label for="password">Password:</label>
      <input type="password" id="password" name="password" required>
    </div>
    <button type="submit" class="submit-btn">Login</button>
  </form>
  <a href="/RestaurantPage/Admin/StoreAdminRegister.jsp" class="auth-link">Register</a>
</div>
</body>
</html>