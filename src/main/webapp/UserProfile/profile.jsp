<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*,java.util.*" %>
<%@ include file="/Header/HeaderBar.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Profile</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/UserProfile/profile.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body>
<div class="profile-container">
    <!-- Left Section: User Details -->
    <div class="profile-info-container">
        <h2><i class="fa fa-user"></i> User Profile</h2>
        <%
            String loggedUser = (String) session.getAttribute("username");
            if (loggedUser == null) {
                response.sendRedirect("/index.jsp");
                return;
            }

            String filePath = application.getRealPath("/") + "WEB-INF/users.txt";
            File file = new File(filePath);
            String userDetail = null;

            try {
                if (file.exists()) {
                    BufferedReader reader = new BufferedReader(new FileReader(file));
                    String line;
                    while ((line = reader.readLine()) != null) {
                        String[] userDetails = line.split(",");
                        if (userDetails[0].equals(loggedUser)) {
                            userDetail = line;
                            break;
                        }
                    }
                    reader.close();
                }
            } catch (IOException e) {
                out.println("<p class='error'><i class='fa fa-exclamation-circle'></i> Error loading user details: " + e.getMessage() + "</p>");
            }

            if (userDetail != null) {
                String[] userInfo = userDetail.split(",");
                String username = userInfo[0];
                String email = userInfo[2];
                String phone = userInfo[3];
                String address = userInfo[4];
        %>
        <div class="profile-info">
            <p><i class="fa fa-user"></i> <strong>Username:</strong> <%= username %></p>
            <p><i class="fa fa-lock"></i> <strong>Password:</strong> •••••••</p>
            <p><i class="fa fa-envelope"></i> <strong>Email:</strong> <%= email %></p>
            <p><i class="fa fa-phone"></i> <strong>Phone:</strong> <%= phone %></p>
            <p><i class="fa fa-map-marker-alt"></i> <strong>Address:</strong> <%= address %></p>
        </div>
        <%
        } else {
        %>
        <p class="error"><i class="fa fa-exclamation-circle"></i> User details could not be found!</p>
        <%
            }
        %>
    </div>

    <!-- Right Section: Profile Card -->
    <div class="profile-card">
        <img src="<%= request.getContextPath() %>/images/User.png" alt="Avatar">
        <h3><%= loggedUser != null ? loggedUser : "User" %></h3>
        <p class="title">Customer</p>
        <div class="star-rating">
            <i class="fa fa-star"></i>
            <i class="fa fa-star"></i>
            <i class="fa fa-star"></i>
            <i class="fa fa-star"></i>
            <i class="fa fa-star"></i>
        </div>
        <div class="action-buttons">
            <form action="editUser.jsp" method="post">
                <button type="submit" class="edit-button"><i class="fa fa-edit"></i> Edit User Details</button>
            </form>
            <form action="<%= request.getContextPath() %>/UserProfile/ViewUserOrders.jsp" method="get">
                <button type="submit" class="view-orders-button"><i class="fa fa-shopping-cart"></i> View Orders</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>