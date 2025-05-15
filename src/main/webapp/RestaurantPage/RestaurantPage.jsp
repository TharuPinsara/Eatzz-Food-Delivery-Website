<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.example.menu.foodapp.FoodItem" %>
<%@ page import="com.example.menu.foodapp.FoodItemFileUtil" %>
<%@ page import="com.example.restaurant.Restaurant" %>
<%@ page import="com.example.restaurant.RestaurantUtil" %>
<html>
<head>
    <title>Restaurants</title>
    <link rel="stylesheet" href="/RestaurantPage/RestaurantStyles.css">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<jsp:include page="/Header/HeaderBar.jsp" />

<div class="container">
    <h1>Our Restaurants</h1>

    <div class="controls">
        <input type="text" id="searchInput" placeholder="Search restaurants or dishes..." class="search-bar">
    </div>

    <div class="loading" id="loadingSpinner" style="display: none;">Loading...</div>

    <div id="restaurantContainer">
        <%
            try {
                ServletContext applicationContext = request.getServletContext();
                List<FoodItem> foodItems = FoodItemFileUtil.loadFoodItems(applicationContext);
                Map<String, List<FoodItem>> itemsByStore = new HashMap<>();
                Map<String, Restaurant> restaurantMap = new HashMap<>();

                // Group food items by store name
                for (FoodItem item : foodItems) {
                    itemsByStore.computeIfAbsent(item.getStoreName(), k -> new ArrayList<>()).add(item);
                }

                // Load restaurants from Restaurant.txt
                List<Restaurant> restaurants = RestaurantUtil.loadRestaurants(applicationContext);
                for (Restaurant restaurant : restaurants) {
                    restaurantMap.put(restaurant.getName(), restaurant);
                }

                if (itemsByStore.isEmpty()) {
        %>
        <div class="no-results">No food items found.</div>
        <%
        } else {
            int cardIndex = 0;
            for (String storeName : itemsByStore.keySet()) {
                List<FoodItem> items = itemsByStore.get(storeName);
                Restaurant restaurant = restaurantMap.get(storeName);
                String address = restaurant != null ? restaurant.getAddress() : "Not available";
                String phone = restaurant != null ? restaurant.getPhoneNumber() : "Not available";
        %>
        <div class="restaurant-section">
            <h2><%= storeName %></h2>
            <p class="restaurant-details">
                <strong>Address:</strong> <%= address %><br>
                <strong>Phone:</strong> <%= phone %>
            </p>
            <div class="restaurant-grid">
                <%
                    for (FoodItem item : items) {
                %>
                <div class="food-card" data-id="<%= item.getName().hashCode() %>" style="--index: <%= cardIndex++ %>;">
                    <img src="<%= item.getImagePath() %>" alt="<%= item.getName() %>" class="food-image">
                    <div class="food-info">
                        <h3 class="food-name"><%= item.getName() %></h3>
                        <span class="store-tag"><%= item.getStoreName() %></span>
                        <p class="food-price">LKR <%= String.format("%.2f", item.getPrice()) %></p>
                        <button class="add-to-cart"
                                data-name="<%= item.getName() %>"
                                data-price="<%= item.getPrice() %>"
                                data-image="<%= item.getImagePath() %>"
                                data-store="<%= item.getStoreName() %>">
                            Add to Cart
                        </button>
                    </div>
                </div>
                <%
                    }
                %>
            </div>
        </div>
        <%
                }
            }
        } catch (Exception e) {
        %>
        <div class="no-results">Error loading restaurants or food items: <%= e.getMessage() %></div>
        <%
            }
        %>
    </div>
</div>

<div class="modal" id="quickViewModal">
    <div class="modal-content">
        <span class="modal-close" onclick="closeQuickView()">×</span>
        <img id="modalImage" src="" alt="Food Item" style="width: 100%; height: 200px; object-fit: cover; border-radius: 8px;">
        <h2 id="modalName"></h2>
        <p id="modalStore" class="store-tag"></p>
        <p id="modalPrice" class="food-price"></p>
        <button class="add-to-cart" id="modalAddToCart">Add to Cart</button>
    </div>
</div>

