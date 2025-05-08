<header class="header">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/Header/HeaderBar.css">
  <div class="logo">
    <a href="<%= request.getContextPath() %>/HomePage/">
      <img src="<%= request.getContextPath() %>/images/Eatzz.png" alt="Eatzz Logo">
    </a>
  </div>
  <nav>
    <ul class="nav-links">
      <li><a href="<%= request.getContextPath() %>/HomePage/">Home</a></li>
      <li><a href="<%= request.getContextPath() %>/Menu/MenuPage.jsp">Menu</a></li>
      <li>
        <a href="<%= request.getContextPath() %>/cart.jsp" class="cart-link">
          Cart <span id="headerCartCount" class="cart-count">0</span>
        </a>
      </li>
      <!-- Profile Menu with Dropdown -->
      <li class="profile-menu">
        <a href="javascript:void(0)">Profile</a>
        <ul class="dropdown-menu">
          <!-- Smaller View Profile Button -->
          <li><a href="<%= request.getContextPath() %>/UserProfile/profile.jsp">View Profile</a></li>
          <!-- Improved Logout Button -->
          <li>
            <form action="<%= request.getContextPath() %>/signout" method="post" style="margin: 0;">
              <button type="submit" class="logout-button">Logout</button>
            </form>
          </li>
        </ul>
      </li>
    </ul>
  </nav>
  <script>
    // Function to update cart count in header
    function updateHeaderCartCount() {
      const cart = JSON.parse(sessionStorage.getItem('cart')) || [];
      const totalItems = cart.reduce((sum, item) => sum + item.quantity, 0);
      document.getElementById('headerCartCount').textContent = totalItems;
    }

    // Update cart count when page loads
    document.addEventListener('DOMContentLoaded', updateHeaderCartCount);

    // Listen for cart updates from other pages
    window.addEventListener('storage', function(event) {
      if (event.key === 'cartUpdated') {
        updateHeaderCartCount();
      }
    });
  </script>
</header>