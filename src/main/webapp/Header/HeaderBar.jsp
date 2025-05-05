<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="jakarta.servlet.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Header</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>src/main/webapp/Header/HeaderBar.css"> <!-- Update with your CSS file -->
</head>
<body>
<header class="header">
  <div class="logo">
    <a href="<%= request.getContextPath() %>/index.jsp">
      <img src="<%= request.getContextPath() %>/images/logo.png" alt="Logo">
    </a>
  </div>

  <nav>
    <ul class="nav-links">
      <!-- Navigation links -->
      <li><a href="<%= request.getContextPath() %>/index.jsp">Home</a></li>
      <li><a href="<%= request.getContextPath() %>/menu.jsp">Menu</a></li>
      <li><a href="<%= request.getContextPath() %>/cart.jsp">Cart</a></li>

      <%
        // Retrieve the username from session
        HttpSession session = request.getSession(false);
        String username = (String) session.getAttribute("username");
        if (username != null) {
      %>
      <!-- Profile Dropdown -->
      <li class="profile-menu">
        <a href="javascript:void(0)" class="profile-link">
          <%= username %> &#x25BC; <!-- Display username with dropdown arrow -->
        </a>
        <ul class="dropdown-menu">
          <li><a href="<%= request.getContextPath() %>/editProfile.jsp">Edit Profile</a></li>
          <li><a href="<%= request.getContextPath() %>/logout">Logout</a></li>
        </ul>
      </li>
      <% } else { %>
      <!-- Login and Register links if user is not logged in -->
      <li><a href="<%= request.getContextPath() %>/register.jsp">Register</a></li>
      <li><a href="<%= request.getContextPath() %>/index.jsp">Login</a></li>
      <% } %>
    </ul>
  </nav>
</header>
</body>
</html>