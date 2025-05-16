package com.example.restaurant;

import jakarta.servlet.ServletContext;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class RestaurantUtil {
    private static final String FILE_NAME = "/WEB-INF/Restaurant.txt";

    public static List<Restaurant> loadRestaurants(ServletContext context) throws IOException {
        String filePath = context.getRealPath(FILE_NAME);
        List<Restaurant> restaurants = new ArrayList<>();
        File file = new File(filePath);

        if (!file.exists()) {
            file.getParentFile().mkdirs();
            file.createNewFile();
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split("\\|");
                if (parts.length == 3) {
                    restaurants.add(new Restaurant(
                            parts[0].trim(),
                            parts[1].trim(),
                            parts[2].trim()
                    ));
                }
            }
        }
        return restaurants;
    }

    public static void saveRestaurants(ServletContext context, List<Restaurant> restaurants) throws IOException {
        String filePath = context.getRealPath(FILE_NAME);
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            for (Restaurant restaurant : restaurants) {
                writer.write(String.format("%s|%s|%s",
                        restaurant.getName(),
                        restaurant.getAddress(),
                        restaurant.getPhoneNumber()));
                writer.newLine();
            }
        }
    }

    public static void addRestaurant(ServletContext context, Restaurant restaurant) throws IOException {
        List<Restaurant> restaurants = loadRestaurants(context);
        for (Restaurant r : restaurants) {
            if (r.getName().equalsIgnoreCase(restaurant.getName())) {
                throw new IOException("Restaurant with name '" + restaurant.getName() + "' already exists.");
            }
        }
        restaurants.add(restaurant);
        saveRestaurants(context, restaurants);
    }
}