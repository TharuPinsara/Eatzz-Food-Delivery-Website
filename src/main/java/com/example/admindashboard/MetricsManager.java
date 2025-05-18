package com.example.admindashboard;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Logger;

public class MetricsManager {
    private static final Logger LOGGER = Logger.getLogger(MetricsManager.class.getName());
    private static MetricsManager instance;
    private final ConcurrentHashMap<String, Number> metrics;
    private final Map<String, String> errors;
    private final String insightFilePath;

    private MetricsManager(String insightFilePath) {
        this.insightFilePath = insightFilePath;
        this.metrics = new ConcurrentHashMap<>();
        this.errors = new HashMap<>();
        initializeMetrics();
    }

    public static synchronized MetricsManager getInstance(String insightFilePath) {
        if (instance == null) {
            instance = new MetricsManager(insightFilePath);
        }
        return instance;
    }

    private void initializeMetrics() {
        metrics.put("totalOrders", 0);
        metrics.put("totalRevenue", 0.0);
        metrics.put("totalPaidOrders", 0);
        metrics.put("totalNonPaidOrders", 0);
        metrics.put("totalUsers", 0);
        metrics.put("totalFoodItems", 0);
        metrics.put("totalRestaurants", 0);
        metrics.put("totalAdminUsers", 0);
        metrics.put("totalDeliveries", 0);
    }

    public synchronized void updateMetrics(String filePath, String basePath) {
        try {
            LOGGER.info("Updating metrics for file: " + filePath + ", using MetricsManager version: " + this.getClass().getName() + ", timestamp: " + new Date() + ", DEPLOYMENT_MARKER_20250518_V4, Java version: " + System.getProperty("java.version") + ", Classpath: " + System.getProperty("java.class.path"));
            File file = new File(filePath);
            LOGGER.info("File details: path=" + file.getAbsolutePath() + ", exists=" + file.exists() + ", readable=" + file.canRead() + ", size=" + (file.exists() ? file.length() : 0) + " bytes, lastModified=" + (file.exists() ? new Date(file.lastModified()) : "N/A"));
            if (filePath.endsWith("users.txt")) {
                updateUsers(filePath);
            } else if (filePath.endsWith("/orders/order_history.txt") || filePath.endsWith("payment_history.txt")) {
                updateOrders(basePath + "/orders/order_history.txt", basePath + "payment_history.txt");
            } else if (filePath.endsWith("fooditems.txt")) {
                updateFoodItems(filePath);
            } else if (filePath.endsWith("Restaurant.txt")) {
                updateRestaurants(filePath);
            } else if (filePath.endsWith("store_admin_users.txt")) {
                updateAdminUsers(filePath);
            } else if (filePath.endsWith("delivery_details.txt")) {
                updateDeliveries(filePath);
            }
            saveToInsightFile();
        } catch (Exception e) {
            String errorMsg = "Error updating metrics for " + filePath + ": " + e.getMessage();
            errors.put(filePath, errorMsg);
            LOGGER.severe(errorMsg);
        }
    }

    private void updateUsers(String filePath) throws IOException {
        LOGGER.info("Entering updateUsers for file: " + filePath);
        int totalUsers = 0;
        File file = new File(filePath);
        LOGGER.info("Checking users file: " + file.getAbsolutePath() + ", exists: " + file.exists() + ", readable: " + file.canRead() + ", size=" + (file.exists() ? file.length() : 0) + " bytes, lastModified=" + (file.exists() ? new Date(file.lastModified()) : "N/A"));
        if (file.exists() && file.canRead()) {
            StringBuilder fileContent = new StringBuilder();
            try (BufferedReader br = new BufferedReader(new FileReader(file))) {
                String line;
                int lineCount = 0;
                while ((line = br.readLine()) != null) {
                    lineCount++;
                    String trimmedLine = line.trim();
                    fileContent.append("Line ").append(lineCount).append(": ").append(trimmedLine).append("\n");
                    if (!trimmedLine.isEmpty()) {
                        totalUsers++;
                        LOGGER.fine("User line " + lineCount + ": " + trimmedLine);
                    } else {
                        LOGGER.fine("Skipping empty line " + lineCount);
                    }
                }
            }
            LOGGER.info("Users file content:\n" + fileContent.toString());
        } else {
            String errorMsg = "Users file not found or unreadable at: " + file.getAbsolutePath();
            errors.put("users", errorMsg);
            LOGGER.severe(errorMsg);
        }
        metrics.put("totalUsers", totalUsers);
        LOGGER.info("Exiting updateUsers, totalUsers: " + totalUsers);
    }

