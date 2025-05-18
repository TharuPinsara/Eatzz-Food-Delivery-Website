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
  <!-- Link to the CSS file for consistent styling -->
  <link href="<%= request.getContextPath() %>/AdminPage/EditUser.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
</head>
<body>
<div class="dashboard">
  <!-- Sidebar -->
  <aside class="sidebar">
    <div class="sidebar-logo">
      <img src="<%= request.getContextPath() %>/AdminPage/Eatzz.png" alt="Brand Logo" class="logo-image" />
    </div>
    <nav>
      <ul>
        <li><a href="<%= request.getContextPath() %>/AdminPage/AdminDashboard.jsp">🏠 Home</a></li>
        <li><a href="<%= request.getContextPath() %>/AdminPage/AddUser.jsp">👤 Add User</a></li>
        <li><a href="#" class="active">✏️ Edit User</a></li>
        <li><a href="#">📊 Charts</a></li>
        <li><a href="#">⚙️ Settings</a></li>
      </ul>
    </nav>
  </aside>

  <!-- Main Content -->
  <main class="main-content">
    <div class="form-container">
      <h2>Edit User</h2>
      <form action="<%= request.getContextPath() %>/EditUserServlet" method="post">
        <!-- Allow username to be editable as well -->
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" value="<%= request.getAttribute("username") %>" required>

        <label for="password">Password:</label>
        <input type="password" id="password" name="password" value="<%= request.getAttribute("password") %>" required>

        <label for="email">Email:</label>
        <input type="email" id="email" name="email" value="<%= request.getAttribute("email") %>" required>

        <label for="phone">Phone:</label>
        <input type="text" id="phone" name="phone" value="<%= request.getAttribute("phone") %>" required>

        <button type="submit">Save Changes</button>
      </form>
    </div>
  </main>
</div>
</body>
</html>