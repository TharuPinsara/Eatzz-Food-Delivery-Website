<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cart - Eatzz Food Delivery</title>
    <!-- Add Google Fonts Import -->
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Css/cartStyle.css">
    <link rel="icon" href="<%= request.getContextPath() %>/images/Eatzz.png">
</head>
<body>
<header class="header">
    <div class="logo">
        <img src="<%= request.getContextPath() %>/images/Eatzz.png" alt="Eatzz Logo">
    </div>
    <nav>
        <ul class="nav-links">
            <li><a href="index.jsp">Home</a></li>
            <li><a href="menu.jsp">Menu</a></li>
            <li><a href="cart.jsp" class="active">Cart</a></li>
            <li><a href="profile.jsp">Profile</a></li>
        </ul>
    </nav>
</header>

<main>
    <div class="cart-container">
        <h1>Your Cart</h1>
        <%
            List<String> cartItems = (List<String>) request.getAttribute("cartItems");
            if (cartItems == null) cartItems = new java.util.ArrayList<>();
            Double totalPrice = (Double) request.getAttribute("totalPrice");
            if (totalPrice == null) totalPrice = 0.0;

            if (cartItems.isEmpty()) { %>
        <p class="p1"> Your cart is empty. <a href="menu.jsp">Go back to menu</a> to add items!</p1>
        <% } else {
            for (String item : cartItems) { %>
        <div class="cart-item">
            <img src="<%= request.getContextPath() %>/images/sample-food.png" alt="Food Image">
            <div class="item-info">
                <h2><%= item %></h2>
                <p>Price: $10.00</p>
            </div>
            <div class="item-actions">
                <form method="post" action="<%= request.getContextPath() %>/cart">
                    <input type="hidden" name="action" value="remove">
                    <input type="hidden" name="item" value="<%= item %>">
                    <button>Remove</button>
                </form>
            </div>
        </div>
        <% }
        } %>
        <div class="total-container">
            <h3>Total: $<%= totalPrice %></h3>
            <form method="post" action="<%= request.getContextPath() %>/checkout">
                <button class="checkout-button">Checkout</button>
            </form>
        </div>
    </div>
</main>

<footer>
    <p>2025 Eatzz. All Rights Reserved.</p>
</footer>
</body>
</html>