import java.io.*;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/MarkProcessedPaymentServlet")
public class MarkProcessedPaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderId = request.getParameter("orderId");
        if (orderId == null || orderId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?error=Invalid order ID");
            return;
        }

        String paymentHistoryFilePath = getServletContext().getRealPath("/") + "WEB-INF/payment_history.txt";
        File paymentHistoryFile = new File(paymentHistoryFilePath);
        boolean fileExists = paymentHistoryFile.exists();
        boolean success = false;

        if (!fileExists) {
            paymentHistoryFile.getParentFile().mkdirs();
            paymentHistoryFile.createNewFile();
        }

        List<String> updatedRecords = new ArrayList<>();
        if (paymentHistoryFile.canRead()) {
            try (BufferedReader reader = new BufferedReader(new FileReader(paymentHistoryFile))) {
                String line;
                boolean found = false;
                while ((line = reader.readLine()) != null) {
                    String[] paymentDetails = line.split(",");
                    if (paymentDetails.length >= 6 && paymentDetails[0].equals(orderId)) {
                        found = true;
                        paymentDetails[paymentDetails.length - 1] = "Processed"; // Update status to Processed
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
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?success=paymentProcessed");
        } else {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?error=Payment record not found");
        }
    }
}