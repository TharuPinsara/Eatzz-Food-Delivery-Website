<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Chinese Food Menu</title>
    <link rel="stylesheet" type="text/css" href="Menu/chinese.css">
</head>
<body>
<h1>Chinese Food Menu</h1>
<div class="menu-container">
    <%
        // Define the MenuItem class
        class MenuItem {
            String name;
            double price;
            String imagePath;

            MenuItem(String name, double price, String imagePath) {
                this.name = name;
                this.price = price;
                this.imagePath = imagePath;
            }

            String getName() { return name; }
            double getPrice() { return price; }
            String getImagePath() { return imagePath; }
        }

        // List of 12 Chinese food menu items with unique image paths
        List<MenuItem> chineseMenuItems = Arrays.asList(
                new MenuItem("Kung Pao Chicken", 12.99, "Menu/images/KungPaoChicken.jpg"),
                new MenuItem("Sweet and Sour Pork", 11.49, "Menu/images/SweetAndSourPork.jpg"),
                new MenuItem("General Tso's Chicken", 13.99, "Menu/images/GeneralTsosChicken.jpg"),
                new MenuItem("Beef and Broccoli", 14.49, "Menu/images/BeefBroccoli.jpg"),
                new MenuItem("Hot and Sour Soup", 6.99, "Menu/images/HotAndSourSoup.jpg"),
                new MenuItem("Spring Rolls", 5.99, "Menu/images/SpringRolls.jpg"),
                new MenuItem("Szechuan Shrimp", 15.99, "Menu/images/SzechuanShrimp.jpg"),
                new MenuItem("Egg Fried Rice", 8.99, "Menu/images/EggFriedRice.jpg"),
                new MenuItem("Lo Mein Noodles", 10.49, "Menu/images/LoMeinNoodles.jpg"),
                new MenuItem("Mapo Tofu", 11.99, "Menu/images/MapoTofu.jpg"),
                new MenuItem("Dim Sum", 14.99, "Menu/images/DimSum.jpg"),
                new MenuItem("Wonton Soup", 7.49, "Menu/images/WontonSoup.jpg")
        );

        // Render menu items dynamically
        for (MenuItem item : chineseMenuItems) {
    %>
    <div class="menu-item">
        <img src="<%= item.getImagePath() %>" alt="<%= item.getName() %>" class="food-image" />
        <h2><%= item.getName() %></h2>
        <p>Price: $<%= String.format("%.2f", item.getPrice()) %></p>
    </div>
    <% } %>
</div>
</body>
</html>