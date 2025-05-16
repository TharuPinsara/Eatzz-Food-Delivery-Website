package com.example.payment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

@WebServlet("/payment")
public class PaymentGatewayServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve order details from session
        HttpSession session = request.getSession();
        String orderId = (String) session.getAttribute("orderId");
        Double totalPrice = (Double) session.getAttribute("totalPrice");

        // Fallback if session data is missing
        if (orderId == null) {
            orderId = "N/A";
        }
        if (totalPrice == null) {
            totalPrice = 0.0;
        }

        // Set attributes for JSP
        request.setAttribute("orderId", orderId);
        request.setAttribute("totalPrice", totalPrice);

        // Forward to PaymentGateway.jsp
        request.getRequestDispatcher("/Checkout/PaymentGateaway.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve payment details
        String cardNumber = request.getParameter("cardNumber");
        String expiry = request.getParameter("expiry");
        String cvv = request.getParameter("cvv");
        String cardholderName = request.getParameter("cardholderName");

        // Basic validation
        if (cardNumber == null || cardNumber.trim().isEmpty() ||
                expiry == null || expiry.trim().isEmpty() ||
                cvv == null || cvv.trim().isEmpty() ||
                cardholderName == null || cardholderName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All payment fields are required.");
            request.setAttribute("orderId", (String) request.getSession().getAttribute("orderId"));
            request.setAttribute("totalPrice", (Double) request.getSession().getAttribute("totalPrice"));
            request.getRequestDispatcher("/Checkout/PaymentGateaway.jsp").forward(request, response);
            return;
        }

        // Simulate payment processing
        HttpSession session = request.getSession();
        String orderId = (String) session.getAttribute("orderId");
        Double totalPrice = (Double) session.getAttribute("totalPrice");

        // Update order status in order_history.txt
        updateOrderStatus(request.getServletContext().getRealPath("/"), orderId);

        // Set success message
        request.setAttribute("successMessage", "Payment of LKR " + String.format("%.2f", totalPrice) + " for Order ID " + orderId + " was successful!");
        request.setAttribute("orderId", orderId);
        request.setAttribute("totalPrice", totalPrice);

        // Forward back to PaymentGateway.jsp to show success
        request.getRequestDispatcher("/Checkout/PaymentGateaway.jsp").forward(request, response);
    }

    private synchronized void updateOrderStatus(String contextPath, String orderId) {
        String filePath = contextPath + "WEB-INF/orders/order_history.txt";
        String tempFilePath = contextPath + "WEB-INF/orders/order_history_temp.txt";
        File inputFile = new File(filePath);
        File tempFile = new File(tempFilePath);

        try {
            // Ensure the orders directory exists
            inputFile.getParentFile().mkdirs();

            BufferedReader reader = new BufferedReader(new FileReader(inputFile));
            FileWriter writer = new FileWriter(tempFile);
            String line;

            while ((line = reader.readLine()) != null) {
                // Split the line into fields
                String[] fields = line.split(",", -1);
                if (fields.length >= 7 && fields[0].equals(orderId)) {
                    // Update the orderStatus field (index 6) to Completed
                    fields[6] = "Payment Completed";
                    line = String.join(",", fields);
                }
                writer.write(line + "\n");
            }

            reader.close();
            writer.close();

            // Replace the original file with the updated one
            if (inputFile.delete()) {
                tempFile.renameTo(inputFile);
            } else {
                System.err.println("Failed to delete original order_history.txt");
            }
        } catch (IOException e) {
            System.err.println("Error updating order_history.txt: " + e.getMessage());
            e.printStackTrace();
        }
    }
}