package com.example.service;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/DeleteOrderServlet")
public class DeleteOrderServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orderId = request.getParameter("orderId");
        String filePath = getServletContext().getRealPath("/WEB-INF/orders/order_history.txt");
        File orderFile = new File(filePath);

        if (orderId == null || orderId.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?error=Order%20ID%20is%20required");
            return;
        }

        List<String> remainingOrders = new ArrayList<>();
        boolean orderFound = false;
        if (orderFile.exists() && orderFile.canRead()) {
            try (BufferedReader reader = new BufferedReader(new FileReader(orderFile))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    String[] details = line.split(",", -1);
                    if (details.length >= 8 && details[0].equals(orderId)) {
                        orderFound = true;
                    } else {
                        remainingOrders.add(line);
                    }
                }
            }
        }

        if (orderFound && orderFile.canWrite()) {
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(orderFile))) {
                for (String remainingLine : remainingOrders) {
                    writer.write(remainingLine);
                    writer.newLine();
                }
                response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?success=Order%20deleted%20successfully");
            } catch (IOException e) {
                response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?error=Failed%20to%20write%20to%20file:%20" + e.getMessage());
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?error=Order%20not%20found%20or%20file%20not%20writable");
        }
    }
}