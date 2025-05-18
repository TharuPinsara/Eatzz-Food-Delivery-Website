package com.example.userlogin;

import java.util.regex.Pattern;
import java.util.Base64;

public class User {
    private String username;
    private String password;
    private String email;
    private String phone;
    private String address;

    // Patterns for validation
    private static final Pattern EMAIL_REGEX = Pattern.compile("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$");
    private static final Pattern PHONE_REGEX = Pattern.compile("^[0-9]{10}$");

    // Constructors
    public User() {
    }

    public User(String username, String password, String email, String phone, String address) {
        this.username = username;
        this.password = password;
        this.email = email;
        this.phone = phone;
        this.address = address;
    }

    // Getters and Setters
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        if (isValidEmail(email)) {
            this.email = email;
        } else {
            throw new IllegalArgumentException("Invalid email format");
        }
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        if (isValidPhone(phone)) {
            this.phone = phone;
        } else {
            throw new IllegalArgumentException("Invalid phone format");
        }
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    // Validation Methods
    private boolean isValidEmail(String email) {
        return EMAIL_REGEX.matcher(email).matches();
    }

    private boolean isValidPhone(String phone) {
        return PHONE_REGEX.matcher(phone).matches();
    }

    // Encode password and email for storage
    @Override
    public String toString() {
        String encodedPassword = Base64.getEncoder().encodeToString(password.getBytes());
        String encodedEmail = Base64.getEncoder().encodeToString(email.getBytes());
        return username + "," + encodedPassword + "," + encodedEmail + "," + phone + "," + address;
    }

    // Parse a User object from a string, decoding password and email
    public static User fromString(String line) {
        String[] details = line.split(",", -1);
        if (details.length != 5) {
            throw new IllegalArgumentException("Invalid user string format");
        }
        // Attempt to decode password and email, handle plain text as fallback
        String password = details[1];
        String email = details[2];
        try {
            password = new String(Base64.getDecoder().decode(details[1]));
        } catch (IllegalArgumentException e) {
            // Password is not Base64-encoded, use as is
        }
        try {
            email = new String(Base64.getDecoder().decode(details[2]));
        } catch (IllegalArgumentException e) {
            // Email is not Base64-encoded, use as is
        }
        return new User(details[0], password, email, details[3], details[4]);
    }
}