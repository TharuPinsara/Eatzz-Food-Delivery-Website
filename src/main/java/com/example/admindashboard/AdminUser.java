package com.example.admindashboard;

import com.example.userlogin.User;

public class AdminUser extends User {
    // Static final admin credentials
    private static final String ADMIN_USERNAME = "admin";
    private static final String ADMIN_PASSWORD = "admin123";

    // Constructor for AdminUser
    public AdminUser() {
        super(ADMIN_USERNAME, ADMIN_PASSWORD, "admin@example.com", "1234567890", "Admin Address");
    }

    // Static method to create admin user instance
    public static AdminUser createAdminUser() {
        return new AdminUser();
    }
}