import java.io.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/GeneratePaymentReportServlet")
public class GeneratePaymentReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderId = request.getParameter("orderId");
        if (orderId == null || orderId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?error=Invalid order ID");
            return;
        }

        String paymentHistoryFilePath = getServletContext().getRealPath("/") + "WEB-INF/payment_history.txt";
        File paymentHistoryFile = new File(paymentHistoryFilePath);
        String reportContent = null;

        if (paymentHistoryFile.canRead()) {
            try (BufferedReader reader = new BufferedReader(new FileReader(paymentHistoryFile))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    String[] paymentDetails = line.split(",");
                    if (paymentDetails.length >= 6 && paymentDetails[0].equals(orderId)) {
                        reportContent = String.format(
                                "Payment Report\n\nOrder ID: %s\nStore Name: %s\nTotal Price: %s LKR\nWebsite Commission: %s LKR\nStore Payment: %s LKR\nDate: %s\nStatus: %s",
                                paymentDetails[0], paymentDetails[1], paymentDetails[2], paymentDetails[3], paymentDetails[4], paymentDetails[5], paymentDetails.length > 6 ? paymentDetails[6] : "Pending"
                        );
                        break;
                    }
                }
            } catch (IOException e) {
                response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?error=Error reading payment file: " + e.getMessage());
                return;
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?error=No permission to read payment file");
            return;
        }

        if (reportContent != null) {
            response.setContentType("text/plain");
            response.setHeader("Content-Disposition", "attachment; filename=payment_report_" + orderId + ".txt");
            try (PrintWriter writer = response.getWriter()) {
                writer.write(reportContent);
            }
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?success=reportGenerated");
        } else {
            response.sendRedirect(request.getContextPath() + "/AdminPage/AdminDashboard.jsp?error=Payment record not found");
        }
    }
}