    private void updateOrders(String orderFilePath, String paymentFilePath) throws IOException {
        LOGGER.info("Entering updateOrders for order file: " + orderFilePath + ", payment file: " + paymentFilePath);
        int totalOrders = 0;
        double totalRevenue = 0.0;
        int totalPaidOrders = 0;
        int totalNonPaidOrders = 0;
        Map<String, Integer> statusCounts = new HashMap<>();

        // Load payment history
        Map<String, Double> finalTotals = new HashMap<>();
        Map<String, String> paymentStatuses = new HashMap<>();
        File paymentFile = new File(paymentFilePath);
        LOGGER.info("Checking payment file: " + paymentFile.getAbsolutePath() + ", exists: " + paymentFile.exists() + ", readable: " + paymentFile.canRead() + ", size=" + (paymentFile.exists() ? paymentFile.length() : 0) + " bytes, lastModified=" + (paymentFile.exists() ? new Date(paymentFile.lastModified()) : "N/A"));
        if (paymentFile.exists() && paymentFile.canRead()) {
            try (BufferedReader br = new BufferedReader(new FileReader(paymentFile))) {
                String line;
                int lineCount = 0;
                while ((line = br.readLine()) != null) {
                    lineCount++;
                    if (line.trim().isEmpty()) {
                        continue;
                    }
                    LOGGER.fine("Payment line " + lineCount + ": " + line);
                    String[] paymentDetails = line.split(",", -1);
                    if (paymentDetails.length >= 7) {
                        String orderId = paymentDetails[0].trim();
                        try {
                            double finalTotal = Double.parseDouble(paymentDetails[4].trim());
                            String status = paymentDetails[6].trim();
                            finalTotals.put(orderId, finalTotal);
                            paymentStatuses.put(orderId, status);
                            statusCounts.put(status, statusCounts.getOrDefault(status, 0) + 1);
                        } catch (NumberFormatException e) {
                            String errorMsg = "Invalid final total at payment line " + lineCount + ": " + line;
                            errors.put("payment_line_" + lineCount, errorMsg);
                            LOGGER.severe(errorMsg);
                        }
                    } else {
                        String errorMsg = "Malformed payment line at line " + lineCount + ": " + line;
                        errors.put("payment_line_" + lineCount, errorMsg);
                        LOGGER.severe(errorMsg);
                    }
                }
            }
            LOGGER.info("Payment status counts: " + statusCounts);
        } else {
            String errorMsg = "Payment history file not found or unreadable at: " + paymentFile.getAbsolutePath();
            errors.put("payment", errorMsg);
            LOGGER.severe(errorMsg);
        }

        // Process orders
        statusCounts.clear();
        File orderFile = new File(orderFilePath);
        LOGGER.info("Checking order file: " + orderFile.getAbsolutePath() + ", exists: " + orderFile.exists() + ", readable: " + orderFile.canRead() + ", size=" + (orderFile.exists() ? orderFile.length() : 0) + " bytes, lastModified=" + (orderFile.exists() ? new Date(orderFile.lastModified()) : "N/A"));
        if (orderFile.exists() && orderFile.canRead()) {
            try (BufferedReader br = new BufferedReader(new FileReader(orderFile))) {
                String line;
                int lineCount = 0;
                while ((line = br.readLine()) != null) {
                    lineCount++;
                    if (line.trim().isEmpty()) {
                        continue;
                    }
                    LOGGER.fine("Order line " + lineCount + ": " + line);
                    String[] orderDetails = line.split(",", -1);
                    if (orderDetails.length >= 7) {
                        totalOrders++;
                        String orderId = orderDetails[0].trim();
                        String paymentStatus = paymentStatuses.getOrDefault(orderId, orderDetails[6].trim());
                        statusCounts.put(paymentStatus, statusCounts.getOrDefault(paymentStatus, 0) + 1);
                        try {
                            double orderTotal = Double.parseDouble(orderDetails[4].trim());
                            if (paymentStatus.equalsIgnoreCase("Processed") ||
                                    paymentStatus.equalsIgnoreCase("Approved") ||
                                    paymentStatus.equalsIgnoreCase("Payment Completed")) {
                                totalPaidOrders++;
                                double finalTotal = finalTotals.getOrDefault(orderId, orderTotal);
                                totalRevenue += finalTotal;
                            } else {
                                totalNonPaidOrders++;
                            }
                        } catch (NumberFormatException e) {
                            String errorMsg = "Invalid total price at order line " + lineCount + ": " + line;
                            errors.put("order_line_" + lineCount, errorMsg);
                            LOGGER.severe(errorMsg);
                        }
                    } else {
                        String errorMsg = "Malformed order line at line " + lineCount + ": " + line;
                        errors.put("order_line_" + lineCount, errorMsg);
                        LOGGER.severe(errorMsg);
                    }
                }
            }
            LOGGER.info("Order payment status counts: " + statusCounts);
        } else {
            String errorMsg = "Orders file not found or unreadable at: " + orderFile.getAbsolutePath();
            errors.put("orders", errorMsg);
            LOGGER.severe(errorMsg);
        }

        metrics.put("totalOrders", totalOrders);
        metrics.put("totalRevenue", totalRevenue);
        metrics.put("totalPaidOrders", totalPaidOrders);
        metrics.put("totalNonPaidOrders", totalNonPaidOrders);
        LOGGER.info("Exiting updateOrders, totalOrders: " + totalOrders + ", revenue: " + totalRevenue + ", paid: " + totalPaidOrders + ", non-paid: " + totalNonPaidOrders);
    }

