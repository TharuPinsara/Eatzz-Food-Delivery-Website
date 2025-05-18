<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.File,java.io.BufferedReader,java.io.FileReader,java.io.IOException" %>
<%@ include file="/Header/HeaderBar.jsp" %>
<%
    // Check if "username" attribute exists in the session; if not, redirect to the login page
    String loggedUser = (String) session.getAttribute("username");
    if (loggedUser == null) {
        response.sendRedirect("/index.jsp");
        return;
    }

    // Fetch delivery details
    String orderId = (String) request.getAttribute("orderId");
    String deliveryPartner = "Not Assigned";
    String deliveryStatus = "Processing";
    if (orderId != null) {
        String deliveryFilePath = application.getRealPath("/") + "WEB-INF/delivery_details.txt";
        File deliveryFile = new File(deliveryFilePath);
        if (deliveryFile.exists() && deliveryFile.canRead()) {
            try (BufferedReader reader = new BufferedReader(new FileReader(deliveryFile))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    String[] details = line.split(",");
                    if (details.length >= 3 && details[0].equals(orderId)) {
                        deliveryPartner = details[1];
                        deliveryStatus = details[2];
                        break;
                    }
                }
            } catch (IOException e) {
                // Log error (in production, use a proper logging framework)
                System.err.println("Error reading delivery_details.txt: " + e.getMessage());
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Details</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/UserProfile/StyleViewOrder.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/UserProfile/StyleEditOrder.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body>
<div class="orders-container">
    <h2>Order Details</h2>
    <div id="popupMessage" class="popup-container">
        <i id="popupIcon" class="fa"></i>
        <span id="popupBody"></span>
        <button id="popupClose" class="popup-close" onclick="closePopup()">×</button>
    </div>
    <%
        // Check if order details are available
        boolean orderExists = request.getAttribute("orderId") != null;
    %>
    <% if (orderExists) { %>
    <div class="order-info">
        <p><i class="fa fa-hashtag"></i> <strong>Order ID:</strong> <%= request.getAttribute("orderId") %></p>
        <p><i class="fa fa-user"></i> <strong>Username:</strong> <%= request.getAttribute("username") != null ? request.getAttribute("username") : "N/A" %></p>
        <p><i class="fa fa-envelope"></i> <strong>Email:</strong> <%= request.getAttribute("email") != null ? request.getAttribute("email") : "N/A" %></p>
        <p><i class="fa fa-map-marker-alt"></i> <strong>Address:</strong> <%= request.getAttribute("address") != null ? request.getAttribute("address") : "N/A" %></p>
        <p><i class="fa fa-phone"></i> <strong>Phone Number:</strong> <%= request.getAttribute("phone") != null && !((String) request.getAttribute("phone")).isEmpty() ? request.getAttribute("phone") : "Not provided" %></p>
        <p><i class="fa fa-money-bill"></i> <strong>Total Price (LKR):</strong> <%= request.getAttribute("totalPrice") != null ? request.getAttribute("totalPrice") : "N/A" %></p>
        <p><i class="fa fa-calendar"></i> <strong>Date:</strong> <%= request.getAttribute("date") != null ? request.getAttribute("date") : "N/A" %></p>
        <p><i class="fa fa-info-circle"></i> <strong>Status:</strong> <%= request.getAttribute("status") != null ? request.getAttribute("status") : "N/A" %></p>
        <p><i class="fa fa-truck"></i> <strong>Delivery Partner:</strong> <%= deliveryPartner %></p>
        <p><i class="fa fa-box"></i> <strong>Delivery Status:</strong> <%= deliveryStatus %></p>
    </div>
    <h2>Items</h2>
    <table class="order-items-table">
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
        <form method="POST" action="<%= request.getContextPath() %>/DeleteUserOrder">
            <input type="hidden" name="orderId" value="<%= request.getAttribute("orderId") %>">
            <button type="submit" class="delete-btn" onclick="return confirm('Are you sure you want to delete this order?')"><i class="fa fa-trash"></i> Delete Order</button>
        </form>
        <button class="edit-btn" onclick="toggleEditForm()"><i class="fa fa-edit"></i> Edit Address & Phone</button>
        <a href="<%= request.getContextPath() %>/UserProfile/ViewUserOrders.jsp" class="back-btn"><i class="fa fa-arrow-left"></i> Back to Orders</a>
    </div>
    <% if (orderExists) { %>
    <div id="editForm" class="edit-form" style="display: none;">
        <h3>Edit Order</h3>
        <form method="POST" action="<%= request.getContextPath() %>/EditUserOrder">
            <input type="hidden" name="orderId" value="<%= request.getAttribute("orderId") %>">
            <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") != null ? session.getAttribute("csrfToken") : "" %>">
            <div class="form-group">
                <label for="address"><i class="fa fa-map-marker-alt"></i> Address:</label>
                <input type="text" id="address" name="address" value="<%= request.getAttribute("address") != null ? request.getAttribute("address") : "" %>" required>
            </div>
            <div class="form-group">
                <label for="phone"><i class="fa fa-phone"></i> Phone Number:</label>
                <input type="tel" id="phone" name="phone" value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>" pattern="[0-9]{10}" placeholder="e.g., 0771234567">
            </div>
            <div class="form-buttons">
                <button type="submit" class="save-btn"><i class="fa fa-save"></i> Save Changes</button>
                <button type="button" class="cancel-btn" onclick="toggleEditForm()"><i class="fa fa-times"></i> Cancel</button>
            </div>
        </form>
    </div>
    <% } %>
    <% } else { %>
    <p class="no-order"><i class="fa fa-exclamation-circle"></i> No order details available.</p>
    <div class="action-buttons">
        <a href="<%= request.getContextPath() %>/UserProfile/ViewUserOrders.jsp" class="back-btn"><i class="fa fa-arrow-left"></i> Back to Orders</a>
    </div>
    <% } %>
</div>
<script>
    function toggleEditForm() {
        const form = document.getElementById('editForm');
        form.style.display = form.style.display === 'none' ? 'block' : 'none';
        console.log('Edit form toggled:', form.style.display);
    }

    function showPopup(message, isSuccess) {
        const popup = document.getElementById('popupMessage');
        const popupBody = document.getElementById('popupBody');
        const popupIcon = document.getElementById('popupIcon');
        popupBody.textContent = message;
        popup.className = 'popup-container ' + (isSuccess ? 'popup-success' : 'popup-error');
        popupIcon.className = 'fa ' + (isSuccess ? 'fa-check-circle' : 'fa-exclamation-circle');
        popup.style.display = 'block';
        console.log('Popup shown:', message, 'Type:', isSuccess ? 'success' : 'error');
    }

    function closePopup() {
        const popup = document.getElementById('popupMessage');
        popup.style.display = 'none';
        console.log('Popup closed');
        // Clear query parameters from URL without reloading, preserve orderId if present
        const urlParams = new URLSearchParams(window.location.search);
        const orderId = urlParams.get('orderId');
        const newUrl = orderId ? window.location.pathname + '?orderId=' + orderId : window.location.pathname;
        window.history.replaceState({}, document.title, newUrl);
    }

    document.addEventListener('DOMContentLoaded', function () {
        try {
            const urlParams = new URLSearchParams(window.location.search);
            const successMessage = urlParams.get('success');
            const errorMessage = urlParams.get('error');

            console.log('Query params:', { success: successMessage, error: errorMessage });
            console.log('Phone attribute:', '<%= request.getAttribute("phone") %>');

            if (successMessage) {
                const message = successMessage === 'orderDeleted' ? 'Order deleted successfully.' :
                    successMessage === 'orderUpdated' ? 'Order updated successfully.' : successMessage;
                showPopup(message, true);
            } else if (errorMessage) {
                showPopup(errorMessage, false);
            }
        } catch (e) {
            console.error('Error in popup script:', e);
        }
    });
</script>
</body>
</html>