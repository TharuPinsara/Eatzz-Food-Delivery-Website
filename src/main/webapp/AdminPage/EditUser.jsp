<%@ page import="java.io.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  // Check if an admin is logged in
  if (session.getAttribute("adminUser") == null) {
    response.sendRedirect(request.getContextPath() + "/AdminPage/admin_login.jsp");
    return;
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Edit User</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/AdminPage/AdminCss/StyleDashboard.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/AdminPage/AdminCss/EditUser.css">
  <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
</head>
<body>
<div class="dashboard">
  <jsp:include page="/AdminPage/AdminSideBar.jsp" />

  <main class="main-content">
    <div class="form-container">
      <h2>Edit User</h2>
      <form action="<%= request.getContextPath() %>/EditUserServlet" method="post">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>" required>

        <label for="password">Password:</label>
        <input type="password" id="password" name="password" value="<%= request.getAttribute("password") != null ? request.getAttribute("password") : "" %>" required>

        <label for="email">Email:</label>
        <input type="email" id="email" name="email" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" required>

        <label for="phone">Phone:</label>
        <input type="text" id="phone" name="phone" value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>" required>

        <label for="address">Address:</label>
        <input type="text" id="address" name="address" value="<%= request.getAttribute("address") != null ? request.getAttribute("address") : "" %>" required>

        <button type="submit">Save Changes</button>
      </form>
    </div>
  </main>
</div>
</body>
</html>