<%@ page import="java.io.*, java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/Header/HeaderBar.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Profile</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/UserProfile/profileUser.css">
    <!-- Internal CSS Styling -->
</head>
<body>
<div class="profile-container">
    <!-- Left Section: User Details -->
    <div class="profile-info-container">
        <h2>User Profile</h2>
        <%
            // Retrieve the logged-in username from the session
            String loggedUser = (String) session.getAttribute("username");

            String username = null;
            if (loggedUser == null) {
                // Redirect to the login page if no user is logged in
                response.sendRedirect("/index.jsp");
            } else {
                // Path to the users.txt file
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
                } catch (Exception e) {
                    out.println("<p>Error loading user details: " + e.getMessage() + "</p>");
                }

                if (userDetail != null) {
                    // Parse user details
                    String[] userInfo = userDetail.split(",");
                    username = userInfo[0];
                    String password = userInfo[1];
                    String email = userInfo[2];
                    String phone = userInfo[3];
                    String address = userInfo[4];
        %>
        <div class="profile-info">
            <p><strong>Username:</strong> <%=username%></p>
            <p><strong>Password:</strong> ••••••• </p>
            <p><strong>Email:</strong> <%=email%></p>
            <p><strong>Phone:</strong> <%=phone%></p>
            <p><strong>Address:</strong> <%=address%></p>
        </div>
        <%
        } else {
        %>
        <p style="color: red;">User details could not be found!</p>
        <%
                }
            }
        %>
    </div>

    <!-- Right Section: Profile Card -->
    <div class="profile-card">
        <img src="/images/User.png" alt="Avatar">
        <h2><%=username%></h2>
        <p class="title">Customer</p>
        <div class="star-rating">
            <i>&#9733;</i> <!-- Solid Star -->
            <i>&#9733;</i>
            <i>&#9733;</i>
            <i>&#9733;</i>
            <i>&#9733;</i>
        </div>
        <!-- Edit Button -->
        <form action="editUser.jsp" method="post">
            <button type="submit" class="edit-button">Edit User Details</button>
        </form>
        <!-- View Orders Button -->
        <form action="<%= request.getContextPath() %>/UserProfile/ViewUserOrders.jsp" method="get">
            <button type="submit" class="view-orders-button">View Orders</button>
        </form>
    </div>
</div>
</body>
</html>