<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add User</title>
    <!-- Link to Add User CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/AdminPage/AdminCss/StyleDashboard.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/AdminPage/AdminCss/AddUser.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Montserrat', sans-serif;
            margin: 0;
            padding: 0;
            color: #333;
            background: url('<%= request.getContextPath() %>/images/AdminBg.jpg') no-repeat center center fixed;
            background-size: cover;
        }

        /* Popup container styling */
        .popup-container {
            position: fixed;
            top: 20px;
            right: 20px;
            background-color: #fff;
            border-left: 6px solid;
            border-radius: 8px;
            padding: 15px 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            z-index: 1000;
            display: none; /* Hidden by default */
            font-family: 'Inter', sans-serif;
            animation: fadeIn 0.5s ease; /* Fade-in animation */
        }

        .popup-container.success {
            border-color: #4CAF50; /* Green for success */
        }

        .popup-container.error {
            border-color: #F44336; /* Red for error */
        }

        .popup-container h4 {
            font-size: 16px;
            margin: 0;
            color: #333;
        }

        .popup-container p {
            font-size: 14px;
            margin: 5px 0 0 0;
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
    </style>
</head>
<body>
<div class="dashboard">
    <jsp:include page="/AdminPage/AdminSideBar.jsp"/>

    <!-- Main Content -->
    <main class="main-content">
        <section class="main-section">
            <!-- Add User Form -->
            <div class="form-container">
                <h2>Add New User Details</h2>

                <form method="POST" action="<%= request.getContextPath() %>/CreateUserServlet" onsubmit="encodeFormData(this)">
                    <label for="username">Username:</label>
                    <input type="text" id="username" name="username" placeholder="Enter username" required>

                    <label for="password">Password:</label>
                    <input type="password" id="password" name="password" placeholder="Enter password" required>

                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" placeholder="Enter a valid email address" required>

                    <label for="phone">Phone Number:</label>
                    <input type="text" id="phone" name="phone" placeholder="Enter a 10-digit phone number" required>

                    <label for="address">Address :</label>
                    <input type="text" id="address" name="address" placeholder="Enter Address" required>

                    <button type="submit">Add User</button>
                </form>

                <!-- Back to Admin Dashboard -->
                <a href="/AdminPage/AdminDashboard.jsp">🔙 Back to Dashboard</a>
            </div>
        </section>
    </main>
</div>

<!-- Popup Element -->
<div id="popupMessage" class="popup-container">
    <button class="close-btn" onclick="closePopup()">×</button>
    <h4 id="popupTitle"></h4>
    <p id="popupBody"></p>
</div>

<script>
    // Trigger popups for success or error messages from URL parameters
    window.addEventListener('load', function() {
        const urlParams = new URLSearchParams(window.location.search);
        const successMessage = urlParams.get('success');
        const errorMessage = urlParams.get('error');

        const popup = document.getElementById('popupMessage');
        const title = document.getElementById('popupTitle');
        const body = document.getElementById('popupBody');

        if (successMessage) {
            title.innerText = 'Success';
            body.innerText = decodeURIComponent(successMessage);
            popup.classList.add('success');
            popup.style.display = 'block';
        } else if (errorMessage) {
            title.innerText = 'Error';
            body.innerText = decodeURIComponent(errorMessage);
            popup.classList.add('error');
            popup.style.display = 'block';
        }
    });

    // Function to close the popup
    function closePopup() {
        const popup = document.getElementById('popupMessage');
        popup.style.display = 'none';
    }

    // Function to encode password and email before form submission
    function encodeFormData(form) {
        const passwordInput = form.querySelector('#password');
        const emailInput = form.querySelector('#email');
        if (passwordInput && emailInput) {
            try {
                passwordInput.value = btoa(passwordInput.value);
                emailInput.value = btoa(emailInput.value);
            } catch (e) {
                console.error('Error encoding form data: ', e);
            }
        }
    }
</script>
</body>
</html>