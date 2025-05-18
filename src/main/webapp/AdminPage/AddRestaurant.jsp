<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% if (session.getAttribute("adminUser") == null) {
    response.sendRedirect("/AdminPage/admin_login.jsp");
    return;
} %>
<html>
<head>
    <title>Add Restaurant</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/AdminPage/AdminCss/AddRes.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/AdminPage/AdminCss/StyleDashboard.css">
</head>
<body>
<jsp:include page="/AdminPage/AdminSideBar.jsp"/>
<div class="content">
    <h1>Add Restaurant</h1>
    <div class="popup-container">
        <button class="close-btn" onclick="this.parentElement.style.display='none';">×</button>
        <h4></h4>
    </div>
    <form id="addRestaurantForm" action="<%= request.getContextPath() %>/StoreAdminRegisterServlet" method="post" onsubmit="showLoading(event)">
        <div class="form-group">
            <label for="username">Admin Username:</label>
            <input type="text" id="username" name="username" required oninput="validateInput(this, 'username')">
        </div>
        <div class="form-group">
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required oninput="validatePassword(this)">
            <div class="password-strength" id="passwordStrength">Password strength: None</div>
        </div>
        <div class="form-group">
            <label for="storeName">Restaurant Name:</label>
            <input type="text" id="storeName" name="storeName" required oninput="validateInput(this, 'storeName')">
        </div>
        <div class="form-group">
            <label for="address">Address:</label>
            <input type="text" id="address" name="address" required oninput="validateInput(this, 'address')">
        </div>
        <div class="form-group">
            <label for="phoneNumber">Phone Number:</label>
            <input type="text" id="phoneNumber" name="phoneNumber" required oninput="validatePhoneNumber(this)">
        </div>
        <div class="button-group">
            <button type="submit" class="submit-btn">Add Restaurant<span class="spinner" style="display: none;"></span></button>
            <button type="button" class="reset-btn" onclick="resetForm()">Reset</button>
        </div>
    </form>
</div>
<script>
    // Real-time input validation
    function validateInput(input, field) {
        const value = input.value.trim();
        let isValid = false;
        if (field === 'username' || field === 'storeName' || field === 'address') {
            isValid = value.length > 0;
        }
        input.classList.toggle('valid', isValid);
        input.classList.toggle('invalid', !isValid);
    }

    function validatePassword(input) {
        const value = input.value;
        const strengthText = document.getElementById('passwordStrength');
        let strength = 'None';
        let isValid = false;

        if (value.length >= 8) {
            isValid = true;
            if (/[A-Z]/.test(value) && /[0-9]/.test(value) && /[^A-Za-z0-9]/.test(value)) {
                strength = 'Strong';
                strengthText.classList.add('strong');
                strengthText.classList.remove('medium', 'weak');
            } else if (/[A-Z]/.test(value) || /[0-9]/.test(value)) {
                strength = 'Medium';
                strengthText.classList.add('medium');
                strengthText.classList.remove('strong', 'weak');
            } else {
                strength = 'Weak';
                strengthText.classList.add('weak');
                strengthText.classList.remove('strong', 'medium');
            }
        } else {
            strengthText.classList.add('weak');
            strengthText.classList.remove('strong', 'medium');
        }

        strengthText.textContent = `Password strength: ${strength}`;
        input.classList.toggle('valid', isValid);
        input.classList.toggle('invalid', !isValid);
    }

    function validatePhoneNumber(input) {
        const value = input.value.trim();
        const isValid = /^\d{10}$/.test(value); // Example: 10-digit phone number
        input.classList.toggle('valid', isValid);
        input.classList.toggle('invalid', !isValid);
    }

    // Show loading spinner
    function showLoading(event) {
        const submitBtn = document.querySelector('.submit-btn');
        const spinner = submitBtn.querySelector('.spinner');
        spinner.style.display = 'inline-block';
        submitBtn.disabled = true;
        // Simulate async submission (replace with AJAX if needed)
        setTimeout(() => {
            submitBtn.disabled = false;
            spinner.style.display = 'none';
        }, 2000);
    }

    // Show popup message
    function showPopup(type, message) {
        const popup = document.querySelector('.popup-container');
        popup.classList.add(type);
        popup.querySelector('h4').textContent = message;
        popup.style.display = 'block';
        setTimeout(() => {
            popup.style.display = 'none';
            popup.classList.remove(type);
        }, 3000);
    }

    // Reset form
    function resetForm() {
        const form = document.getElementById('addRestaurantForm');
        form.reset();
        const inputs = form.querySelectorAll('input');
        inputs.forEach(input => {
            input.classList.remove('valid', 'invalid');
        });
        const strengthText = document.getElementById('passwordStrength');
        strengthText.textContent = 'Password strength: None';
        strengthText.classList.remove('strong', 'medium', 'weak');
    }

    // Check for backend messages
    document.addEventListener("DOMContentLoaded", () => {
        const error = "<%= request.getParameter("error") != null ? request.getParameter("error") : "" %>";
        const success = "<%= request.getParameter("success") != null ? request.getParameter("success") : "" %>";
        if (error) {
            let message = "Failed to add restaurant.";
            if (error === "duplicate") message = "Restaurant name already exists.";
            else if (error === "invalid") message = "Please fill all fields correctly.";
            showPopup("error", message);
        } else if (success) {
            showPopup("success", "Restaurant added successfully!");
        }
    });
</script>
</body>
</html>