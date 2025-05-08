<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Login</title>
    <link rel="stylesheet" href="/AdminPage/StyleAdmin.css">
</head>
<body>
<div class="login-box">
    <h2>Admin Login</h2>
    <form action="<%= request.getContextPath() %>/AdminLoginServlet" method="post">
        <input type="text" name="username" placeholder="Username" required><br>
        <input type="password" name="password" placeholder="Password" required><br>
        <input type="submit" value="Login">
    </form>
    <% if ("true".equals(request.getParameter("error"))) { %>
    <p style="color:red;">Invalid credentials!</p>
    <% } %>
</div>
</body>
</html>