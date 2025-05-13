<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Admin Portal</title>
    <link rel="stylesheet" href="Css/AdminIndex.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="container">
    <h1>Admin Portal</h1>
    <p>Welcome to the Admin Portal. Please select your admin role to proceed with managing the platform or restaurant operations.</p>
    <div class="admin-options">
        <div class="admin-card">
            <h2>Website Admin</h2>
            <p>Manage the entire platform, including user accounts, settings, and overall system configurations.</p>
            <a href="/AdminPage/admin_login.jsp">Login as Website Admin</a>
        </div>
        <div class="admin-card">
            <h2>Restaurant Admin</h2>
            <p>Manage restaurant-specific operations, including menu items, store details, and orders.</p>
            <a href="/RestaurantPage/Admin/StoreAdminLogin.jsp">Login as Restaurant Admin</a>
        </div>
    </div>
</div>
</body>
</html>