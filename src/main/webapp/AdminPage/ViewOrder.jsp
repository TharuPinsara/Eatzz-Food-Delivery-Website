<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Check if "adminUser" attribute exists in the session; if not, redirect to the login page
    if (session.getAttribute("adminUser") == null) {
        response.sendRedirect(request.getContextPath() + "/AdminPage/admin_login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Order Details</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/AdminPage/StyleDashboard.css">
</head>
<body>
<div class="dashboard">
    <jsp:include page="/AdminPage/AdminSideBar.jsp"/>

    <main class="main-content">
        <header class="top-bar">
            <h1>Order Details</h1>
            <div class="top-bar-right">
                <div class="profile-dropdown">
                    <div class="profile-toggle">
                        <span><b><%= session.getAttribute("adminUser") != null ? session.getAttribute("adminUser") : "Admin" %></b></span>
                        <span>▼</span>
                    </div>
                    <div class="dropdown-menu">
                        <a href="#">Profile</a>
                        <a href="<%= request.getContextPath() %>/LogoutServlet">Logout</a>
                    </div>
                </div>
            </div>
        </header>

        <section class="main-section">
            <div class="container order-details">
                <h2>Order Information</h2>
                <div class="order-info">
                    <p><strong>Order ID:</strong> <%= request.getAttribute("orderId") != null ? request.getAttribute("orderId") : "N/A" %></p>
                    <p><strong>Username:</strong> <%= request.getAttribute("username") != null ? request.getAttribute("username") : "N/A" %></p>
                    <p><strong>Email:</strong> <%= request.getAttribute("email") != null ? request.getAttribute("email") : "N/A" %></p>
                    <p><strong>Address:</strong> <%= request.getAttribute("address") != null ? request.getAttribute("address") : "N/A" %></p>
                    <p><strong>Total Price (LKR):</strong> <%= request.getAttribute("totalPrice") != null ? request.getAttribute("totalPrice") : "N/A" %></p>
                    <p><strong>Date:</strong> <%= request.getAttribute("date") != null ? request.getAttribute("date") : "N/A" %></p>
                    <p><strong>Status:</strong> <%= request.getAttribute("status") != null ? request.getAttribute("status") : "N/A" %></p>
                </div>

                <h2>Items</h2>
                <table class="table order-items-table">
                    <thead>
                    <tr>
                        <th>Item Name</th>
                        <th>Store</th>
                        <th>Quantity</th>
                        <th>Price (LKR)</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        String items = (String) request.getAttribute("items");
                        if (items != null && !items.isEmpty()) {
                            String[] itemList = items.split(";");
                            for (String item : itemList) {
                                String[] itemDetails = item.split("\\|", -1);
                                if (itemDetails.length >= 4) {
                    %>
                    <tr>
                        <td><%= itemDetails[0] %></td>
                        <td><%= itemDetails[1] %></td>
                        <td><%= itemDetails[2] %></td>
                        <td><%= itemDetails[3] %></td>
                    </tr>
                    <%
                            }
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="4">No items</td>
                    </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>

                <div class="action-buttons">
                    <a href="<%= request.getContextPath() %>/AdminPage/AdminDashboard.jsp" class="btn back-btn">Back to Dashboard</a>
                </div>
            </div>
        </section>
    </main>
</div>

<script>
    // Toggle dropdown menu on click for better mobile support
    document.querySelector('.profile-toggle').addEventListener('click', function () {
        const dropdownMenu = document.querySelector('.dropdown-menu');
        dropdownMenu.classList.toggle('active');
    });

    // Close dropdown when clicking outside
    document.addEventListener('click', function (event) {
        const profileDropdown = document.querySelector('.profile-dropdown');
        if (!profileDropdown.contains(event.target)) {
            document.querySelector('.dropdown-menu').classList.remove('active');
        }
    });
</script>
</body>
</html>