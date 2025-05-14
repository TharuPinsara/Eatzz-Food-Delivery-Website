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
                <button class="tab-button" onclick="openTab('payments')">Payment Management</button>
                <button class="tab-button" onclick="openTab('delivery')">Delivery Management</button>
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
                                    <input type="hidden" name="tab" value="users">
                                    <button type="submit" class="edit-btn">Edit</button>
                                </form>
                                <form method="POST" action="<%= request.getContextPath() %>/DeleteUserServlet">
                                    <input type="hidden" name="username" value="<%= userDetails[0] %>">
                                    <input type="hidden" name="tab" value="users">
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
                                    <input type="hidden" name="tab" value="food">
                                    <button type="submit" class="edit-btn">Edit</button>
                                </form>
                                <form method="POST" action="<%= request.getContextPath() %>/DeleteFoodItemServlet">
                                    <input type="hidden" name="name" value="<%= foodDetails[0].trim() %>">
                                    <input type="hidden" name="tab" value="food">
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
                                    <input type="hidden" name="tab" value="restaurants">
                                    <button type="submit" class="edit-btn">Edit</button>
                                </form>
                                <form method="POST" action="<%= request.getContextPath() %>/DeleteRestaurantServlet">
                                    <input type="hidden" name="name" value="<%= r.getName() %>">
                                    <input type="hidden" name="tab" value="restaurants">
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
                                    <input type="hidden" name="tab" value="orders">
                                    <button type="submit" class="view-btn">View Details</button>
                                </form>
                                <form method="POST" action="<%= request.getContextPath() %>/DeleteOrderServlet">
                                    <input type="hidden" name="orderId" value="<%= orderDetails[0] %>">
                                    <input type="hidden" name="tab" value="orders">
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

            <!-- Payment Management Tab -->
            <div id="payments" class="tab-content">
                <h2>Payment Management</h2>
                <table id="paymentTable" class="payment-table">
                    <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Store Name</th>
                        <th>Total Price (LKR)</th>
                        <th>Website Commission (LKR)</th>
                        <th>Store Payment</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        String paymentHistoryFilePath = application.getRealPath("/") + "WEB-INF/payment_history.txt";
                        File paymentHistoryFile = new File(paymentHistoryFilePath);
                        boolean paymentFileExists = paymentHistoryFile.exists();

                        if (!paymentFileExists) {
                            paymentHistoryFile.getParentFile().mkdirs();
                            paymentHistoryFile.createNewFile();
                        }

                        if (paymentHistoryFile.canRead()) {
                            try (BufferedReader historyReader = new BufferedReader(new FileReader(paymentHistoryFile))) {
                                String historyLine;
                                boolean hasData = false;
                                while ((historyLine = historyReader.readLine()) != null) {
                                    String[] paymentDetails = historyLine.split(",");
                                    if (paymentDetails.length >= 6) {
                                        String orderId = paymentDetails[0];
                                        String storeName = paymentDetails[1];
                                        String totalPrice = paymentDetails[2];
                                        String commission = paymentDetails[3];
                                        String storePayment = paymentDetails[4];
                                        String date = paymentDetails[5];
                                        String status = paymentDetails.length > 6 ? paymentDetails[6] : "Pending";
                                        hasData = true;
                    %>
                    <tr>
                        <td><%= orderId %></td>
                        <td><%= storeName %></td>
                        <td><%= totalPrice %></td>
                        <td><%= commission %></td>
                        <td><%= storePayment %></td>
                        <td><%= date %></td>
                        <td><%= status %></td>
                        <td>
                            <div class="action-form">
                                <% if (!"Approved".equals(status) && !"Processed".equals(status)) { %>
                                <form method="POST" action="<%= request.getContextPath() %>/ApprovePaymentServlet">
                                    <input type="hidden" name="orderId" value="<%= orderId %>">
                                    <input type="hidden" name="tab" value="payments">
                                    <button type="submit" class="view-btn">Approve</button>
                                </form>
                                <% } %>
                                <% if ("Approved".equals(status) && !"Processed".equals(status)) { %>
                                <form method="POST" action="<%= request.getContextPath() %>/MarkProcessedPaymentServlet">
                                    <input type="hidden" name="orderId" value="<%= orderId %>">
                                    <input type="hidden" name="tab" value="payments">
                                    <button type="submit" class="view-btn">Mark Processed</button>
                                </form>
                                <% } %>
                                <form method="GET" action="<%= request.getContextPath() %>/EditPaymentServlet">
                                    <input type="hidden" name="orderId" value="<%= orderId %>">
                                    <input type="hidden" name="tab" value="payments">
                                    <button type="submit" class="edit-btn">Edit</button>
                                </form>
                                <form method="GET" action="<%= request.getContextPath() %>/GeneratePaymentReportServlet">
                                    <input type="hidden" name="orderId" value="<%= orderId %>">
                                    <input type="hidden" name="tab" value="payments">
                                    <button type="submit" class="view-btn">Generate Report</button>
                                </form>
                                <form method="POST" action="<%= request.getContextPath() %>/DeletePaymentServlet">
                                    <input type="hidden" name="orderId" value="<%= orderId %>">
                                    <input type="hidden" name="tab" value="payments">
                                    <button type="submit" class="delete-btn">Delete</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <%
                            }
                        }

                        String orderFilePathPayment = application.getRealPath("/") + "WEB-INF/orders/order_history.txt";
                        File orderFilePayment = new File(orderFilePathPayment);

                        if (orderFilePayment.exists() && orderFilePayment.canRead()) {
                            try (BufferedReader orderReader = new BufferedReader(new FileReader(orderFilePayment));
                                 BufferedWriter bw = new BufferedWriter(new FileWriter(paymentHistoryFile, true))) {
                                String orderLine;
                                while ((orderLine = orderReader.readLine()) != null) {
                                    String[] orderDetails = orderLine.split(",", -1);
                                    if (orderDetails.length >= 8 && "Payment Completed".equals(orderDetails[6])) {
                                        String orderId = orderDetails[0];
                                        boolean paymentExists = false;
                                        try (BufferedReader existingReader = new BufferedReader(new FileReader(paymentHistoryFile))) {
                                            String existingLine;
                                            while ((existingLine = existingReader.readLine()) != null) {
                                                if (existingLine.startsWith(orderId + ",")) {
                                                    paymentExists = true;
                                                    break;
                                                }
                                            }
                                        }
                                        if (!paymentExists) {
                                            String items = orderDetails[7];
                                            String storeName = "Unknown";
                                            if (!items.isEmpty()) {
                                                String[] itemList = items.split(";");
                                                if (itemList.length > 0) {
                                                    String[] firstItemDetails = itemList[0].split("\\|", -1);
                                                    if (firstItemDetails.length >= 4) {
                                                        storeName = firstItemDetails[1];
                                                    }
                                                }
                                            }

                                            double totalPrice = Double.parseDouble(orderDetails[4]);
                                            double commission = totalPrice * 0.10;
                                            double storePayment = totalPrice - commission;
                                            String date = orderDetails[5];
                                            String newPaymentRecord = String.format("%s,%s,%.2f,%.2f,%.2f,%s,Pending",
                                                    orderId, storeName, totalPrice, commission, storePayment, date);
                                            bw.write(newPaymentRecord);
                                            bw.newLine();
                                            hasData = true;
                    %>
                    <tr>
                        <td><%= orderId %></td>
                        <td><%= storeName %></td>
                        <td><%= String.format("%.2f", totalPrice) %></td>
                        <td><%= String.format("%.2f", commission) %></td>
                        <td><%= String.format("%.2f", storePayment) %></td>
                        <td><%= date %></td>
                        <td>Pending</td>
                        <td>
                            <div class="action-form">
                                <form method="POST" action="<%= request.getContextPath() %>/ApprovePaymentServlet">
                                    <input type="hidden" name="orderId" value="<%= orderId %>">
                                    <input type="hidden" name="tab" value="payments">
                                    <button type="submit" class="view-btn">Approve</button>
                                </form>
                                <form method="GET" action="<%= request.getContextPath() %>/EditPaymentServlet">
                                    <input type="hidden" name="orderId" value="<%= orderId %>">
                                    <input type="hidden" name="tab" value="payments">
                                    <button type="submit" class="edit-btn">Edit</button>
                                </form>
                                <form method="GET" action="<%= request.getContextPath() %>/GeneratePaymentReportServlet">
                                    <input type="hidden" name="orderId" value="<%= orderId %>">
                                    <input type="hidden" name="tab" value="payments">
                                    <button type="submit" class="view-btn">Generate Report</button>
                                </form>
                                <form method="POST" action="<%= request.getContextPath() %>/DeletePaymentServlet">
                                    <input type="hidden" name="orderId" value="<%= orderId %>">
                                    <input type="hidden" name="tab" value="payments">
                                    <button type="submit" class="delete-btn">Delete</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <%
                                                }
                                            }
                                        }
                                    } catch (IOException e) {
                                        out.println("<tr><td colspan='8'>Error processing new payments: " + e.getMessage() + "</td></tr>");
                                    }
                                } else {
                                    out.println("<tr><td colspan='8'>Order file not found or unreadable</td></tr>");
                                }

                                if (!hasData) {
                                    out.println("<tr><td colspan='8'>No payment records found</td></tr>");
                                }
                            } catch (IOException e) {
                                out.println("<tr><td colspan='8'>Error reading payment history: " + e.getMessage() + "</td></tr>");
                            }
                        } else {
                            out.println("<tr><td colspan='8'>No permission to read payment history file</td></tr>");
                        }
                    %>
                    </tbody>
                </table>
            </div>

            <!-- Delivery Management Tab -->
            <div id="delivery" class="tab-content">
                <h2>Delivery Management</h2>
                <table id="deliveryTable" class="delivery-table">
                    <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Username</th>
                        <th>Address</th>
                        <th>Total Price (LKR)</th>
                        <th>Date</th>
                        <th>Delivery Partner</th>
                        <th>Delivery Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        String deliveryFilePath = application.getRealPath("/") + "WEB-INF/delivery_details.txt";
                        File deliveryFile = new File(deliveryFilePath);
                        boolean deliveryFileExists = deliveryFile.exists();

                        if (!deliveryFileExists) {
                            deliveryFile.getParentFile().mkdirs();
                            deliveryFile.createNewFile();
                        }

                        String orderFilePathDelivery = application.getRealPath("/") + "WEB-INF/orders/order_history.txt";
                        File orderFileDelivery = new File(orderFilePathDelivery);

                        if (orderFileDelivery.exists() && orderFileDelivery.canRead()) {
                            try (BufferedReader orderReader = new BufferedReader(new FileReader(orderFileDelivery))) {
                                String orderLine;
                                boolean hasData = false;

                                while ((orderLine = orderReader.readLine()) != null) {
                                    String[] orderDetails = orderLine.split(",", -1);
                                    if (orderDetails.length >= 8 && "Payment Completed".equals(orderDetails[6])) {
                                        String orderId = orderDetails[0];
                                        String deliveryPartner = "Not Assigned";
                                        String deliveryStatus = "Processing";
                                        boolean deliveryExists = false;

                                        // Check if delivery details exist
                                        if (deliveryFile.canRead()) {
                                            try (BufferedReader deliveryReader = new BufferedReader(new FileReader(deliveryFile))) {
                                                String deliveryLine;
                                                while ((deliveryLine = deliveryReader.readLine()) != null) {
                                                    String[] deliveryDetails = deliveryLine.split(",");
                                                    if (deliveryDetails.length >= 3 && deliveryDetails[0].equals(orderId)) {
                                                        deliveryPartner = deliveryDetails[1];
                                                        deliveryStatus = deliveryDetails[2];
                                                        deliveryExists = true;
                                                        break;
                                                    }
                                                }
                                            }
                                        }

                                        hasData = true;
                    %>
                    <tr>
                        <td><%= orderDetails[0] %></td>
                        <td><%= orderDetails[1] %></td>
                        <td><%= orderDetails[3] %></td>
                        <td><%= orderDetails[4] %></td>
                        <td><%= orderDetails[5] %></td>
                        <td>
                            <form method="POST" action="<%= request.getContextPath() %>/UpdateDeliveryServlet">
                                <input type="hidden" name="orderId" value="<%= orderDetails[0] %>">
                                <input type="hidden" name="tab" value="delivery">
                                <select name="deliveryPartner" onchange="this.form.submit()">
                                    <option value="Not Assigned" <%= "Not Assigned".equals(deliveryPartner) ? "selected" : "" %>>Not Assigned</option>
                                    <option value="Daraz" <%= "Daraz".equals(deliveryPartner) ? "selected" : "" %>>Daraz</option>
                                    <option value="FedEx" <%= "FedEx".equals(deliveryPartner) ? "selected" : "" %>>FedEx</option>
                                    <option value="DHL" <%= "DHL".equals(deliveryPartner) ? "selected" : "" %>>DHL</option>
                                    <option value="Sri Lanka Post" <%= "Sri Lanka Post".equals(deliveryPartner) ? "selected" : "" %>>Sri Lanka Post</option>
                                    <option value="PickMe" <%= "PickMe".equals(deliveryPartner) ? "selected" : "" %>>PickMe</option>
                                    <option value="Uber Delivery" <%= "Uber Delivery".equals(deliveryPartner) ? "selected" : "" %>>Uber Delivery</option>
                                </select>
                            </form>
                        </td>
                        <td>
                            <form method="POST" action="<%= request.getContextPath() %>/UpdateDeliveryServlet">
                                <input type="hidden" name="orderId" value="<%= orderDetails[0] %>">
                                <input type="hidden" name="tab" value="delivery">
                                <select name="deliveryStatus" onchange="this.form.submit()">
                                    <option value="Processing" <%= "Processing".equals(deliveryStatus) ? "selected" : "" %>>Processing</option>
                                    <option value="On the Way" <%= "On the Way".equals(deliveryStatus) ? "selected" : "" %>>On the Way</option>
                                    <option value="Shipped" <%= "Shipped".equals(deliveryStatus) ? "selected" : "" %>>Shipped</option>
                                </select>
                            </form>
                        </td>
                        <td>
                            <div class="action-form">
                                <form method="POST" action="<%= request.getContextPath() %>/DeleteDeliveryServlet">
                                    <input type="hidden" name="orderId" value="<%= orderDetails[0] %>">
                                    <input type="hidden" name="tab" value="delivery">
                                    <button type="submit" class="delete-btn">Delete</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <%
                                    }
                                }

                                if (!hasData) {
                                    out.println("<tr><td colspan='8'>No delivery-eligible orders found</td></tr>");
                                }
                            } catch (IOException e) {
                                out.println("<tr><td colspan='8'>Error reading orders file: " + e.getMessage() + "</td></tr>");
                            }
                        } else {
                            out.println("<tr><td colspan='8'>Order file not found at: " + orderFilePathDelivery + "</td></tr>");
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</div>

<script>
    // Activate tab based on URL parameter or current active tab
    window.addEventListener('load', function () {
        const urlParams = new URLSearchParams(window.location.search);
        const tab = urlParams.get('tab');
        const successMessage = urlParams.get('success');
        const errorMessage = urlParams.get('error');
        const validTabs = ['users', 'food', 'restaurants', 'orders', 'payments', 'delivery'];

        // Determine which tab to activate
        let tabToOpen = 'users'; // Default for initial load without tab parameter
        if (tab && validTabs.includes(tab)) {
            tabToOpen = tab;
        } else {
            // Check if there's an already active tab (e.g., after popup or form submission)
            const activeTab = document.querySelector('.tab-content.active');
            if (activeTab && validTabs.includes(activeTab.id)) {
                tabToOpen = activeTab.id;
            }
        }

        // Activate the determined tab
        openTab(tabToOpen);

        // Handle dynamic popups for success/error messages
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
                case 'paymentEdited':
                    title.innerText = 'Payment Edited';
                    body.innerText = 'The payment commission has been successfully updated.';
                    break;
                case 'paymentDeleted':
                    title.innerText = 'Payment Deleted';
                    body.innerText = 'The payment record has been successfully removed.';
                    break;
                case 'paymentApproved':
                    title.innerText = 'Payment Approved';
                    body.innerText = 'The payment has been successfully approved.';
                    break;
                case 'reportGenerated':
                    title.innerText = 'Report Generated';
                    body.innerText = 'The payment report has been successfully generated.';
                    break;
                case 'paymentProcessed':
                    title.innerText = 'Payment Processed';
                    body.innerText = 'The payment has been marked as processed.';
                    break;
                case 'deliveryUpdated':
                    title.innerText = 'Delivery Updated';
                    body.innerText = 'The delivery details have been successfully updated.';
                    break;
                case 'deliveryDeleted':
                    title.innerText = 'Delivery Deleted';
                    body.innerText = 'The delivery record has been successfully removed.';
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
        document.querySelectorAll('.tab-content').forEach(tab => { tab.classList.remove('active'); });
        document.querySelectorAll('.tab-button').forEach(button => { button.classList.remove('active'); });
        const tabElement = document.getElementById(tabName);
        if (tabElement) {
            tabElement.classList.add('active');
            const button = document.querySelector(`button[onclick="openTab('${tabName}')"]`);
            if (button) {
                button.classList.add('active');
            }
        }
        document.getElementById('searchInput').value = '';
        filterTable();
    }

    // Enhanced filter function for all tables
    function filterTable() {
        const input = document.getElementById('searchInput').value.toLowerCase();
        const activeTab = document.querySelector('.tab-content.active').id;
        const tableId = activeTab === 'users' ? 'userTable' :
            activeTab === 'food' ? 'foodTable' :
                activeTab === 'restaurants' ? 'restaurantTable' :
                    activeTab === 'orders' ? 'orderTable' :
                        activeTab === 'payments' ? 'paymentTable' : 'deliveryTable';
        const rows = document.querySelectorAll(`#${tableId} tbody tr`);

        rows.forEach(row => {
            let shouldShow = false;
            const cells = row.querySelectorAll('td');
            for (let i = 0; i < cells.length - 1; i++) {
                if (cells[i].querySelector('img') === null && cells[i].querySelector('select') === null) {
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