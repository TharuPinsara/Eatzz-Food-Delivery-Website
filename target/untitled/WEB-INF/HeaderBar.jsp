<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<header class="header">
  <div class="logo">
    <!-- Logo linking to the home page -->
    <a href="<%= request.getContextPath() %>/index.jsp">
      <img src="<%= request.getContextPath() %>/images/Eatzz.png" alt="Eatzz Logo">
    </a>
  </div>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/Css/HeaderBar.css">
  <nav>
    <ul class="nav-links">
      <li><a href="<%= request.getContextPath() %>/index.jsp">Home</a></li>
      <li><a href="<%= request.getContextPath() %>/menu.jsp">Menu</a></li>
      <li><a href="<%= request.getContextPath() %>/cart.jsp">Cart</a></li>
      <li><a href="<%= request.getContextPath() %>/profile.jsp">Profile</a></li>
    </ul>
  </nav>
</header>