package com.example;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.*;
import java.util.regex.Pattern;

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
        // Retrieve parameters from the form
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        // Debug: Log received input
        System.out.println("Received username: " + username);
        System.out.println("Received password: " + password);

        // Validation for empty fields
        if (username == null || username.isEmpty() ||
                password == null || password.isEmpty() ||
                email == null || email.isEmpty() ||
                phone == null || phone.isEmpty()) {
            response.sendRedirect("register.jsp?error=Please%20fill%20all%20fields");
            return;
        }

        // Validate email format
        if (!isValidEmail(email)) {
            response.sendRedirect("register.jsp?error=Invalid%20email%20address");
            return;
        }

        // Validate phone number format (exactly 10 digits)
        if (!isValidPhone(phone)) {
            response.sendRedirect("register.jsp?error=Phone%20number%20must%20be%2010%20digits%20long");
            return;
        }

        // Check if user already exists
        System.out.println("Checking if user exists...");
        if (isUserExists(username)) {
            System.out.println("User exists: " + username);
            response.sendRedirect("register.jsp?error=User%20already%20exists");
            return;
        }

        // Save the user credentials to the file
        System.out.println("Saving user to file...");
        saveUserToFile(username, password);

        // Debug: Confirm user saved
        System.out.println("User saved successfully. Username: " + username);

        // Redirect to register.jsp with a success parameter
        response.sendRedirect("register.jsp?success=Account%20created%20successfully");
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
        File file = new File(getServletContext().getRealPath(USER_FILE));
        if (!file.exists()) {
            return false; // If file does not exist, no user exists yet
        }

        // Read file to check for the username
        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] userDetails = line.split(",");
                System.out.println("Checking file entry for username: " + userDetails[0]); // Debug log
                if (userDetails[0].equals(username)) {
                    return true; // Username matches
                }
            }
        }
        return false;
    }

    // Save user credentials to the file
    private void saveUserToFile(String username, String password) throws IOException {
        File file = new File(getServletContext().getRealPath(USER_FILE));

        // Ensure file and directories exist
        if (!file.exists()) {
            file.getParentFile().mkdirs(); // Create parent directories if needed
            file.createNewFile();         // Create the actual file
        }

        // Write user data to the file in append mode
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file, true))) {
            writer.write(username + "," + password); // Save as "username,password"
            writer.newLine(); // Add a new line for the next entry
        } catch (IOException e) {
            e.printStackTrace(); // Log any errors during writing
            throw e; // Re-throw exception for further handling
        }
    }
}