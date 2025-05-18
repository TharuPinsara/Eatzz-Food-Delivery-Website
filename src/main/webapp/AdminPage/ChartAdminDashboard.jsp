<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%
    // Check if "adminUser" attribute exists in the session; if not, redirect to the login page
    if (session.getAttribute("adminUser") == null) {
        response.sendRedirect(request.getContextPath() + "/AdminPage/admin_login.jsp");
        return;
    }

    // Retrieve error message from request attributes
    String errorMessage = (String) request.getAttribute("error");

    // Read and parse insight.txt
    StringBuilder insightContent = new StringBuilder();
    String insightError = null;
    Map<String, String> insightMetrics = new HashMap<>();
    String insightFilePath = getServletContext().getRealPath("/WEB-INF/insight.txt");
    File insightFile = new File(insightFilePath);
    boolean hasData = false;
    if (insightFile.exists() && insightFile.canRead()) {
        try (BufferedReader br = new BufferedReader(new FileReader(insightFile))) {
            String line;
            while ((line = br.readLine()) != null) {
                insightContent.append(line).append("\n");
                // Parse metrics
                if (line.contains(": ")) {
                    String[] parts = line.split(": ", 2);
                    if (parts.length == 2) {
                        insightMetrics.put(parts[0].trim(), parts[1].trim());
                    }
                }
            }
            if (insightContent.length() == 0) {
                insightError = "Insight file is empty.";
            } else {
                // Check for data (non-zero metrics)
                try {
                    int totalOrders = Integer.parseInt(insightMetrics.getOrDefault("Total Orders", "0"));
                    double totalRevenue = Double.parseDouble(insightMetrics.getOrDefault("Total Revenue", "0.0"));
                    int totalPaidOrders = Integer.parseInt(insightMetrics.getOrDefault("Total Paid Orders", "0"));
                    int totalNonPaidOrders = Integer.parseInt(insightMetrics.getOrDefault("Total Non-Paid Orders", "0"));
                    int totalUsers = Integer.parseInt(insightMetrics.getOrDefault("Total Users", "0"));
                    int totalFoodItems = Integer.parseInt(insightMetrics.getOrDefault("Total Food Items", "0"));
                    int totalRestaurants = Integer.parseInt(insightMetrics.getOrDefault("Total Restaurants", "0"));
                    int totalAdminUsers = Integer.parseInt(insightMetrics.getOrDefault("Total Admin Users", "0"));
                    int totalDeliveries = Integer.parseInt(insightMetrics.getOrDefault("Total Deliveries", "0"));
                    hasData = totalOrders > 0 || totalRevenue > 0 || totalPaidOrders > 0 || totalNonPaidOrders > 0 ||
                            totalUsers > 0 || totalFoodItems > 0 || totalRestaurants > 0 ||
                            totalAdminUsers > 0 || totalDeliveries > 0;
                } catch (NumberFormatException e) {
                    insightError = "Error parsing metrics from insight.txt: " + e.getMessage();
                }
            }
        } catch (IOException e) {
            insightError = "Error reading insight.txt: " + e.getMessage();
        }
    } else {
        insightError = "Insight file not found or unreadable at: " + insightFilePath;
    }

    // Debug: Log metrics to console
    System.out.println("Insight Metrics: " + insightMetrics);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/AdminPage/ChartDashboard.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/AdminPage/StyleDashboard.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.4/dist/chart.umd.min.js"></script>
