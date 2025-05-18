package com.example.menu.foodapp;

import jakarta.servlet.ServletContext;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class FoodItemFileUtil {
    private static final String FILE_NAME = "fooditems.txt";

    public static List<FoodItem> loadFoodItems(ServletContext context) throws IOException {
        String filePath = context.getRealPath("/WEB-INF/" + FILE_NAME);
        File file = new File(filePath);

        // Create file with default items if it doesn't exist
        if (!file.exists()) {
            file.getParentFile().mkdirs();
            List<FoodItem> defaultItems = getDefaultFoodItems();
            saveFoodItems(context, defaultItems);
            return defaultItems;
        }

        List<FoodItem> foodItems = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length == 4) {
                    foodItems.add(new FoodItem(
                            parts[0].trim(),
                            Double.parseDouble(parts[1].trim()),
                            parts[2].trim(),
                            parts[3].trim()
                    ));
                }
            }
        }
        return foodItems;
    }

    public static void saveFoodItems(ServletContext context, List<FoodItem> foodItems) throws IOException {
        String filePath = context.getRealPath("/WEB-INF/" + FILE_NAME);
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            for (FoodItem item : foodItems) {
                writer.write(String.format("%s,%.2f,%s,%s",
                        item.getName(),
                        item.getPrice(),
                        item.getStoreName(),
                        item.getImagePath()
                ));
                writer.newLine();
            }
        }
    }

    private static List<FoodItem> getDefaultFoodItems() {
        List<FoodItem> defaultItems = new ArrayList<>();
        return defaultItems;
    }
}