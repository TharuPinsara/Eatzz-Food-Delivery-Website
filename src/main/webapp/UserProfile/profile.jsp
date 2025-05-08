<%@ page import="java.io.*, java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/Header/HeaderBar.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Profile</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/UserProfile/profileUser.css">
    <!-- Internal CSS Styling -->
    <style>
        body {
            font-family: 'Poppins', Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f3f4f6; /* Softer background color for better focus */
        }

        .profile-container {
            max-width: 1200px;
            margin: 60px auto;
            display: flex; /* Flex layout for side-by-side containers */
            gap: 20px; /* Adds spacing between the two sections */
            justify-content: space-between;
            padding: 30px;
            background: #fff;
            border: 1px solid #ddd; /* Light border */
            border-radius: 15px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1); /* Subtle shadow */
        }

        /* Left Section (Existing details container) */
        .profile-info-container {
            flex: 2; /* Main section for user info */
            text-align: left;
        }

        .profile-container h2 {
            font-size: 28px;
            margin-bottom: 20px;
            color: #333;
            font-weight: bold;
            letter-spacing: 1px;
            text-transform: uppercase;
            border-bottom: 1px solid #eee;
            display: inline-block;
            padding-bottom: 5px;
        }

        .profile-info {
            margin: 20px 0;
            line-height: 1.8;
            font-size: 18px;
            color: #434141; /* Softer tone for text */
        }

        .profile-info p {
            margin: 15px 0;
            padding: 10px;
            background: #f9fafb; /* Light background for contrast */
            border-radius: 8px; /* Rounded corners for blocks */
            border: 1px solid #ddd;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05); /* Subtle shadow */
            display: inline-block;
            width: 90%;
            max-width: 600px;
        }

        .profile-info p strong {
            color: #b71c1c; /* Highlighted color for labels */
            font-weight: 600;
        }

        /* Right Section (Profile Card Design) */
        .profile-card {
            flex: 1; /* Smaller section for the profile card */
            background: #fdeded;
            border: 2px solid #e3f2fd; /* Light blue border */
            border-radius: 20px; /* Rounded corners */
            padding: 30px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1); /* Add subtle shadow */
            text-align: center;
            transition: transform 0.2s ease-in-out;
        }

        .profile-card:hover {
            transform: translateY(-5px); /* Lift the card slightly on hover */
        }

        .profile-card img {
            width: 120px;
            height: 120px;
            border-radius: 50%; /* Circular image */
            border: 3px solid #e0e0e0; /* Subtle border */
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            margin-bottom: 20px;
        }

        .profile-card h3 {
            font-size: 20px;
            color: #333;
            margin: 0;
        }

        .profile-card p.title {
            font-size: 16px;
            color: #666;
            margin: 5px 0 15px 0;
        }

        .star-rating {
            margin: 10px 0;
            display: flex;
            justify-content: center;
            gap: 5px;
        }

        .star-rating i {
            color: #ffc107; /* Golden stars */
            font-size: 20px;
        }
    </style>
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
    </div>
</div>
</body>
</html>