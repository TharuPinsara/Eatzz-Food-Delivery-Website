<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="jakarta.servlet.*" %>
<%
    // Retrieve the user's username from the session
    HttpSession session = request.getSession(false); // Get session if it exists
    String username = (String) session.getAttribute("username");

    // Redirect to login page if session is invalid or user is not logged in
    if (username == null) {
        response.sendRedirect("../index.jsp");
        return; // Exit the JSP to prevent further execution
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Profile</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Css/profile.css"> <!-- Link to CSS -->
</head>
<body>
<%@ include file="/Header/HeaderBar.jsp" %> <!-- Include navigation/header bar -->
<div class="profile-container">
    <h1>Welcome, <%= username %>!</h1>
    <div class="profile-actions">
        <a href="<%= request.getContextPath() %>/UserProfile/editProfile.jsp" class="button">Edit Profile</a>
        <a href="<%= request.getContextPath() %>/logout" class="button logout-button">Logout</a>
    </div>
</div>
</body>
</html>