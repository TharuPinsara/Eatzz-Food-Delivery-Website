<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="sidebar">
    <h2>Store Manager</h2>
    <ul>
        <li><a href="/RestaurantPage/Admin/StoreAdminDashboard.jsp">Dashboard</a></li>
        <li><a href="/RestaurantPage/Admin/StoreAdminDetails.jsp">Store Details</a></li>
        <li><a href="/RestaurantPage/Admin/StoreAdminAddFood.jsp">Add Food</a></li>
        <li><a href="/RestaurantPage/Admin/StoreAdminEditFood.jsp">Edit Food</a></li>
        <li><a href="/RestaurantPage/Admin/StoreAdminOrders.jsp">Orders</a></li>
        <li><a href="/RestaurantPage/Admin/StorePayment.jsp">Payment</a></li> <!-- New Payment tab -->
    </ul>
    <form action="/StoreAdminLogoutServlet" method="post">
        <button type="submit" class="logout-btn">Logout</button>
    </form>
</div>
<link rel="stylesheet" href="/RestaurantPage/Admin/sidebar.css">