package com.example.userlogin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.*;
import java.util.regex.Pattern;
import java.util.Base64;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    // Regex for valid email format (any domain allowed)
    private static final Pattern EMAIL_REGEX = Pattern.compile("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$");

    // Regex for phone number validation (exactly 10 digits)
    private static final Pattern PHONE_REGEX = Pattern.compile("^[0-9]{10}$");

    // Path to the file where user credentials will be stored
    private static final String USER_FILE = "WEB-INF/users.txt";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve registration details from the form
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // Validate email and phone number
        if (!isValidEmail(email) || !isValidPhone(phone)) {
            response.sendRedirect("register.jsp?error=Invalid email or phone number.");
            return;
        }

        // Check if the username already exists
        if (isUserExists(username)) {
            response.sendRedirect("register.jsp?error=User already exists. Try a different username.");
            return;
        }

        // Save user data to the file with encoded password and email
        saveUserToFile(username, password, email, phone, address);

        // Create a session and log the user in automatically
        HttpSession session = request.getSession();
        session.setAttribute("username", username);
        session.setAttribute("email", email);
        session.setAttribute("phone", phone);
        session.setAttribute("address", address);

        // Redirect to the cart page (or any other logged-in user page)
        response.sendRedirect("/HomePage/");
    }

    // Helper method to validate email with regex
    private boolean isValidEmail(String email) {
        return EMAIL_REGEX.matcher(email).matches();
    }

    // Helper method to validate phone numbers with regex
    private boolean isValidPhone(String phone) {
        return PHONE_REGEX.matcher(phone).matches();
    }

    // Check if the user already exists by reading the file
    private boolean isUserExists(String username) throws IOException {
        String absolutePath = getServletContext().getRealPath(USER_FILE);
        try (BufferedReader reader = new BufferedReader(new FileReader(absolutePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] userDetails = line.split(",", -1);
                if (userDetails.length >= 1 && userDetails[0].trim().equalsIgnoreCase(username)) {
                    return true; // Username already exists
                }
            }
        }
        return false;
    }

    // Save user credentials (username, password, email, phone, address) to the file
    private void saveUserToFile(String username, String password, String email, String phone, String address) throws IOException {
        String absolutePath = getServletContext().getRealPath(USER_FILE);
        File file = new File(absolutePath);
        file.getParentFile().mkdirs();

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file, true))) {
            String encodedPassword = Base64.getEncoder().encodeToString(password.getBytes());
            String encodedEmail = Base64.getEncoder().encodeToString(email.getBytes());
            writer.write(username + "," + encodedPassword + "," + encodedEmail + "," + phone + "," + address);
            writer.newLine();
        }
    }
}