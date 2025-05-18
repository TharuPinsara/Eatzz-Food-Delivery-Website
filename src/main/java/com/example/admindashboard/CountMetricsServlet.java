package com.example.admindashboard;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;
import java.util.logging.Logger;

@WebServlet("/CountMetricsServlet")
public class CountMetricsServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(CountMetricsServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("CountMetricsServlet invoked at " + new java.util.Date());
        response.setContentType("text/plain; charset=UTF-8");

        // Get MetricsManager instance
        String insightFilePath = getServletContext().getRealPath("/WEB-INF/insight.txt");
        MetricsManager metricsManager = MetricsManager.getInstance(insightFilePath);
        String basePath = getServletContext().getRealPath("/WEB-INF/");

        // Check for update parameter
        String updateParam = request.getParameter("update");
        if ("true".equalsIgnoreCase(updateParam)) {
            LOGGER.info("Manual update triggered via ?update=true");
            String[] files = {
                    "users.txt",
                    "/orders/order_history.txt",
                    "payment_history.txt",
                    "fooditems.txt",
                    "Restaurant.txt",
                    "store_admin_users.txt",
                    "delivery_details.txt"
            };
            for (String file : files) {
                String filePath = basePath + file;
                LOGGER.info("Manually updating metrics for: " + filePath);
                metricsManager.updateMetrics(filePath, basePath);
            }
        }

        // Get metrics and errors
        Map<String, Number> metrics = metricsManager.getMetrics();
        Map<String, String> errors = metricsManager.getErrors();

        // Set request attributes
        request.setAttribute("totalOrders", metrics.get("totalOrders"));
        request.setAttribute("totalRevenue", metrics.get("totalRevenue"));
        request.setAttribute("totalPaidOrders", metrics.get("totalPaidOrders"));
        request.setAttribute("totalNonPaidOrders", metrics.get("totalNonPaidOrders"));
        request.setAttribute("totalUsers", metrics.get("totalUsers"));
        request.setAttribute("totalFoodItems", metrics.get("totalFoodItems"));
        request.setAttribute("totalRestaurants", metrics.get("totalRestaurants"));
        request.setAttribute("totalAdminUsers", metrics.get("totalAdminUsers"));
        request.setAttribute("totalDeliveries", metrics.get("totalDeliveries"));

        // Handle errors
        if (!errors.isEmpty() || (metrics.get("totalOrders").intValue() == 0 && metrics.get("totalUsers").intValue() == 0 &&
                metrics.get("totalFoodItems").intValue() == 0 && metrics.get("totalRestaurants").intValue() == 0 &&
                metrics.get("totalAdminUsers").intValue() == 0 && metrics.get("totalDeliveries").intValue() == 0)) {
            String errorMsg = !errors.isEmpty() ? errors.values().toString() : "No data found in any files. Please verify file contents and formats.";
            request.setAttribute("error", errorMsg);
            LOGGER.info("Error set: " + errorMsg);
        }

        // Log metrics
        LOGGER.info("Metrics - Orders: " + metrics.get("totalOrders") + ", Revenue: " + metrics.get("totalRevenue") +
                ", Paid: " + metrics.get("totalPaidOrders") + ", Non-Paid: " + metrics.get("totalNonPaidOrders") +
                ", Users: " + metrics.get("totalUsers") + ", Food Items: " + metrics.get("totalFoodItems") +
                ", Restaurants: " + metrics.get("totalRestaurants") + ", Admin Users: " + metrics.get("totalAdminUsers") +
                ", Deliveries: " + metrics.get("totalDeliveries"));

        // Forward to JSP
        LOGGER.info("Forwarding to ChartAdminDashboard.jsp");
        request.getRequestDispatcher("/AdminPage/ChartAdminDashboard.jsp").forward(request, response);
    }
}