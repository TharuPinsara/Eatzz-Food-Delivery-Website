<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.example.checkout.CartItem" %>
<html>
<head>
    <title>Order Confirmation</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Checkout/OrderPageStyles.css">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<jsp:include page="/Header/HeaderBar.jsp" />

<div class="container">
    <h1>Order Confirmation</h1>
    <div class="checkout-container">
        <div class="order-header">
            <h2>Thank You for Your Order!</h2>
            <p>Order ID: <strong><%= request.getAttribute("orderId") != null ? request.getAttribute("orderId") : "N/A" %></strong></p>
            <p>Order Date: <%= request.getAttribute("orderDate") != null ? request.getAttribute("orderDate") : "N/A" %></p>
            <p>Status: <span class="order-status"><%= request.getAttribute("orderStatus") != null ? request.getAttribute("orderStatus") : "N/A" %></span></p>
        </div>

        <div class="user-details">
            <h3>Customer Information</h3>
            <p><strong>Name:</strong> <%= request.getAttribute("userName") != null ? request.getAttribute("userName") : "N/A" %></p>
            <p><strong>Email:</strong> <%= request.getAttribute("userEmail") != null ? request.getAttribute("userEmail") : "N/A" %></p>
            <p><strong>Phone:</strong> <%= request.getAttribute("userPhone") != null ? request.getAttribute("userPhone") : "N/A" %></p>
            <p><strong>Address:</strong> <%= request.getAttribute("userAddress") != null ? request.getAttribute("userAddress") : "N/A" %></p>
        </div>

        <div class="order-items">
            <h3>Ordered Items</h3>
            <div class="order-items-grid">
                <%
                    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
                    if (cartItems != null && !cartItems.isEmpty()) {
                        for (CartItem item : cartItems) {
                            if (item != null) {
                %>
                <div class="order-item">
                    <img src="<%= item.image != null ? item.image : "" %>" alt="<%= item.name != null ? item.name : "Item" %>" class="order-item-image">
                    <div class="order-item-details">
                        <h4><%= item.name != null ? item.name : "Unknown Item" %></h4>
                        <span class="store-tag"><%= item.store != null ? item.store : "Unknown Store" %></span>
                        <p>Quantity: <%= item.quantity %></p>
                        <p>Price: LKR <%= String.format("%.2f", item.price) %></p>
                        <p>Subtotal: LKR <%= String.format("%.2f", item.price * item.quantity) %></p>
                    </div>
                </div>
                <%
                        }
                    }
                } else {
                %>
                <p>No items in the order.</p>
                <%
                    }
                %>
            </div>
        </div>

        <div class="order-summary">
            <h3>Order Summary</h3>
            <p><strong>Total Price:</strong> LKR <%= request.getAttribute("totalPrice") != null ? String.format("%.2f", (Double) request.getAttribute("totalPrice")) : "0.00" %></p>
        </div>

        <div class="order-actions">
            <a href="<%= request.getContextPath() %>/payment" class="continue-shopping-btn">Continue Shopping</a>
        </div>
    </div>
</div>

<script>
    // Clear cart after checkout
    sessionStorage.removeItem('cart');
    // Safe call to updateCartCount
    if (typeof window.updateCartCount === 'function') {
        window.updateCartCount();
    }
</script>
</body>
</html>