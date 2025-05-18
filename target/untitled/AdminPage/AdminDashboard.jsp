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
    <link rel="stylesheet" href="<%= request.getContextPath() %>/AdminPage/StyleDashboard.css">
    <style>
        /* Popup container styling (preserved) */
        .popup-container {
            position: fixed;
            top: 20px;
            right: 20px;
            background-color: #fff;
            border-radius: 8px;
            padding: 15px 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            z-index: 1000;
            display: none; /* Hidden by default */
            font-family: 'Montserrat Medium', sans-serif;
            transition: all 0.3s ease;
            animation: fadeIn 0.5s ease; /* Smooth fade-in animation */
        }

        .popup-container.success {
            border-left: 6px solid #4CAF50; /* Green success indicator */
        }

        .popup-container.error {
            border-left: 6px solid #F44336; /* Red error indicator */
        }

        .popup-container h4 {
            font-size: 16px;
            margin: 0 0 5px 0;
            color: #333;
        }

        .popup-container p {
            font-size: 14px;
            margin: 0;
            color: #555;
        }

        .popup-container .close-btn {
            background: none;
            border: none;
            font-size: 16px;
            color: #999;
            cursor: pointer;
            position: absolute;
            top: 10px;
            right: 10px;
            transition: color 0.3s;
        }

        .popup-container .close-btn:hover {
            color: #333;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-15px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Enhanced user table styles */
        .user-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            font-family: 'Montserrat', sans-serif;
            background-color: #ffffff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        .user-table th,
        .user-table td {
            padding: 15px 20px;
            text-align: left;
        }

        .user-table th {
            background-color: #f4f4f9;
            color: #333;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 14px;
            border-bottom: 2px solid #ddd;
        }

        .user-table tbody tr {
            transition: background-color 0.3s ease;
        }

        .user-table tbody tr:nth-child(even) {
            background-color: #f9f9f9; /* Striped effect */
        }

        .user-table tbody tr:hover {
            background-color: #e8f0ff;
            cursor: pointer;
        }

        /* Action buttons inside the table */
        .action-form button {
            padding: 8px 12px;
            font-size: 14px;
            font-family: 'Montserrat Medium', sans-serif;
            border: none;
            border-radius: 5px;
            transition: all 0.3s ease;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            box-shadow: 0 3px 5px rgba(0, 0, 0, 0.1);
            text-transform: uppercase;
            gap: 5px;
        }

        .action-form button.edit-btn {
            background-color: #4caf50;
            color: white;
        }

        .action-form button.edit-btn:hover {
            background-color: #43a047;
        }

        .action-form button.delete-btn {
            background-color: #e53935; /* Red */
            color: white;
        }

        .action-form button.delete-btn:hover {
            background-color: #d32f2f; /* Darker red */
        }

        /* Responsive adjustments for smaller screens */
        @media only screen and (max-width: 768px) {
            .user-table {
                display: block;
                overflow-x: auto;
                white-space: nowrap;
            }

            .user-table th,
            .user-table td {
                padding: 10px;
            }

            .action-form button {
                font-size: 12px;
                padding: 6px 10px;
            }
        }
    </style>
</head>
<body>
<div class="dashboard">

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-logo">
            <img src="<%= request.getContextPath() %>/AdminPage/Eatzz.png" alt="Eatzz Logo" class="logo-image">
        </div>
        <nav>
            <ul>
                <li><a href="/AdminPage/AdminDashboard.jsp" class="active">🏠 Home</a></li>
                <li><a href="/AdminPage/AddUser.jsp">👤 Add User</a></li>
                <li><a href="#">📊 Charts</a></li>
                <li><a href="#">⚙️ Settings</a></li>
            </ul>
        </nav>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <header class="top-bar">
            <h1>Welcome, Admin!</h1>

            <!-- Search Bar -->
            <div class="search-bar">
                <input type="text" id="searchInput" placeholder="Search for users..." onkeyup="filterTable()" />
                <button type="button">🔍</button>
            </div>
            <div class="profile-dropdown">
                <span><b><%= session.getAttribute("adminUser") != null ? session.getAttribute("adminUser") : "Admin" %></b></span>
                <a href="<%= request.getContextPath() %>/LogoutServlet">(Logout)</a>
            </div>
        </header>

        <section class="main-section">
            <!-- Dynamic Popups -->
            <div id="popupMessage" class="popup-container">
                <button class="close-btn" onclick="closePopup()">×</button>
                <h4 id="popupTitle"></h4>
                <p id="popupBody"></p>
            </div>

            <h2>User Management</h2>

            <!-- Enhanced User Table -->
            <table id="userTable" class="user-table">
                <thead>
                <tr>
                    <th>Username</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <%
                    // Code to fetch user data from users.txt
                    String filePath = application.getRealPath("WEB-INF/users.txt");
                    File usersFile = new File(filePath);
                    if (usersFile.exists() && usersFile.canRead()) {
                        try (BufferedReader br = new BufferedReader(new FileReader(usersFile))) {
                            String line;
                            while ((line = br.readLine()) != null) {
                                String[] userDetails = line.split(",");
                                String username = userDetails.length > 0 ? userDetails[0] : "N/A";
                                String email = userDetails.length > 2 ? userDetails[2] : "N/A";
                                String phone = userDetails.length > 3 ? userDetails[3] : "N/A";
                %>
                <tr>
                    <td><%= username %></td>
                    <td><%= email %></td>
                    <td><%= phone %></td>
                    <td>
                        <div class="action-form">
                            <form method="GET" action="<%= request.getContextPath() %>/EditUserServlet">
                                <input type="hidden" name="username" value="<%= username %>">
                                <button type="submit" class="edit-btn">Edit</button>
                            </form>
                            <form method="POST" action="<%= request.getContextPath() %>/DeleteUserServlet">
                                <input type="hidden" name="username" value="<%= username %>">
                                <button type="submit" class="delete-btn">Delete</button>
                            </form>
                        </div>
                    </td>
                </tr>
                <%      }
                } catch (IOException e) {
                    out.println("<tr><td colspan='4'>Error reading users file.</td></tr>");
                }
                } else {
                    out.println("<tr><td colspan='4'>No user data available.</td></tr>");
                }
                %>
                </tbody>
            </table>
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

    // Filter rows in the user table based on search input
    function filterTable() {
        const input = document.getElementById('searchInput').value.toLowerCase();
        const rows = document.querySelectorAll('#userTable tbody tr');

        rows.forEach(row => {
            const username = row.cells[0].innerText.toLowerCase();
            const email = row.cells[2].innerText.toLowerCase();
            const phone = row.cells[3].innerText.toLowerCase();

            if (username.includes(input) || email.includes(input) || phone.includes(input)) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }
</script>
</body>
</html>