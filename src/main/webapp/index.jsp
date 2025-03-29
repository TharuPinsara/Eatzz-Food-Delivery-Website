<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <!-- Link to the external CSS file -->
    <link rel="stylesheet" href="Css/style.css">
    <!-- Suppress the favicon -->
    <link rel="icon" href="images/Logo.png">
    <style>
        /* Added CSS for logo positioning */
        .logo {
            position: absolute; /* Position relative to the body */
            top: 20px; /* Move slightly above the top */
            right: 30px; /* Move slightly to the right */
            text-shadow: 4px 4px 8px #000000;
            width: 200px; /* Adjust the width */
            height: auto; /* Maintain aspect ratio */
            z-index: 3; /* Ensure it appears above all background elements */
        }
    </style>
</head>
<body>
<!-- Add the logo -->
<img src="images/Eatzz.png" alt="Eatzz Logo" class="logo">

<div class="login-container">
    <div class="loggo-container">
        <img src="images/Logo.png" alt="Logo" class="logo2"></div>
        <!-- Welcome Back message -->
    <div class="welcome-back">Hello Again! . . </div>

    <!-- Login Form Section -->
    <div class="login-form-container">
        <h2>Welcome Back. You've been missed.</h2>

        <!-- Show error if the servlet redirects with an error query parameter -->
        <%
            String error = request.getParameter("error");
            if (error != null) {
        %>
        <p class="error"><%= error %></p>
        <%
            }
        %>

        <!-- Form submission handled by LoginServlet -->
        <form method="POST" action="login">
            <label for="username"></label>
            <input type="text" id="username" name="username" placeholder="Enter username" required>

            <label for="password"></label>
            <input type="password" id="password" name="password" placeholder="Enter password" required style="margin-bottom: 60px;">

            <button type="submit">Login</button>
        </form>
        <p>Don't have an account? <a href="register.jsp" class="register-link">Register here</a></p>
    </div>
</div>
<footer style="position: fixed; bottom:10px; width: 100%; text-align: center; background-color: transparent; color: white; font-size: 12px;">
    2025 Eatzz All Rights Reserved.
</footer>
</body>
</html>