<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - Eatzz Food Delivery</title>
    <!-- Link to external HeaderBar.css for consistent header styling -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Header/HeaderBar.css">
    <!-- Include additional CSS for the About page -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/HomePage/About/About.css">

    <style>
        /* Inline background photo styles for About.jsp */
        body {
            font-family: 'Montserrat', sans-serif;
            margin: 0;
            padding: 0;
            color: #4a4a4a;
            background-image: url('<%= request.getContextPath() %>/images/AdminBg.jpg'); /* Background image */
            background-size: cover; /* Make the image cover the entire page */
            background-position: center; /* Center the image */
            background-repeat: no-repeat; /* Avoid repeating the image */
            background-attachment: fixed; /* Make the background fixed during scrolling */
        }
    </style>
</head>
<body>
<!-- Header included from HeaderBar.jsp -->
<jsp:include page="/Header/HeaderBar.jsp" />

<div class="content">
    <div class="about-section">
        <img src="<%= request.getContextPath() %>/images/Logo.png" alt="Eatzz Logo">
        <h1>Welcome to Eatzz Food Delivery System!</h1>
        <p>
            At Eatzz, we’re committed to bringing your favorite meals straight to your doorstep.
            We partner with your favorite restaurants, offering a wide variety of cuisines to satisfy every craving.
            Our mission is to make food delivery simple, fast, and reliable for everyone.
        </p>
    </div>

    <div class="reviews">
        <h2>What Our Customers Say</h2>

        <!-- Review 1 -->
        <div class="review-card">
            <h3>John D.</h3>
            <p>"Eatzz completely changed how I order food. Everything is so quick, and there are tons of options!"</p>
            <div class="star-rating">★★★★★</div>
            <img src="<%= request.getContextPath() %>/images/User.png" alt="User Icon" class="user-icon">
        </div>

        <!-- Review 2 -->
        <div class="review-card">
            <h3>Sarah P.</h3>
            <p>"The delivery agents are always friendly, and I've never had any issues. Highly recommend!"</p>
            <div class="star-rating">★★★★☆</div>
            <img src="<%= request.getContextPath() %>/images/User.png" alt="User Icon" class="user-icon">
        </div>

        <!-- Review 3 -->
        <div class="review-card">
            <h3>Amanda R.</h3>
            <p>"Love this service! I can get food from my favorite restaurants even on lazy days. Five stars!"</p>
            <div class="star-rating">★★★★★</div>
            <img src="<%= request.getContextPath() %>/images/User.png" alt="User Icon" class="user-icon">
        </div>
    </div>
</div>

<footer>
    <p>&copy; 2025 Eatzz Food Delivery | <a href="<%= request.getContextPath() %>/HomePage/">Home</a> |
        <a href="<%= request.getContextPath() %>/ContactUs.jsp">Contact Us</a></p>
</footer>
</body>
</html>