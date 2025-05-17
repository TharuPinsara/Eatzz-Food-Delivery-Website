<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*,java.util.*,com.example.userlogin.User" %>
<%@ include file="/Header/HeaderBar.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Edit Profile</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/UserProfile/editUserPro.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body>
<div class="profile-container">
  <!-- Popup container -->
  <div class="popup-container">
    <i id="popupIcon" class="fa"></i>
    <h4 id="popupMessage"></h4>
    <button class="close-btn" onclick="this.parentElement.style.display='none';">×</button>
  </div>

  <!-- Left Section: Edit Profile Form -->
  <div class="profile-info-container">
    <h2><i class="fa fa-edit"></i> Edit Profile</h2>
    <%
      String loggedUser = (String) session.getAttribute("username");
      if (loggedUser == null) {
        response.sendRedirect("/index.jsp?error=User%20not%20logged%20in");
        return;
      }

      String filePath = getServletContext().getRealPath("/WEB-INF/users.txt");
      String username = "";
      String password = "";
      String email = "";
      String phone = "";
      String address = "";

      try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
        String line;
        while ((line = reader.readLine()) != null) {
          try {
            User user = User.fromString(line);
            if (user.getUsername().equals(loggedUser)) {
              username = user.getUsername();
              password = user.getPassword(); // Decoded password
              email = user.getEmail(); // Decoded email
              phone = user.getPhone();
              address = user.getAddress();
              break;
            }
          } catch (IllegalArgumentException e) {
            // Skip invalid lines
            continue;
          }
        }
      } catch (IOException e) {
        out.println("<p class='error'><i class='fa fa-exclamation-circle'></i> Error reading users.txt: " + e.getMessage() + "</p>");
      }
    %>
    <form id="editProfileForm" action="<%= request.getContextPath() %>/EditProfileServlet" method="post">
      <input type="hidden" name="originalUsername" value="<%= username %>">
      <div class="form-group">
        <label for="username"><i class="fa fa-user"></i> Username:</label>
        <input type="text" id="username" name="username" value="<%= username %>" required>
      </div>
      <div class="form-group">
        <label for="password"><i class="fa fa-lock"></i> Password:</label>
        <input type="text" id="password" name="password" value="<%= password %>" placeholder="Enter new password (optional)">
      </div>
      <div class="form-group">
        <label for="email"><i class="fa fa-envelope"></i> Email:</label>
        <input type="email" id="email" name="email" value="<%= email %>" required>
      </div>
      <div class="form-group">
        <label for="phone"><i class="fa fa-phone"></i> Phone:</label>
        <input type="tel" id="phone" name="phone" value="<%= phone %>" required>
      </div>
      <div class="form-group">
        <label for="address"><i class="fa fa-map-marker-alt"></i> Address:</label>
        <textarea id="address" name="address" rows="4" required><%= address %></textarea>
      </div>
      <div class="form-buttons">
        <button type="submit" class="btn-submit"><i class="fa fa-save"></i> Save Changes</button>
        <a href="<%= request.getContextPath() %>/UserProfile/profile.jsp" class="btn-cancel"><i class="fa fa-times"></i> Cancel</a>
      </div>
    </form>
    <!-- Separate Delete Form -->
    <form id="deleteProfileForm" action="<%= request.getContextPath() %>/DeleteProfileServlet" method="post" onsubmit="submitDeleteForm(event)">
      <input type="hidden" name="username" value="<%= username %>">
      <button type="submit" class="btn-delete" onclick="return confirmDelete();"><i class="fa fa-trash"></i> Delete Account</button>
    </form>
  </div>

  <!-- Right Section: Profile Card -->
  <div class="profile-card">
    <img src="<%= request.getContextPath() %>/images/User.png" alt="Profile Picture">
    <h3><%= username %></h3>
    <p><i class="fa fa-envelope"></i> <strong>Email:</strong> <%= email %></p>
    <p><i class="fa fa-phone"></i> <strong>Phone:</strong> <%= phone %></p>
    <p><i class="fa fa-map-marker-alt"></i> <strong>Address:</strong> <%= address %></p>
  </div>
</div>
<script>
  function confirmDelete() {
    console.log("Confirm dialog triggered for Delete Account");
    const confirmed = confirm('Are you sure you want to delete your account? This action cannot be undone.');
    console.log("User confirmed deletion: " + confirmed);
    return confirmed;
  }

  function submitDeleteForm(event) {
    console.log("Submitting deleteProfileForm to DeleteProfileServlet");
  }

  function showPopup(type, message) {
    console.log("Showing popup: type=" + type + ", message=" + message);
    const popup = document.querySelector('.popup-container');
    const popupIcon = document.getElementById('popupIcon');
    const popupMessage = document.getElementById('popupMessage');
    popup.classList.add(type);
    popupIcon.className = 'fa ' + (type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle');
    popupMessage.textContent = message;
    popup.style.display = 'block';
    setTimeout(() => {
      popup.style.display = 'none';
      popup.classList.remove(type);
    }, 3000);
  }

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
</body>
</html>