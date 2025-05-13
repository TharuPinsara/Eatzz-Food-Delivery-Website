package com.example.util;

import com.example.menu.MenuItem;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class QuickSort {

    /**
     * QuickSort Implementation for sorting MenuItem objects by price.
     *
     * @param items List of MenuItem objects to be sorted.
     * @return Sorted List of MenuItem objects.
     */
    public static List<MenuItem> sortMenuItemsByPrice(List<MenuItem> items) {
        if (items == null || items.size() <= 1) {
            return items;
        }

        // Using the first item as the pivot
        MenuItem pivot = items.get(0);
        List<MenuItem> less = new ArrayList<>();
        List<MenuItem> equal = new ArrayList<>();
        List<MenuItem> greater = new ArrayList<>();

        // Divide into less, equal, and greater lists
        for (MenuItem item : items) {
            if (item.getPrice() < pivot.getPrice()) {
                less.add(item);
            } else if (item.getPrice() > pivot.getPrice()) {
                greater.add(item);
            } else {
                equal.add(item);
            }
        }

        // Recursive sorting and merging
        less = sortMenuItemsByPrice(less);
        greater = sortMenuItemsByPrice(greater);

        // Concatenate results
        List<MenuItem> sorted = new ArrayList<>();
        sorted.addAll(less);
        sorted.addAll(equal);
        sorted.addAll(greater);
        return sorted;
    }

    // Test main method (Optional - Remove/test separately in production)
    public static void main(String[] args) {
        List<MenuItem> foodItems = Arrays.asList();

        System.out.println("Before Sorting:");
        foodItems.forEach(item -> System.out.println(item.getName() + " - " + item.getPrice()));

        List<MenuItem> sortedItems = QuickSort.sortMenuItemsByPrice(foodItems);

        System.out.println("\nAfter Sorting:");
        sortedItems.forEach(item -> System.out.println(item.getName() + " - " + item.getPrice()));
    }
}