<script>
    // Initialize cart from sessionStorage
    let cart = JSON.parse(sessionStorage.getItem('cart')) || [];
    updateCartCount();

    // Search functionality
    const searchInput = document.getElementById('searchInput');
    const restaurantContainer = document.getElementById('restaurantContainer');
    const loadingSpinner = document.getElementById('loadingSpinner');

    function filterRestaurants() {
        const searchTerm = searchInput.value.toLowerCase();
        const restaurantSections = document.querySelectorAll('.restaurant-section');
        let hasVisibleRestaurants = false;

        loadingSpinner.style.display = 'block';

        restaurantSections.forEach(section => {
            const restaurantName = section.querySelector('h2').textContent.toLowerCase();
            const foodCards = section.querySelectorAll('.food-card');
            let hasVisibleItems = false;

            foodCards.forEach(card => {
                const foodName = card.querySelector('.food-name').textContent.toLowerCase();
                const matchesSearch = searchTerm === '' || foodName.includes(searchTerm) || restaurantName.includes(searchTerm);

                card.style.display = matchesSearch ? 'block' : 'none';
                if (matchesSearch) hasVisibleItems = true;
            });

            section.style.display = hasVisibleItems ? 'block' : 'none';
            if (hasVisibleItems) hasVisibleRestaurants = true;
        });

        const noResults = document.querySelector('.no-results');
        if (!hasVisibleRestaurants) {
            if (!noResults) {
                const noResultsDiv = document.createElement('div');
                noResultsDiv.className = 'no-results';
                noResultsDiv.textContent = 'No restaurants or dishes found.';
                restaurantContainer.appendChild(noResultsDiv);
            }
        } else if (noResults) {
            noResults.remove();
        }

        loadingSpinner.style.display = 'none';
    }

    searchInput.addEventListener('input', filterRestaurants);

    // Add to cart functionality
    document.querySelectorAll('.add-to-cart').forEach(button => {
        button.addEventListener('click', function() {
            const item = {
                id: this.parentElement.parentElement.getAttribute('data-id') || this.getAttribute('data-id'),
                name: this.getAttribute('data-name'),
                price: parseFloat(this.getAttribute('data-price')),
                image: this.getAttribute('data-image'),
                store: this.getAttribute('data-store'),
                quantity: 1
            };

            const existingItem = cart.find(cartItem => cartItem.id === item.id);
            if (existingItem) {
                existingItem.quantity += 1;
            } else {
                cart.push(item);
            }

            sessionStorage.setItem('cart', JSON.stringify(cart));
            updateCartCount();
            showAddedToCart(item.name);
            window.dispatchEvent(new Event('storage'));
        });
    });

    function updateCartCount() {
        const count = cart.reduce((total, item) => total + item.quantity, 0);
        const headerCartCount = document.getElementById('headerCartCount');
        if (headerCartCount) headerCartCount.textContent = count;
    }

    function showAddedToCart(itemName) {
        const notification = document.createElement('div');
        notification.className = 'cart-notification';
        notification.textContent = `${itemName} added to cart!`;
        document.body.appendChild(notification);

        setTimeout(() => {
            notification.classList.add('fade-out');
            setTimeout(() => notification.remove(), 500);
        }, 2000);
    }

    // Quick view modal
    function showQuickView(name, store, price, image) {
        const modal = document.getElementById('quickViewModal');
        document.getElementById('modalName').textContent = name;
        document.getElementById('modalStore').textContent = store;
        document.getElementById('modalPrice').textContent = `LKR ${price}`;
        document.getElementById('modalImage').src = image;
        const addToCartBtn = document.getElementById('modalAddToCart');
        addToCartBtn.setAttribute('data-name', name);
        addToCartBtn.setAttribute('data-price', price);
        addToCartBtn.setAttribute('data-image', image);
        addToCartBtn.setAttribute('data-store', store);
        addToCartBtn.setAttribute('data-id', String(name.hashCode()));
        modal.style.display = 'flex';
    }

    function closeQuickView() {
        const modal = document.getElementById('quickViewModal');
        modal.style.display = 'none';
    }

    // Smooth scroll to sections
    document.querySelectorAll('.restaurant-section h2').forEach(header => {
        header.addEventListener('click', () => {
            header.parentElement.scrollIntoView({ behavior: 'smooth' });
        });
    });

    // Hash code function for strings
    String.prototype.hashCode = function() {
        let hash = 0;
        for (let i = 0; i < this.length; i++) {
            const char = this.charCodeAt(i);
            hash = ((hash << 5) - hash) + char;
            hash = hash & hash;
        }
        return hash;
    };
</script>
</body>
</html>