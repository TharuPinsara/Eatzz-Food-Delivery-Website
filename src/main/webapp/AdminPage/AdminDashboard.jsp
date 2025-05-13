<%@ page import="java.io.*, com.example.restaurant.Restaurant, com.example.restaurant.RestaurantUtil, java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Check if "adminUser" attribute exists in the session; if not, redirect to the login page
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
    <title>Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/AdminPage/StyleDashboard.css">
</head>
<body>
<div class="dashboard">
    <jsp:include page="/AdminPage/AdminSideBar.jsp"/>

    <main class="main-content">
        <header class="top-bar">
            <h1>Welcome, Admin!</h1>
            <div class="top-bar-right">
                <div class="search-bar">
                    <input type="text" id="searchInput" placeholder="Search..." onkeyup="filterTable()" />
                    <button type="button">🔍</button>
                </div>
                <div class="profile-dropdown">
                    <div class="profile-toggle">
                        <span><b><%= session.getAttribute("adminUser") %></b></span>
                        <span>▼</span>
                    </div>
                    <div class="dropdown-menu">
                        <a href="#">Profile</a>
                        <a href="<%= request.getContextPath() %>/LogoutServlet">Logout</a>
                    </div>
                </div>
            </div>
        </header>

        <section class="main-section">
            <!-- Dynamic Popups -->
            <div id="popupMessage" class="popup-container">
                <button class="close-btn" onclick="closePopup()">×</button>
                <h4 id="popupTitle"></h4>
                <p id="popupBody"></p>
            </div>

            <!-- Tab Navigation -->
            <div class="tab-navigation">
                <button class="tab-button active" onclick="openTab('users')">User Management</button>
                <button class="tab-button" onclick="openTab('food')">Food Item Management</button>
                <button class="tab-button" onclick="openTab('restaurants')">Restaurant Management</button>
                <button class="tab-button" onclick="openTab('orders')">Order Management</button>
            </div>

            <!-- User Management Tab -->
            <div id="users" class="tab-content active">
                <h2>User Management</h2>
                <table id="userTable" class="user-table">
                    <thead>
                    <tr>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Address</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        String userFilePath = application.getRealPath("/") + "WEB-INF/users.txt";
                        File userFile = new File(userFilePath);

                        if (userFile.exists()) {
                            if (userFile.canRead()) {
                                try (BufferedReader br = new BufferedReader(new FileReader(userFile))) {
                                    String line;
                                    boolean hasData = false;

                                    while ((line = br.readLine()) != null) {
                                        hasData = true;
                                        String[] userDetails = line.split(",");
                                        if (userDetails.length >= 5) {
                    %>
                    <tr>
                        <td><%= userDetails[0] %></td>
                        <td><%= userDetails[2] %></td>
                        <td><%= userDetails[3] %></td>
                        <td><%= userDetails[4] %></td>
                        <td>
                            <div class="action-form">
                                <form method="GET" action="<%= request.getContextPath() %>/EditUserServlet">
                                    <input type="hidden" name="username" value="<%= userDetails[0] %>">
                                    <button type="submit" class="edit-btn">Edit</button>
                                </form>
                                <form method="POST" action="<%= request.getContextPath() %>/DeleteUserServlet">
                                    <input type="hidden" name="username" value="<%= userDetails[0] %>">
                                    <button type="submit" class="delete-btn">Delete</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <%
                                        }
                                    }

                                    if (!hasData) {
                                        out.println("<tr><td colspan='5'>No users found in file</td></tr>");
                                    }
                                } catch (IOException e) {
                                    out.println("<tr><td colspan='5'>Error reading users file: " + e.getMessage() + "</td></tr>");
                                }
                            } else {
                                out.println("<tr><td colspan='5'>No permission to read users file</td></tr>");
                            }
                        } else {
                            out.println("<tr><td colspan='5'>User file not found at: " + userFilePath + "</td></tr>");
                        }
                    %>
                    </tbody>
                </table>
            </div>

            <!-- Food Item Management Tab -->
            <div id="food" class="tab-content">
                <h2>Food Item Management</h2>
                <table id="foodTable" class="food-table">
                    <thead>
                    <tr>
                        <th>Image</th>
                        <th>Name</th>
                        <th>Price (LKR)</th>
                        <th>Store</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        String foodFilePath = application.getRealPath("/") + "WEB-INF/fooditems.txt";
                        File foodFile = new File(foodFilePath);

                        if (foodFile.exists()) {
                            if (foodFile.canRead()) {
                                try (BufferedReader br = new BufferedReader(new FileReader(foodFile))) {
                                    String line;
                                    boolean hasData = false;

                                    while ((line = br.readLine()) != null) {
                                        hasData = true;
                                        String[] foodDetails = line.split(",");
                                        if (foodDetails.length >= 4) {
                    %>
                    <tr>
                        <td><img src="<%= foodDetails[3].trim() %>" alt="<%= foodDetails[0].trim() %>" class="food-image"></td>
                        <td><%= foodDetails[0].trim() %></td>
                        <td><%= foodDetails[1].trim() %></td>
                        <td><%= foodDetails[2].trim() %></td>
                        <td>
                            <div class="action-form">
                                <form method="GET" action="<%= request.getContextPath() %>/EditFoodItemServlet">
                                    <input type="hidden" name="name" value="<%= foodDetails[0].trim() %>">
                                    <button type="submit" class="edit-btn">Edit</button>
                                </form>
                                <form method="POST" action="<%= request.getContextPath() %>/DeleteFoodItemServlet">
                                    <input type="hidden" name="name" value="<%= foodDetails[0].trim() %>">
                                    <button type="submit" class="delete-btn">Delete</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <%
                                        }
                                    }

                                    if (!hasData) {
                                        out.println("<tr><td colspan='5'>No food items found in file</td></tr>");
                                    }
                                } catch (IOException e) {
                                    out.println("<tr><td colspan='5'>Error reading food items file: " + e.getMessage() + "</td></tr>");
                                }
                            } else {
                                out.println("<tr><td colspan='5'>No permission to read food items file</td></tr>");
                            }
                        } else {
                            out.println("<tr><td colspan='5'>Food items file not found at: " + foodFilePath + "</td></tr>");
                        }
                    %>
                    </tbody>
                </table>
            </div>

            <!-- Restaurant Management Tab -->
            <div id="restaurants" class="tab-content">
                <h2>Restaurant Management</h2>
                <table id="restaurantTable" class="restaurant-table">
                    <thead>
                    <tr>
                        <th>Name</th>
                        <th>Address</th>
                        <th>Phone</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        try {
                            List<Restaurant> restaurants = RestaurantUtil.loadRestaurants(application);
                            if (restaurants.isEmpty()) {
                                out.println("<tr><td colspan='4'>No restaurants found</td></tr>");
                            } else {
                                for (Restaurant r : restaurants) {
                    %>
                    <tr>
                        <td><%= r.getName() %></td>
                        <td><%= r.getAddress() %></td>
                        <td><%= r.getPhoneNumber() %></td>
                        <td>
                            <div class="action-form">
                                <form method="GET" action="<%= request.getContextPath() %>/EditRestaurantServlet">
                                    <input type="hidden" name="name" value="<%= r.getName() %>">
                                    <button type="submit" class="edit-btn">Edit</button>
                                </form>
                                <form method="POST" action="<%= request.getContextPath() %>/DeleteRestaurantServlet">
                                    <input type="hidden" name="name" value="<%= r.getName() %>">
                                    <button type="submit" class="delete-btn">Delete</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <%
                                }
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='4'>Error loading restaurants: " + e.getMessage() + "</td></tr>");
                        }
                    %>
                    </tbody>
                </table>
            </div>

            <!-- Order Management Tab -->
            <div id="orders" class="tab-content">
                <h2>Order Management</h2>
                <table id="orderTable" class="order-table">
                    <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Address</th>
                        <th>Total Price (LKR)</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Items</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        String orderFilePath = application.getRealPath("/") + "WEB-INF/orders/order_history.txt";
                        File orderFile = new File(orderFilePath);

                        if (orderFile.exists()) {
                            if (orderFile.canRead()) {
                                try (BufferedReader br = new BufferedReader(new FileReader(orderFile))) {
                                    String line;
                                    boolean hasData = false;

                                    while ((line = br.readLine()) != null) {
                                        hasData = true;
                                        String[] orderDetails = line.split(",", -1);
                                        if (orderDetails.length >= 8) {
                                            String items = orderDetails[7];
                                            String formattedItems = "";
                                            if (!items.isEmpty()) {
                                                String[] itemList = items.split(";");
                                                for (String item : itemList) {
                                                    String[] itemDetails = item.split("\\|", -1);
                                                    if (itemDetails.length >= 4) {
                                                        formattedItems += itemDetails[0] + " (" + itemDetails[1] + ", Qty: " + itemDetails[2] + ", Price: " + itemDetails[3] + ")<br>";
                                                    }
                                                }
                                            } else {
                                                formattedItems = "No items";
                                            }
                    %>
                    <tr>
                        <td><%= orderDetails[0] %></td>
                        <td><%= orderDetails[1] %></td>
                        <td><%= orderDetails[2] %></td>
                        <td><%= orderDetails[3] %></td>
                        <td><%= orderDetails[4] %></td>
                        <td><%= orderDetails[5] %></td>
                        <td><%= orderDetails[6] %></td>
                        <td><%= formattedItems %></td>
                        <td>
                            <div class="action-form">
                                <form method="GET" action="<%= request.getContextPath() %>/ViewOrderServlet">
                                    <input type="hidden" name="orderId" value="<%= orderDetails[0] %>">
                                    <button type="submit" class="view-btn">View Details</button>
                                </form>
                                <form method="POST" action="<%= request.getContextPath() %>/DeleteOrderServlet">
                                    <input type="hidden" name="orderId" value="<%= orderDetails[0] %>">
                                    <button type="submit" class="delete-btn">Delete</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <%
                                        }
                                    }

                                    if (!hasData) {
                                        out.println("<tr><td colspan='9'>No orders found in file</td></tr>");
                                    }
                                } catch (IOException e) {
                                    out.println("<tr><td colspan='9'>Error reading orders file: " + e.getMessage() + "</td></tr>");
                                }
                            } else {
                                out.println("<tr><td colspan='9'>No permission to read orders file</td></tr>");
                            }
                        } else {
                            out.println("<tr><td colspan='9'>Order file not found at: " + orderFilePath + "</td></tr>");
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</div>

<script>
    // Handle dynamic popups for success/error messages
    window.addEventListener('load', function () {
        const urlParams = new URLSearchParams(window.location.search);
        const successMessage = urlParams.get('success');
        const errorMessage = urlParams.get('error');

        const popup = document.getElementById('popupMessage');
        const title = document.getElementById('popupTitle');
        const body = document.getElementById('popupBody');

        if (successMessage) {
            switch (successMessage) {
                case 'userCreated':
                    title.innerText = 'User Created';
                    body.innerText = 'The user has been successfully created.';
                    break;
                case 'userDeleted':
                    title.innerText = 'User Deleted';
                    body.innerText = 'The user has been successfully deleted.';
                    break;
                case 'userEdited':
                    title.innerText = 'User Edited';
                    body.innerText = 'The user details have been successfully updated.';
                    break;
                case 'foodCreated':
                    title.innerText = 'Food Item Created';
                    body.innerText = 'The food item has been successfully added.';
                    break;
                case 'foodDeleted':
                    title.innerText = 'Food Item Deleted';
                    body.innerText = 'The food item has been successfully removed.';
                    break;
                case 'foodUpdated':
                    title.innerText = 'Food Item Updated';
                    body.innerText = 'The food item details have been successfully updated.';
                    break;
                case 'restaurantCreated':
                    title.innerText = 'Restaurant Created';
                    body.innerText = 'The restaurant has been successfully added.';
                    break;
                case 'restaurantDeleted':
                    title.innerText = 'Restaurant Deleted';
                    body.innerText = 'The restaurant has been successfully removed.';
                    break;
                case 'restaurantUpdated':
                    title.innerText = 'Restaurant Updated';
                    body.innerText = 'The restaurant details have been successfully updated.';
                    break;
                case 'orderUpdated':
                    title.innerText = 'Order Updated';
                    body.innerText = 'The order details have been successfully updated.';
                    break;
                case 'orderDeleted':
                    title.innerText = 'Order Deleted';
                    body.innerText = 'The order has been successfully deleted.';
                    break;
                default:
                    title.innerText = 'Success';
                    body.innerText = successMessage;
            }
            popup.classList.add('success');
            popup.style.display = 'block';
        } else if (errorMessage) {
            title.innerText = 'Error';
            body.innerText = errorMessage;
            popup.classList.add('error');
            popup.style.display = 'block';
        }
    });

    // Close popup
    function closePopup() {
        const popup = document.getElementById('popupMessage');
        popup.style.display = 'none';
    }

    // Tab functionality
    function openTab(tabName) {
        console.log('Opening tab: ' + tabName); // Debug log
        // Hide all tab contents
        document.querySelectorAll('.tab-content').forEach(tab => {
            tab.classList.remove('active');
        });

        // Remove active class from all tab buttons
        document.querySelectorAll('.tab-button').forEach(button => {
            button.classList.remove('active');
        });

        // Show the selected tab content
        document.getElementById(tabName).classList.add('active');

        // Add active class to the clicked button
        event.currentTarget.classList.add('active');

        // Reset search when switching tabs
        document.getElementById('searchInput').value = '';
        filterTable();
    }

    // Enhanced filter function for all tables
    function filterTable() {
        const input = document.getElementById('searchInput').value.toLowerCase();
        const activeTab = document.querySelector('.tab-content.active').id;
        const tableId = activeTab === 'users' ? 'userTable' : activeTab === 'food' ? 'foodTable' : activeTab === 'restaurants' ? 'restaurantTable' : 'orderTable';
        const rows = document.querySelectorAll(`#${tableId} tbody tr`);

        rows.forEach(row => {
            let shouldShow = false;
            const cells = row.querySelectorAll('td');

            // Skip action cells and image cells
            for (let i = 0; i < cells.length - 1; i++) {
                if (cells[i].querySelector('img') === null) { // Skip image cells
                    if (cells[i].innerHTML.toLowerCase().includes(input)) {
                        shouldShow = true;
                        break;
                    }
                }
            }

            row.style.display = shouldShow ? '' : 'none';
        });
    }

    // Toggle dropdown menu on click for better mobile support
    document.querySelector('.profile-toggle').addEventListener('click', function () {
        const dropdownMenu = document.querySelector('.dropdown-menu');
        dropdownMenu.classList.toggle('active');
    });

    // Close dropdown when clicking outside
    document.addEventListener('click', function (event) {
        const profileDropdown = document.querySelector('.profile-dropdown');
        if (!profileDropdown.contains(event.target)) {
            document.querySelector('.dropdown-menu').classList.remove('active');
        }
    });
</script>
</body>
</html>