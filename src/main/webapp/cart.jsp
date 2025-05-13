<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Your Cart</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        /* Base Styles */
        body {
            font-family: 'Montserrat', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f8f9fa;
            color: #2d3436;
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 30px 20px;
        }

        /* Header Styles */
        .header2 {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
            padding-bottom: 20px;
            border-bottom: 1px solid #e0e0e0;
        }

        .header2 h1 {
            font-size: 32px;
            color: #d63031;
            margin: 0;
            font-weight: 700;
        }

        /* Cart Container */
        .cart-container {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            padding: 30px;
            margin-bottom: 30px;
        }

        .empty-cart {
            text-align: center;
            padding: 60px 20px;
            color: #636e72;
            font-size: 18px;
        }

        .empty-cart a {
            color: #d63031;
            text-decoration: none;
            font-weight: 600;
        }

        .empty-cart a:hover {
            text-decoration: underline;
        }

        /* Cart Items */
        .cart-item {
            display: flex;
            padding: 25px;
            margin-bottom: 20px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.08);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            align-items: center;
        }

        .cart-item:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .cart-item-image {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 8px;
            margin-right: 30px;
            box-shadow: 0 3px 6px rgba(0,0,0,0.1);
        }

        .cart-item-details {
            flex-grow: 1;
        }

        .cart-item-details h3 {
            margin: 0 0 10px 0;
            font-size: 20px;
            color: #2d3436;
            font-weight: 600;
        }

        .store-tag {
            display: inline-block;
            background-color: #f0f0f0;
            color: #555;
            padding: 4px 10px;
            border-radius: 15px;
            font-size: 12px;
            margin: 5px 0;
            font-weight: bold;
            border: 1px solid #ddd;
        }

        .item-price {
            margin: 0 0 15px 0;
            color: #d63031;
            font-weight: bold;
            font-size: 18px;
        }

        .item-total {
            margin: 15px 0 0 0;
            font-weight: bold;
            color: #2d3436;
            font-size: 18px;
        }

        .quantity-controls {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 20px 0;
        }

        .quantity-btn {
            width: 36px;
            height: 36px;
            border: none;
            background-color: #f5f6fa;
            border-radius: 50%;
            cursor: pointer;
            font-size: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
            color: #2d3436;
        }

        .quantity-btn:hover {
            background-color: #d63031;
            color: white;
        }

        .quantity {
            min-width: 40px;
            text-align: center;
            font-weight: bold;
            font-size: 16px;
        }

        .remove-btn {
            padding: 8px 16px;
            background-color: white;
            color: #d63031;
            border: 1px solid #d63031;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            margin-left: 15px;
            transition: all 0.3s;
        }

        .remove-btn:hover {
            background-color: #d63031;
            color: white;
        }

        /* Checkout Section */
        .cart-summary {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            padding: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .total-price {
            font-size: 24px;
        }

        .total-price strong {
            color: #2d3436;
            font-weight: 600;
        }

        #cartTotal {
            color: #d63031;
            font-weight: 700;
        }

        .checkout-btn {
            padding: 15px 40px;
            background: linear-gradient(135deg, #d63031, #ff7675);
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 18px;
            font-weight: 600;
            transition: all 0.3s;
            box-shadow: 0 4px 8px rgba(214, 48, 49, 0.3);
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .checkout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(214, 48, 49, 0.4);
        }

        .checkout-btn:disabled {
            background: #b2bec3;
            box-shadow: none;
            transform: none;
            cursor: not-allowed;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .header2 {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }

            .cart-item {
                flex-direction: column;
                align-items: flex-start;
                padding: 20px;
            }

            .cart-item-image {
                width: 100%;
                height: auto;
                max-height: 200px;
                margin-right: 0;
                margin-bottom: 20px;
            }

            .quantity-controls {
                margin: 20px 0;
            }

            .cart-summary {
                flex-direction: column;
                gap: 20px;
                align-items: stretch;
            }

            .checkout-btn {
                width: 100%;
            }
        }

        /* Animation */
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .cart-item {
            animation: fadeIn 0.5s ease-out forwards;
        }
    </style>
</head>
<body>
<jsp:include page="/Header/HeaderBar.jsp" />

<div class="container">
    <div class="header2">
        <h1>Your Shopping Cart</h1>
    </div>

    <div class="cart-container" id="cartItems">
        <!-- Cart items will be loaded here -->
    </div>

    <div class="cart-summary">
        <div class="total-price">
            <strong>Total: </strong><span id="cartTotal">LKR 0.00</span>
        </div>
        <button id="checkoutBtn" class="checkout-btn">Proceed to Checkout</button>
    </div>
</div>

<script>
    // Load cart from session storage
    let cart = JSON.parse(sessionStorage.getItem('cart')) || [];

    function renderCart() {
        const cartContainer = document.getElementById('cartItems');
        const totalElement = document.getElementById('cartTotal');

        if (cart.length === 0) {
            cartContainer.innerHTML = '<div class="empty-cart">Your cart is empty. <a href="/Restaurants">Browse our menu</a> to add items!</div>';
            totalElement.textContent = 'LKR 0.00';
            document.getElementById('checkoutBtn').disabled = true;
            return;
        }

        let total = 0;
        let html = '';

        cart.forEach((item, index) => {
            total += item.price * item.quantity;
            html += `
                <div class="cart-item" data-id="${index}">
                    <img src="${item.image}" alt="${item.name}" class="cart-item-image">
                    <div class="cart-item-details">
                        <h3>${item.name}</h3>
                        <span class="store-tag">${item.store}</span>
                        <p class="item-price">LKR ${item.price.toFixed(2)}</p>
                        <div class="quantity-controls">
                            <button class="quantity-btn minus">-</button>
                            <span class="quantity">${item.quantity}</span>
                            <button class="quantity-btn plus">+</button>
                            <button class="remove-btn">Remove</button>
                        </div>
                        <p class="item-total">LKR ${(item.price * item.quantity).toFixed(2)}</p>
                    </div>
                </div>
            `;
        });

        cartContainer.innerHTML = html;
        totalElement.textContent = `LKR ${total.toFixed(2)}`;
        document.getElementById('checkoutBtn').disabled = false;

        // Add event listeners
        document.querySelectorAll('.quantity-btn.minus').forEach(btn => {
            btn.addEventListener('click', decreaseQuantity);
        });

        document.querySelectorAll('.quantity-btn.plus').forEach(btn => {
            btn.addEventListener('click', increaseQuantity);
        });

        document.querySelectorAll('.remove-btn').forEach(btn => {
            btn.addEventListener('click', removeItem);
        });
    }

    function decreaseQuantity(e) {
        const itemIndex = parseInt(e.target.closest('.cart-item').getAttribute('data-id'));
        if (cart[itemIndex].quantity > 1) {
            cart[itemIndex].quantity--;
        } else {
            cart.splice(itemIndex, 1);
        }
        updateCart();
    }

    function increaseQuantity(e) {
        const itemIndex = parseInt(e.target.closest('.cart-item').getAttribute('data-id'));
        cart[itemIndex].quantity++;
        updateCart();
    }

    function removeItem(e) {
        const itemIndex = parseInt(e.target.closest('.cart-item').getAttribute('data-id'));
        if (confirm('Remove this item from your cart?')) {
            cart.splice(itemIndex, 1);
            updateCart();
        }
    }

    function updateCart() {
        sessionStorage.setItem('cart', JSON.stringify(cart));
        renderCart();

        // Update cart count in header if exists
        if (window.updateCartCount) {
            updateCartCount();
        }

        // Notify other tabs/windows of cart update
        localStorage.setItem('cartUpdated', Date.now());
    }

    document.getElementById('checkoutBtn').addEventListener('click', function() {
        if (cart.length > 0) {
            // Create form to send cart data as parameters
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '/checkout';

            cart.forEach((item, index) => {
                const fields = [
                    { name: `cart.id`, value: item.id },
                    { name: `cart.name`, value: item.name },
                    { name: `cart.price`, value: item.price.toString() },
                    { name: `cart.image`, value: item.image },
                    { name: `cart.store`, value: item.store },
                    { name: `cart.quantity`, value: item.quantity.toString() }
                ];

                fields.forEach(field => {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = field.name;
                    input.value = field.value;
                    form.appendChild(input);
                });
            });

            document.body.appendChild(form);
            form.submit();
        }
    });

    // Listen for cart updates from other tabs
    window.addEventListener('storage', function(event) {
        if (event.key === 'cartUpdated') {
            const updatedCart = JSON.parse(sessionStorage.getItem('cart')) || [];
            cart = updatedCart;
            renderCart();
        }
    });

    // Initial render
    renderCart();
</script>
</body>
</html>