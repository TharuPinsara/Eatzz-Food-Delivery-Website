<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Register</title>
  <link rel="stylesheet" href="Css/register.css">
  <link rel="icon" href="images/Logo.png">
  <style>
    /* CSS for logo positioning */
    .logo {
      position: absolute; /* Position relative to the body */
      top: 20px; /* Move slightly above the top */
      right: 30px; /* Move slightly to the right */
      text-shadow: 4px 4px 8px #000000;
      width: 200px; /* Adjust the width */
      height: auto; /* Maintain aspect ratio */
      z-index: 3; /* Ensure it appears above all background elements */
    }
    /* Success message styling */
    .success {
      color: #28a745; /* Green for success notification */
      font-weight: bold;
      margin-top: 10px;
      text-align: center;
    }
    .error {
      color: #dc3545; /* Red for error messages */
      font-weight: bold;
      margin-top: 10px;
      text-align: center;
    }
  </style>
  <script>
    // Redirect to index.jsp after 3 seconds if registration is successful
    function redirectToLogin() {
      setTimeout(function() {
        window.location.href = "index.jsp";
      }, 1500); //
    }
  </script>
</head>
<body onload="<%= request.getParameter("success") != null ? "redirectToLogin()" : "" %>">

<!-- Add the logo -->
<img src="images/Eatzz.png" alt="Eatzz Logo" class="logo">

<div class="register-container">
  <h2>Create a New Account</h2>

  <!-- Display success or error messages if present -->
  <%
    String error = request.getParameter("error");
    String success = request.getParameter("success");
    if (error != null) {
  %>
  <p class="error"><%= error %></p>
  <%
  } else if (success != null) {
  %>
  <p class="success"><%= success %>. Redirecting to login...</p>
  <%
    }
  %>

  <!-- Registration Form -->
  <form method="POST" action="register">
    <label for="username">Username:</label>
    <input type="text" id="username" name="username" placeholder="Enter username" required>

    <label for="password">Password:</label>
    <input type="password" id="password" name="password" placeholder="Enter password" required>

    <label for="email">Email:</label>
    <input type="email" id="email" name="email" placeholder="Enter a valid email address" required>

    <label for="phone">Phone Number:</label>
    <input type="text" id="phone" name="phone" placeholder="Enter a 10-digit phone number" required>

    <!-- Add address input field -->
    <label for="address">Address:</label>
    <input id="address" name="address" placeholder="Enter your address" required>

    <button type="submit">Register</button>
  </form>

  <!-- Link back to Login Page -->
  <p><center>Already have an account? <a href="index.jsp" class="login-link">Login here</a></center></p>
</div>
<!-- Footer -->
<footer style="position: fixed; bottom: 10px; width: 100%; text-align: center; background-color: transparent; color: white; font-size: 12px;">
  2025 Eatzz All Rights Reserved.
</footer>
</body>
</html>