    private void updateFoodItems(String filePath) throws IOException {
        int totalFoodItems = 0;
        File file = new File(filePath);
        LOGGER.info("Checking fooditems file: " + file.getAbsolutePath() + ", exists: " + file.exists() + ", readable: " + file.canRead() + ", size=" + (file.exists() ? file.length() : 0) + " bytes, lastModified=" + (file.exists() ? new Date(file.lastModified()) : "N/A"));
        if (file.exists() && file.canRead()) {
            try (BufferedReader br = new BufferedReader(new FileReader(file))) {
                String line;
                while ((line = br.readLine()) != null) {
                    if (!line.trim().isEmpty()) {
                        totalFoodItems++;
                    }
                }
            }
        } else {
            String errorMsg = "Food items file not found or unreadable at: " + file.getAbsolutePath();
            errors.put("fooditems", errorMsg);
            LOGGER.severe(errorMsg);
        }
        metrics.put("totalFoodItems", totalFoodItems);
        LOGGER.info("Updated totalFoodItems: " + totalFoodItems);
    }

    private void updateRestaurants(String filePath) throws IOException {
        int totalRestaurants = 0;
        File file = new File(filePath);
        LOGGER.info("Checking restaurants file: " + file.getAbsolutePath() + ", exists: " + file.exists() + ", readable: " + file.canRead() + ", size=" + (file.exists() ? file.length() : 0) + " bytes, lastModified=" + (file.exists() ? new Date(file.lastModified()) : "N/A"));
        if (file.exists() && file.canRead()) {
            try (BufferedReader br = new BufferedReader(new FileReader(file))) {
                String line;
                while ((line = br.readLine()) != null) {
                    if (!line.trim().isEmpty()) {
                        totalRestaurants++;
                    }
                }
            }
        } else {
            String errorMsg = "Restaurants file not found or unreadable at: " + file.getAbsolutePath();
            errors.put("restaurants", errorMsg);
            LOGGER.severe(errorMsg);
        }
        metrics.put("totalRestaurants", totalRestaurants);
        LOGGER.info("Updated totalRestaurants: " + totalRestaurants);
    }

