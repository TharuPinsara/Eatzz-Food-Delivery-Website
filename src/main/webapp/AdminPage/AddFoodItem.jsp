<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("adminUser") == null) {
        response.sendRedirect(request.getContextPath() + "/AdminPage/admin_login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Food Item</title>
    <link href="/AdminPage/AdminCss/AddFoodItem.css" rel="stylesheet">
    <link href="/AdminPage/AdminCss/StyleDashboard.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
</head>
<body>
<div class="dashboard">
    <jsp:include page="/AdminPage/AdminSideBar.jsp" />

    <main class="main-content">
        <div class="form-container">
            <h2>Add New Food Item</h2>
            <form action="<%= request.getContextPath() %>/AddFoodItemServlet" method="post">
                <label for="name">Food Name:</label>
                <input type="text" id="name" name="name" required>

                <label for="price">Price (LKR):</label>
                <input type="number" id="price" name="price" step="0.01" min="0" required>

                <label for="store">Store:</label>
                <input type="text" id="store" name="store" required>

                <label for="image_url">Image URL:</label>
                <input type="url" id="image_url" name="image_url" required>

                <div class="button-group">
                    <button type="submit" class="save-btn">Add Food Item</button>
                    <a href="<%= request.getContextPath() %>/AdminPage/AdminDashboard.jsp" class="store-btn">Back to Dashboard</a>
                </div>
            </form>
        </div>
    </main>
</div>
</body>
</html>