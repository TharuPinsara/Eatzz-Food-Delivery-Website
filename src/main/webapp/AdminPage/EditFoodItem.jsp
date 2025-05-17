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
    <title>Edit Food Item</title>
    <link href="<%= request.getContextPath() %>/AdminPage/AdminCss/EditFoodItem.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/AdminPage/AdminCss/StyleDashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
</head>
<body>
<div class="dashboard">
    <jsp:include page="/AdminPage/AdminSideBar.jsp" />

    <main class="main-content">
        <div class="form-container">
            <h2>Edit Food Item</h2>
            <form action="<%= request.getContextPath() %>/EditFoodItemServlet" method="post">
                <input type="hidden" name="name" value="<%= request.getAttribute("name") != null ? request.getAttribute("name") : "" %>">

                <label for="name">Food Name:</label>
                <input type="text" id="name" name="name" value="<%= request.getAttribute("name") != null ? request.getAttribute("name") : "" %>" required readonly>

                <label for="price">Price (LKR):</label>
                <input type="number" id="price" name="price" step="0.01" min="0" value="<%= request.getAttribute("price") != null ? request.getAttribute("price") : "" %>" required>

                <label for="store">Store:</label>
                <input type="text" id="store" name="store" value="<%= request.getAttribute("store") != null ? request.getAttribute("store") : "" %>" required>

                <label for="image_url">Image URL:</label>
                <input type="url" id="image_url" name="image_url" value="<%= request.getAttribute("image_url") != null ? request.getAttribute("image_url") : "" %>" required>

                <div class="button-group">
                    <button type="submit" class="save-btn">Save Changes</button>
                    <a href="<%= request.getContextPath() %>/AdminPage/AdminDashboard.jsp" class="store-btn">Back to ADMIN Panel</a>
                </div>
            </form>
        </div>
    </main>
</div>
</body>
</html>