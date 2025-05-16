import java.io.*;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/EditPaymentServlet")
public class EditPaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderId = request.getParameter("orderId");
        request.setAttribute("orderId", orderId);
        request.getRequestDispatcher("/AdminPage/editPayment.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderId = request.getParameter("orderId");
        String newCommissionStr = request.getParameter("commission");
        if (orderId == null || orderId.trim().isEmpty() || newCommissionStr == null || newCommissionStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?error=Invalid input");
            return;
        }

        double newCommission;
        try {
            newCommission = Double.parseDouble(newCommissionStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?error=Invalid commission value");
            return;
        }

        String paymentHistoryFilePath = getServletContext().getRealPath("/") + "WEB-INF/payment_history.txt";
        File paymentHistoryFile = new File(paymentHistoryFilePath);
        boolean success = false;

        List<String> updatedRecords = new ArrayList<>();
        if (paymentHistoryFile.canRead()) {
            try (BufferedReader reader = new BufferedReader(new FileReader(paymentHistoryFile))) {
                String line;
                boolean found = false;
                while ((line = reader.readLine()) != null) {
                    String[] paymentDetails = line.split(",");
                    if (paymentDetails.length >= 6 && paymentDetails[0].equals(orderId)) {
                        found = true;
                        double totalPrice = Double.parseDouble(paymentDetails[2]);
                        double storePayment = totalPrice - newCommission;
                        paymentDetails[3] = String.format("%.2f", newCommission); // Update commission
                        paymentDetails[4] = String.format("%.2f", storePayment); // Update store payment
                        updatedRecords.add(String.join(",", paymentDetails));
                    } else {
                        updatedRecords.add(line);
                    }
                }
                success = found;
            } catch (IOException e) {
                response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?error=Error reading payment file: " + e.getMessage());
                return;
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?error=No permission to read payment file");
            return;
        }

        if (success) {
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(paymentHistoryFile))) {
                for (String record : updatedRecords) {
                    writer.write(record);
                    writer.newLine();
                }
            } catch (IOException e) {
                response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?error=Error updating payment file: " + e.getMessage());
                return;
            }
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?success=paymentEdited");
        } else {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?error=Payment record not found");
        }
    }
}