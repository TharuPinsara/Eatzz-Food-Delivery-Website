package com.example.admindashboard;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;

import java.io.File;
import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardWatchEventKinds;
import java.nio.file.WatchEvent;
import java.nio.file.WatchKey;
import java.nio.file.WatchService;
import java.util.logging.Logger;

@WebServlet(name = "FileMonitorServlet", urlPatterns = {"/FileMonitorServlet"}, loadOnStartup = 1)
public class FileMonitorServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(FileMonitorServlet.class.getName());
    private volatile boolean running = true;

    @Override
    public void init() throws ServletException {
        super.init();
        String basePath = getServletContext().getRealPath("/WEB-INF/");
        String insightFilePath = basePath + "insight.txt";
        MetricsManager metricsManager = MetricsManager.getInstance(insightFilePath);

        // Log base path
        LOGGER.info("WEB-INF path: " + basePath);

        // List of files to process
        String[] files = {
                "users.txt",
                "/orders/order_history.txt",
                "payment_history.txt",
                "fooditems.txt",
                "Restaurant.txt",
                "store_admin_users.txt",
                "delivery_details.txt"
        };

        // Initialize metrics by processing all files
        for (String file : files) {
            String filePath = basePath + file;
            File f = new File(filePath);
            LOGGER.info("Initializing file: " + filePath + ", exists: " + f.exists() + ", readable: " + f.canRead());
            metricsManager.updateMetrics(filePath, basePath);
        }

        // Start file monitoring in a separate thread
        Thread monitorThread = new Thread(() -> monitorFiles(basePath, metricsManager));
        monitorThread.setDaemon(true);
        monitorThread.start();
        LOGGER.info("FileMonitorServlet initialized and monitoring started for WEB-INF/");
    }

    private void monitorFiles(String basePath, MetricsManager metricsManager) {
        try (WatchService watchService = FileSystems.getDefault().newWatchService()) {
            Path dir = Paths.get(basePath);
            dir.register(watchService, StandardWatchEventKinds.ENTRY_MODIFY);
            LOGGER.info("Monitoring directory: " + basePath);

            while (running) {
                WatchKey key;
                try {
                    key = watchService.take();
                } catch (InterruptedException e) {
                    LOGGER.severe("File monitoring interrupted: " + e.getMessage());
                    return;
                }

                for (WatchEvent<?> event : key.pollEvents()) {
                    WatchEvent.Kind<?> kind = event.kind();
                    if (kind == StandardWatchEventKinds.OVERFLOW) {
                        LOGGER.warning("WatchService overflow occurred");
                        continue;
                    }

                    @SuppressWarnings("unchecked")
                    WatchEvent<Path> ev = (WatchEvent<Path>) event;
                    Path fileName = ev.context();
                    String filePath = basePath + fileName.toString();
                    LOGGER.info("Detected change in file: " + filePath);
                    metricsManager.updateMetrics(filePath, basePath);
                }

                boolean valid = key.reset();
                if (!valid) {
                    LOGGER.severe("WatchKey no longer valid");
                    break;
                }
            }
        } catch (IOException e) {
            LOGGER.severe("Error setting up file monitoring: " + e.getMessage());
        }
    }

    @Override
    public void destroy() {
        running = false;
        LOGGER.info("FileMonitorServlet destroyed");
    }
}