    private void updateAdminUsers(String filePath) throws IOException {
        int totalAdminUsers = 0;
        File file = new File(filePath);
        LOGGER.info("Checking admin users file: " + file.getAbsolutePath() + ", exists: " + file.exists() + ", readable: " + file.canRead() + ", size=" + (file.exists() ? file.length() : 0) + " bytes, lastModified=" + (file.exists() ? new Date(file.lastModified()) : "N/A"));
        if (file.exists() && file.canRead()) {
            try (BufferedReader br = new BufferedReader(new FileReader(file))) {
                String line;
                while ((line = br.readLine()) != null) {
                    if (!line.trim().isEmpty()) {
                        totalAdminUsers++;
                    }
                }
            }
        } else {
            String errorMsg = "Admin users file not found or unreadable at: " + file.getAbsolutePath();
            errors.put("adminusers", errorMsg);
            LOGGER.severe(errorMsg);
        }
        metrics.put("totalAdminUsers", totalAdminUsers);
        LOGGER.info("Updated totalAdminUsers: " + totalAdminUsers);
    }

    private void updateDeliveries(String filePath) throws IOException {
        int totalDeliveries = 0;
        File file = new File(filePath);
        LOGGER.info("Checking deliveries file: " + file.getAbsolutePath() + ", exists: " + file.exists() + ", readable: " + file.canRead() + ", size=" + (file.exists() ? file.length() : 0) + " bytes, lastModified=" + (file.exists() ? new Date(file.lastModified()) : "N/A"));
        if (file.exists() && file.canRead()) {
            try (BufferedReader br = new BufferedReader(new FileReader(file))) {
                String line;
                while ((line = br.readLine()) != null) {
                    if (!line.trim().isEmpty()) {
                        totalDeliveries++;
                    }
                }
            }
        } else {
            String errorMsg = "Deliveries file not found or unreadable at: " + file.getAbsolutePath();
            errors.put("deliveries", errorMsg);
            LOGGER.severe(errorMsg);
        }
        metrics.put("totalDeliveries", totalDeliveries);
        LOGGER.info("Updated totalDeliveries: " + totalDeliveries);
    }

    private void saveToInsightFile() throws IOException {
        try (PrintWriter writer = new PrintWriter(new FileWriter(insightFilePath))) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String timestamp = sdf.format(new Date());
            writer.println("Servlet Execution Timestamp: " + timestamp);
            writer.println("Metrics:");
            writer.println("Total Orders: " + metrics.get("totalOrders"));
            writer.println("Total Revenue: " + String.format("%.2f", metrics.get("totalRevenue").doubleValue()));
            writer.println("Total Paid Orders: " + metrics.get("totalPaidOrders"));
            writer.println("Total Non-Paid Orders: " + metrics.get("totalNonPaidOrders"));
            writer.println("Total Users: " + metrics.get("totalUsers"));
            writer.println("Total Food Items: " + metrics.get("totalFoodItems"));
            writer.println("Total Restaurants: " + metrics.get("totalRestaurants"));
            writer.println("Total Admin Users: " + metrics.get("totalAdminUsers"));
            writer.println("Total Deliveries: " + metrics.get("totalDeliveries"));
            String errorString = errors.isEmpty() ? "None" : errors.values().toString();
            writer.println("Errors: " + errorString);
            LOGGER.info("Saved metrics to insight.txt at: " + new File(insightFilePath).getAbsolutePath());
        }
    }

    public Map<String, Number> getMetrics() {
        return new HashMap<>(metrics);
    }

    public Map<String, String> getErrors() {
        return new HashMap<>(errors);
    }
}