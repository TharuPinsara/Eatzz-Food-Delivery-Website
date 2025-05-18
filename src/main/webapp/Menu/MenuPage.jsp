<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.menu.foodapp.FoodItem" %>
<%@ page import="com.example.menu.foodapp.FoodItemFileUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<html>
<head>
  <title>Food Menu</title>
  <link rel="stylesheet" href="/Menu/styles.css">
  <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<jsp:include page="/Header/HeaderBar.jsp" />

<div class="container">
  <div class="header2">
    <h1>Our Delicious Menu</h1>
  </div>

  <form method="get" action="MenuPage.jsp" class="controls">
    <input type="text" id="search" name="search" placeholder="Search for food items..." class="search-bar"
           value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>" />
    <button type="submit" name="sort" value="price" class="add-restaurant-btn">Sort by Price</button>
  </form>

  <div class="loading" id="loadingSpinner" style="display: none;">Loading...</div>

  <div class="menu-grid" id="menuGrid">
    <%
      ServletContext applicationContext = request.getServletContext();
      List<FoodItem> foodItems = FoodItemFileUtil.loadFoodItems(applicationContext);
      int cardIndex = 0;

      // Apply sorting if requested
      if ("price".equals(request.getParameter("sort"))) {
        foodItems.sort((a, b) -> Double.compare(a.getPrice(), b.getPrice()));
      }

      // Apply search filter if provided
      String searchTerm = request.getParameter("search");
      if (searchTerm != null && !searchTerm.isEmpty()) {
        List<FoodItem> filteredItems = new ArrayList<>();
        for (FoodItem item : foodItems) {
          if (item.getName().toLowerCase().contains(searchTerm.toLowerCase()) ||
                  item.getStoreName().toLowerCase().contains(searchTerm.toLowerCase())) {
            filteredItems.add(item);
          }
        }
        foodItems = filteredItems;
      }

      if (foodItems.isEmpty()) {
    %>
    <div class="no-results">No food items found matching your search.</div>
    <%
    } else {
      for (FoodItem item : foodItems) {
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
      }
    %>
  </div>
</div>

<script>
  // Initialize cart from sessionStorage
  let cart = JSON.parse(sessionStorage.getItem('cart')) || [];
  updateCartCount();

  // Client-side search
  const searchInput = document.getElementById('search');
  const menuGrid = document.getElementById('menuGrid');
  const loadingSpinner = document.getElementById('loadingSpinner');

  function filterItems() {
    const searchTerm = searchInput.value.toLowerCase();
    const foodCards = document.querySelectorAll('.food-card');
    let hasVisibleItems = false;

    loadingSpinner.style.display = 'block';

    foodCards.forEach(card => {
      const foodName = card.querySelector('.food-name').textContent.toLowerCase();
      const storeName = card.querySelector('.store-tag').textContent.toLowerCase();
      const matchesSearch = searchTerm === '' || foodName.includes(searchTerm) || storeName.includes(searchTerm);

      card.style.display = matchesSearch ? 'block' : 'none';
      if (matchesSearch) hasVisibleItems = true;
    });

    const noResults = document.querySelector('.no-results');
    if (!hasVisibleItems) {
      if (!noResults) {
        const noResultsDiv = document.createElement('div');
        noResultsDiv.className = 'no-results';
        noResultsDiv.textContent = 'No food items found matching your search.';
        menuGrid.appendChild(noResultsDiv);
      }
    } else if (noResults) {
      noResults.remove();
    }

    loadingSpinner.style.display = 'none';
  }

  searchInput.addEventListener('input', filterItems);

  // Add to cart functionality
  document.querySelectorAll('.add-to-cart').forEach(button => {
    button.addEventListener('click', function() {
      const item = {
        id: this.parentElement.parentElement.getAttribute('data-id'),
        name: this.getAttribute('data-name'),
        price: parseFloat(this.getAttribute('data-price')),
        image: this.getAttribute('data-image'),
        store: this.getAttribute('data-store'),
        quantity: 1
      };

      // Check if item already in cart
      const existingItem = cart.find(cartItem => cartItem.id === item.id);
      if (existingItem) {
        existingItem.quantity += 1;
      } else {
        cart.push(item);
      }

      // Update session storage
      sessionStorage.setItem('cart', JSON.stringify(cart));
      updateCartCount();
      showAddedToCart(item.name);
      window.dispatchEvent(new Event('storage')); // Trigger storage event for HeaderBar.jsp
    });
  });

  function updateCartCount() {
    const count = cart.reduce((total, item) => total + item.quantity, 0);
    const headerCartCount = document.getElementById('headerCartCount');
    if (headerCartCount) {
      headerCartCount.textContent = count;
    }
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