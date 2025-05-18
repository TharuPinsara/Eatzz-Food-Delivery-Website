<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Add Restaurant</title>
  <link rel="stylesheet" href="/RestaurantPage/RestaurantStyles.css">
  <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
  <style>
    .message {
      padding: 10px;
      margin-bottom: 15px;
      border-radius: 5px;
      text-align: center;
    }
    .success {
      background-color: #d4edda;
      color: #155724;
    }
    .error {
      background-color: #f8d7da;
      color: #721c24;
    }
  </style>
</head>
<body>
<div class="container">
  <h1>Add New Restaurant</h1>
  <%
    String success = request.getParameter("success");
    String error = request.getParameter("error");
    if (success != null && success.equals("restaurantAdded")) {
  %>
  <div class="message success">Restaurant added successfully!</div>
  <%
    }
    if (error != null) {
      String errorMessage;
      switch (error) {
        case "missingFields":
          errorMessage = "All restaurant fields are required.";
          break;
        case "duplicateRestaurant":
          errorMessage = "A restaurant with this name already exists.";
          break;
        case "duplicateFoodName":
          errorMessage = "A food item with this name already exists.";
          break;
        case "invalidPrice":
          errorMessage = "Invalid price format. Please enter a valid number.";
          break;
        case "loadFailed":
          errorMessage = "Failed to load existing data.";
          break;
        case "restaurantSaveFailed":
          errorMessage = "Failed to save restaurant.";
          break;
        case "foodSaveFailed":
          errorMessage = "Failed to save food items.";
          break;
        case "foodLoadFailed":
          errorMessage = "Failed to load food items.";
          break;
        default:
          errorMessage = "An error occurred.";
      }
  %>
  <div class="message error"><%= errorMessage %></div>
  <%
    }
  %>
  <form action="/Restaurants" method="post">
    <div class="form-group">
      <label>Restaurant Name:</label>
      <input type="text" name="name" required class="form-input">
    </div>
    <div class="form-group">
      <label>Address:</label>
      <input type="text" name="address" required class="form-input">
    </div>
    <div class="form-group">
      <label>Phone Number:</label>
      <input type="text" name="phoneNumber" required class="form-input">
    </div>
    <h3>Food Items</h3>
    <div id="foodItems">
      <div class="food-item form-group">
        <label>Name:</label><input type="text" name="foodName[]" required class="form-input">
        <label>Price (LKR):</label><input type="number" step="0.01" min="0" name="foodPrice[]" required class="form-input">
        <label>Image Path:</label><input type="text" name="foodImage[]" placeholder="/images/food.jpg" class="form-input">
      </div>
    </div>
    <button type="button" onclick="addFoodItem()" class="add-item-btn">Add Another Food Item</button>
    <button type="submit" class="submit-btn">Save Restaurant</button>
  </form>
  <a href="/Restaurants" class="back-btn">Back to Restaurants</a>
</div>
<script>
  function addFoodItem() {
    const container = document.getElementById('foodItems');
    const div = document.createElement('div');
    div.className = 'food-item form-group';
    div.innerHTML = `
      <label>Name:</label><input type="text" name="foodName[]" required class="form-input">
      <label>Price (LKR):</label><input type="number" step="0.01" min="0" name="foodPrice[]" required class="form-input">
      <label>Image Path:</label><input type="text" name="foodImage[]" placeholder="/images/food.jpg" class="form-input">
    `;
    container.appendChild(div);
  }
</script>
</body>
</html>