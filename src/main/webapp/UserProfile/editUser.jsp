<%@ page import="java.io.*, java.util.*" %>
<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ include file="/Header/HeaderBar.jsp" %>
<!DOCTYPE html>
<html>
<head>
  <title>Edit Profile</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/UserProfile/editUserPro.css">
  <style>
    .popup-container {
      position: fixed;
      top: 20px;
      right: 20px;
      background-color: #fff;
      border-radius: 8px;
      padding: 15px 20px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
      z-index: 1000;
      display: none;
      font-family: 'Poppins', sans-serif;
      animation: fadeIn 0.5s ease;
    }

    .popup-container.success {
      border-left: 6px solid #4CAF50; /* Green for success */
    }

    .popup-container.error {
      border-left: 6px solid #F44336; /* Red for error */
    }

    .popup-container h4 {
      font-size: 16px;
      margin: 0;
    }

    .popup-container .close-btn {
      position: absolute;
      top: 8px;
      right: 8px;
      border: none;
      background: none;
      font-size: 16px;
      cursor: pointer;
    }

    @keyframes fadeIn {
      from {
        opacity: 0;
      }
      to {
        opacity: 1;
      }
    }

    .btn-cancel {
      background-color: #f44336; /* Red for Cancel */
      color: white;
      border: none;
      padding: 10px 20px;
      text-align: center;
      text-decoration: none;
      display: inline-block;
      font-size: 16px;
      margin: 10px 5px;
      border-radius: 5px;
      cursor: pointer;
    }

    .btn-cancel:hover {
      background-color: #d32f2f; /* Darker red on hover */
    }

    /* Profile Card */
    .profile-card {
      flex: 1; /* Takes up smaller width */
      background: #ffffff;
      border: 2px solid #e3f2fd; /* Subtle blue border */
      border-radius: 20px; /* Rounded corners */
      padding: 30px;
      box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1); /* Add subtle shadow */
      text-align: center; /* Center text and content */
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      transition: transform 0.2s ease-in-out; /* Smooth hover animation */
    }

    .profile-card:hover {
      transform: translateY(-5px); /* Lift the card slightly on hover */
    }

    .profile-card img {
      width: 120px;
      height: 120px;
      border-radius: 50%; /* Circular image */
      border: 3px solid #e0e0e0; /* Subtle border around the image */
      box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
      margin-bottom: 20px;
      object-fit: cover; /* Ensure the image is centered and covers */
    }

    .profile-card h3 {
      font-size: 20px;
      color: #333;
      margin: 10px 0;
    }

    .profile-card p {
      font-size: 14px;
      color: #666;
      margin: 5px 0;
    }

  </style>
  <script>
    // Function to show popup message
    function showPopup(type, message) {
      const popup = document.querySelector('.popup-container');
      popup.classList.add(type); // Add success or error class
      popup.querySelector('h4').textContent = message; // Set the message text
      popup.style.display = 'block'; // Show popup

      // Auto-hide popup after 3 seconds
      setTimeout(() => {
        popup.style.display = 'none';
        popup.classList.remove(type);
      }, 3000);
    }

    // Check if message or error passed from backend
    document.addEventListener("DOMContentLoaded", () => {
      const message = "<%= request.getAttribute("message") != null ? request.getAttribute("message") : "" %>";
      const error = "<%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %>";

      if (message) {
        showPopup("success", message);
      } else if (error) {
        showPopup("error", error);
      }
    });
  </script>
</head>
<body>
<div class="profile-container">
  <!-- Popup container -->
  <div class="popup-container">
    <button class="close-btn" onclick="this.parentElement.style.display='none';">&times;</button>
    <h4></h4>
  </div>

  <!-- Left Section: Edit Profile Form -->
  <div class="profile-info-container">
    <h2>Edit Profile</h2>
    <%
      // Path to users.txt
      String filePath = getServletContext().getRealPath("/WEB-INF/users.txt");

      // Get logged-in username from the session
      String loggedUser = (String) session.getAttribute("username");

      if (loggedUser == null) {
        response.sendRedirect("index.jsp?error=User%20not%20logged%20in");
        return;
      }

      // Initialize user details
      String username = "";
      String email = "";
      String phone = "";
      String address = "";

      // Read users.txt to fetch the user details
      try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
        String line;
        while ((line = reader.readLine()) != null) {
          String[] userDetails = line.split(",");
          if (userDetails[0].equals(loggedUser)) {
            username = userDetails[0].trim();
            email = userDetails[2].trim();
            phone = userDetails[3].trim();
            address = userDetails[4].trim();
            break;
          }
        }
      } catch (IOException e) {
        out.println("<p>Error reading users.txt: " + e.getMessage() + "</p>");
      }
    %>
    <form action="<%= request.getContextPath() %>/EditProfileServlet" method="post">
      <input type="hidden" name="originalUsername" value="<%= username %>">

      <div class="form-group">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" value="<%= username %>" required>
      </div>

      <div class="form-group">
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" value="<%= email %>" required>
      </div>

      <div class="form-group">
        <label for="phone">Phone:</label>
        <input type="tel" id="phone" name="phone" value="<%= phone %>" required>
      </div>

      <div class="form-group">
        <label for="address">Address:</label>
        <textarea id="address" name="address" rows="4" required><%= address %></textarea>
      </div>

      <button type="submit" class="btn-submit">Save Changes</button>
      <a href="<%= request.getContextPath() %>/UserProfile/profile.jsp" class="btn-cancel">Cancel</a>
    </form>
  </div>

  <!-- Right Section: Profile Card -->
  <div class="profile-card">
    <!-- Profile picture -->
    <img src="<%= request.getContextPath() %>/images/User.png" alt="Profile Picture">
    <!-- User details -->
    <h3><%= username %></h3>
    <p><strong>Email:</strong> <%= email %></p>
    <p><strong>Phone:</strong> <%= phone %></p>
    <p><strong>Address:</strong> <%= address %></p>
  </div>
</div>
</body>
</html>