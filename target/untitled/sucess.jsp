<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Successful</title>
    <!-- Link to Success Page CSS -->
    <link rel="stylesheet" href="Css/sucess.css">
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
    <script>
        // Automatically redirect to index.html after 3 seconds
        setTimeout(function () {
            window.location.href = "cart.jsp"; // Replace with the correct home/mainsite URL if needed
        }, 1500); // 3000ms = 3 seconds delay
    </script>
</head>
<body>
<!-- Add the logo -->
<img src="images/Eatzz.png" alt="Eatzz Logo" class="logo">

<!-- Login Container -->
<div class="login-container">
    <h2>Login Successful!</h2>
    <p>Welcome, you've successfully logged in.</p>
    <p>Redirecting to Home Page...</p>
</div>

<!-- Footer -->
<footer style="position: fixed; bottom: 10px; width: 100%; text-align: center; background-color: transparent; color: white; font-size: 12px;">
    2025 Eatzz All Rights Reserved.
</footer>
</body>
</html>