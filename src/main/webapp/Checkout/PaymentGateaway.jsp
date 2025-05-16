<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Payment Gateway</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Checkout/PaymentGateawayStyle.css">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<jsp:include page="/Header/HeaderBar.jsp" />

<div class="container">
    <h1>Payment Gateway</h1>
    <div class="payment-container">
        <div class="order-details">
            <h2>Order Details</h2>
            <p><strong>Order ID:</strong> <%= request.getAttribute("orderId") != null ? request.getAttribute("orderId") : "N/A" %></p>
            <p><strong>Total Price:</strong> LKR <%= request.getAttribute("totalPrice") != null ? String.format("%.2f", (Double) request.getAttribute("totalPrice")) : "0.00" %></p>
        </div>

        <% if (request.getAttribute("successMessage") != null) { %>
        <div class="success-message">
            <h3>Payment Successful!</h3>
            <p><%= request.getAttribute("successMessage") %></p>
            <a href="<%= request.getContextPath() %>/Restaurants" class="back-to-shopping-btn">Back to Shopping</a>
        </div>
        <% } else { %>
        <div class="payment-form">
            <h2>Enter Payment Details</h2>
            <% if (request.getAttribute("errorMessage") != null) { %>
            <p class="error-message"><%= request.getAttribute("errorMessage") %></p>
            <% } %>
            <form action="<%= request.getContextPath() %>/payment" method="post">
                <div class="form-group">
                    <label for="cardNumber">Card Number</label>
                    <input type="text" id="cardNumber" name="cardNumber" placeholder="1234 5678 9012 3456" required>
                </div>
                <div class="form-group">
                    <label for="expiry">Expiry Date</label>
                    <input type="text" id="expiry" name="expiry" placeholder="MM/YY" required>
                </div>
                <div class="form-group">
                    <label for="cvv">CVV</label>
                    <input type="text" id="cvv" name="cvv" placeholder="123" required>
                </div>
                <div class="form-group">
                    <label for="cardholderName">Cardholder Name</label>
                    <input type="text" id="cardholderName" name="cardholderName" placeholder="John Doe" required>
                </div>
                <button type="submit" class="pay-now-btn">Pay Now</button>
            </form>
        </div>
        <% } %>
    </div>
</div>
</body>
</html>