<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<aside class="sidebar">
    <div class="sidebar-logo">
        <img src="/images/Eatzz.png" alt="Eatzz Logo" class="logo-image">
    </div>
    <nav>
        <ul>
            <li><a href="<%= request.getContextPath() %>/AdminPage/AdminDashboard.jsp" class="active">🏠 Home</a></li>
            <li><a href="<%= request.getContextPath() %>/AdminPage/AddUser.jsp">👤 Add User</a></li>
            <li><a href="<%= request.getContextPath() %>/AdminPage/AddFoodItem.jsp">🍕 Add Food Item</a></li>
            <li><a href="#">📊 Charts</a></li>
            <li><a href="#">⚙️ Settings</a></li>
        </ul>
    </nav>
</aside>