</head>
<body>
<div class="dashboard">
    <jsp:include page="/AdminPage/AdminSideBar.jsp"/>

    <main class="main-content">
        <header class="top-bar">
            <h1>Admin Dashboard</h1>
            <div class="top-bar-right">
                <div class="search-bar">
                    <input type="text" id="searchInput" placeholder="Search..." disabled />
                    <button type="button">🔍</button>
                </div>
                <div class="profile-dropdown">
                    <div class="profile-toggle">
                        <span><b><%= session.getAttribute("adminUser") %></b></span>
                        <span>▼</span>
                    </div>
                    <div class="dropdown-menu">
                        <a href="#">Profile</a>
                        <a href="<%= request.getContextPath() %>/LogoutServlet">Logout</a>
                    </div>
                </div>
            </div>
        </header>

        <section class="main-section">
            <!-- Debug: Check container width -->
            <script>
                console.log("Main Section Width: " + document.querySelector('.main-section').offsetWidth + "px");
            </script>

            <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
            <div class="error-message"><%= errorMessage %></div>
            <% } %>
            <% if (!hasData && errorMessage == null) { %>
            <div class="no-data-message">No data available. Please check file configurations.</div>
            <% } %>

            <!-- Insight Section -->
            <div class="insight-section">
                <h2>Eatzz Website Insights</h2>
            </div>

            <h2>Key Metrics</h2>
            <div class="metrics-grid">
                <div class="metric-card">
                    <h3>Total Orders</h3>
                    <p><%= insightMetrics.getOrDefault("Total Orders", "0") %></p>
                </div>
                <div class="metric-card">
                    <h3>Total Revenue (LKR)</h3>
                    <p><%
                        String revenue = insightMetrics.getOrDefault("Total Revenue", "0.0");
                        try {
                            out.print(String.format("%.2f", Double.parseDouble(revenue)));
                        } catch (NumberFormatException e) {
                            out.print("0.00");
                        }
                    %></p>
                </div>
                <div class="metric-card">
                    <h3>Paid Orders</h3>
                    <p><%= insightMetrics.getOrDefault("Total Paid Orders", "0") %></p>
                </div>
                <div class="metric-card">
                    <h3>Non-Paid Orders</h3>
                    <p><%= insightMetrics.getOrDefault("Total Non-Paid Orders", "0") %></p>
                </div>
                <div class="metric-card">
                    <h3>Total Users</h3>
                    <p><%= insightMetrics.getOrDefault("Total Users", "0") %></p>
                </div>
                <div class="metric-card">
                    <h3>Total Food Items</h3>
                    <p><%= insightMetrics.getOrDefault("Total Food Items", "0") %></p>
                </div>
                <div class="metric-card">
                    <h3>Total Restaurants</h3>
                    <p><%= insightMetrics.getOrDefault("Total Restaurants", "0") %></p>
                </div>
                <div class="metric-card">
                    <h3>Total Deliveries</h3>
                    <p><%= insightMetrics.getOrDefault("Total Deliveries", "0") %></p>
                </div>
            </div>

            <h2>Visual Insights</h2>
            <div class="chart-container">
                <h3>Order Metrics</h3>
                <canvas id="ordersChart"></canvas>
            </div>
            <div class="chart-container">
                <h3>Paid vs Non-Paid Orders</h3>
                <canvas id="paidVsNonPaidChart"></canvas>
            </div>
        </section>
    </main>
</div>

<script>
    // Orders Bar Chart
    const ordersCtx = document.getElementById('ordersChart').getContext('2d');
    new Chart(ordersCtx, {
        type: 'bar',
        data: {
            labels: ['Total Orders', 'Paid Orders', 'Non-Paid Orders'],
            datasets: [{
                label: 'Order Metrics',
                data: [
                    <%= insightMetrics.getOrDefault("Total Orders", "0") %>,
                    <%= insightMetrics.getOrDefault("Total Paid Orders", "0") %>,
                    <%= insightMetrics.getOrDefault("Total Non-Paid Orders", "0") %>
                ],
                backgroundColor: ['#2563eb', '#10b981', '#dc3545'],
                borderColor: ['#1e3a8a', '#059669', '#b91c1c'],
                borderWidth: 1
            }]
        },
        options: {
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true, title: { display: true, text: 'Count' } },
                x: { title: { display: true, text: 'Order Types' } }
            }
        }
    });

    // Paid vs Non-Paid Pie Chart
    const paidVsNonPaidCtx = document.getElementById('paidVsNonPaidChart').getContext('2d');
    new Chart(paidVsNonPaidCtx, {
        type: 'pie',
        data: {
            labels: ['Paid Orders', 'Non-Paid Orders'],
            datasets: [{
                data: [
                    <%= insightMetrics.getOrDefault("Total Paid Orders", "0") %>,
                    <%= insightMetrics.getOrDefault("Total Non-Paid Orders", "0") %>
                ],
                backgroundColor: ['#10b981', '#dc3545'],
                borderColor: ['#059669', '#b91c1c'],
                borderWidth: 1
            }]
        },
        options: {
            plugins: { legend: { position: 'top' } }
        }
    });

    // Profile dropdown functionality
    document.querySelector('.profile-toggle').addEventListener('click', function () {
        const dropdownMenu = document.querySelector('.dropdown-menu');
        dropdownMenu.classList.toggle('active');
    });

    document.addEventListener('click', function (event) {
        const profileDropdown = document.querySelector('.profile-dropdown');
        if (!profileDropdown.contains(event.target)) {
            document.querySelector('.dropdown-menu').classList.remove('active');
        }
    });
</script>
</body>
</html>