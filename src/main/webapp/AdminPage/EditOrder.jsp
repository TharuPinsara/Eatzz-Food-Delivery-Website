<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.apache.commons.text.StringEscapeUtils" %>
<%
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
    <title>Edit Order</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/AdminPage/StyleDashboard.css">
</head>
<body>
<div class="dashboard">
    <jsp:include page="/AdminPage/AdminSideBar.jsp"/>
    <main class="main-content">
        <header class="top-bar">
            <h1>Edit Order</h1>
            <div class="top-bar-right">
                <div class="profile-dropdown">
                    <div class="profile-toggle">
                        <span><b><%= StringEscapeUtils.escapeHtml4((String) session.getAttribute("adminUser")) %></b></span>
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
                <form method="POST" action="<%= request.getContextPath() %>/EditOrderServlet">
                    <input type="hidden" name="orderId" value="<%= StringEscapeUtils.escapeHtml4((String) request.getAttribute("orderId")) %>">
                    <div class="order-info">
                        <p><strong>Order ID:</strong> <%= request.getAttribute("orderId") != null ? StringEscapeUtils.escapeHtml4((String) request.getAttribute("orderId")) : "N/A" %></p>
                        <p><strong>Username:</strong> <%= request.getAttribute("username") != null ? StringEscapeUtils.escapeHtml4((String) request.getAttribute("username")) : "N/A" %></p>
                        <p><strong>Email:</strong> <%= request.getAttribute("email") != null ? StringEscapeUtils.escapeHtml4((String) request.getAttribute("email")) : "N/A" %></p>
                        <p>
                            <strong>Address:</strong>
                            <input type="text" name="address" value="<%= request.getAttribute("address") != null ? StringEscapeUtils.escapeHtml4((String) request.getAttribute("address")) : "" %>" required style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                        </p>
                        <p><strong>Total Price (LKR):</strong> <%= request.getAttribute("totalPrice") != null ? StringEscapeUtils.escapeHtml4((String) request.getAttribute("totalPrice")) : "N/A" %></p>
                        <p><strong>Date:</strong> <%= request.getAttribute("date") != null ? StringEscapeUtils.escapeHtml4((String) request.getAttribute("date")) : "N/A" %></p>
                        <p>
                            <strong>Status:</strong>
                            <select name="status" required style="padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                                <option value="Pending" <%= "Pending".equals(request.getAttribute("status")) ? "selected" : "" %>>Pending</option>
                                <option value="Completed" <%= "Completed".equals(request.getAttribute("status")) ? "selected" : "" %>>Completed</option>
                                <option value="Cancelled" <%= "Cancelled".equals(request.getAttribute("status")) ? "selected" : "" %>>Cancelled</option>
                            </select>
                        </p>
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
                            <td><%= StringEscapeUtils.escapeHtml4(itemDetails[0]) %></td>
                            <td><%= StringEscapeUtils.escapeHtml4(itemDetails[1]) %></td>
                            <td><%= StringEscapeUtils.escapeHtml4(itemDetails[2]) %></td>
                            <td><%= StringEscapeUtils.escapeHtml4(itemDetails[3]) %></td>
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
                        <button type="submit" class="btn save-btn">Save Changes</button>
                        <a href="<%= request.getContextPath() %>/AdminPage/AdminDashboard.jsp" class="btn cancel-btn">Cancel</a>
                    </div>
                </form>
            </div>
        </section>
    </main>
</div>
<script>
    document.querySelector('.profile-toggle').addEventListener('click', function () {
        const dropdownMenu = document.querySelector('.dropdown-menu');
        dropdownMenu.classList.toggle('active');
    });
    document.addEventListener('click', function (event) {
        const profileDropdown = document.querySelector('.profile-dropdown');
        if (!profileDropdown.contains(event.target)) {
            document.querySelector('.dropdown-menu').classList.remove('active');
        }
    });
</script>
</body>
</html>