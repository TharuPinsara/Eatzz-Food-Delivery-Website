<%@ page import="java.io.*" %>
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
    <link rel="stylesheet" href="<%= request.getContextPath() %>/AdminPage/AdminCss/StyleDashboard.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/AdminPage/AdminCss/AdminDashboard.css">
</head>
<body>
<div class="dashboard">
    <jsp:include page="/AdminPage/AdminSideBar.jsp"/>

    <main class="main-content">
        <header class="top-bar">
            <h1>Welcome, Admin!</h1>
            <div class="search-bar">
                <input type="text" id="searchInput" placeholder="Search..." onkeyup="filterTable()" />
                <button type="button">🔍</button>
            </div>
            <div class="profile-dropdown">
                <div class="profile-toggle">
                    <span><b><%= session.getAttribute("adminUser") != null ? session.getAttribute("adminUser") : "Admin" %></b></span>
                    <span>▼</span>
                </div>
                <div class="dropdown-menu">
                    <a href="#">Profile</a>
                    <a href="<%= request.getContextPath() %>/LogoutServlet">Logout</a>
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

    // Enhanced filter function for both tables
    function filterTable() {
        const input = document.getElementById('searchInput').value.toLowerCase();
        const activeTab = document.querySelector('.tab-content.active').id;
        const tableId = activeTab === 'users' ? 'userTable' : 'foodTable';
        const rows = document.querySelectorAll(`#${tableId} tbody tr`);

        rows.forEach(row => {
            let shouldShow = false;
            const cells = row.querySelectorAll('td');

            // Skip image cells and action cells
            for (let i = 0; i < cells.length - 1; i++) {
                if (cells[i].querySelector('img') === null) { // Skip image cells
                    if (cells[i].innerText.toLowerCase().includes(input)) {
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