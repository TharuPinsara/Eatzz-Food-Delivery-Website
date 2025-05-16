<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Edit Payment</title>
  <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/AdminPage/StyleDashboard.css">
</head>
<body>
<div class="dashboard">
  <jsp:include page="/AdminPage/AdminSideBar.jsp"/>

  <main class="main-content">
    <header class="top-bar">
      <h1>Edit Payment</h1>
    </header>

    <section class="main-section">
      <h2>Edit Commission for Order ID: <%= request.getAttribute("orderId") %></h2>
      <form method="POST" action="<%= request.getContextPath() %>/EditPaymentServlet">
        <input type="hidden" name="orderId" value="<%= request.getAttribute("orderId") %>">
        <label for="commission">Website Commission (LKR):</label>
        <input type="number" step="0.01" name="commission" id="commission" required>
        <button type="submit" class="save-btn">Save</button>
        <a href="<%= request.getContextPath() %>/AdminPage/AdminDashboard.jsp" class="cancel-btn">Cancel</a>
      </form>
    </section>
  </main>
</div>
</body>
</html>