import java.io.*;
import java.net.*;
import javax.net.ssl.*;
import java.security.KeyStore;
import java.security.SecureRandom;
import javax.net.ssl.KeyManagerFactory;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSocket;
import java.util.logging.*;

public class Server {
    
    private static final Logger logger = Logger.getLogger(Server.class.getName());

    public static void main(String[] args) {
        try {
            // Set up logger
            setupLogger();

            // Log server startup
            logger.info("Server starting...");

            // Load the server's keystore
            char[] password = "changeit".toCharArray();
            KeyStore keystore = KeyStore.getInstance("PKCS12");
            FileInputStream fis = new FileInputStream("/certs/keystore.p12");
            keystore.load(fis, password);
            fis.close();

            // Set up the SSL context with the key store
            KeyManagerFactory kmf = KeyManagerFactory.getInstance(KeyManagerFactory.getDefaultAlgorithm());
            kmf.init(keystore, password);
            SSLContext sslContext = SSLContext.getInstance("TLS");
            sslContext.init(kmf.getKeyManagers(), null, new SecureRandom());

            // Create the SSL server socket factory
            SSLServerSocketFactory factory = sslContext.getServerSocketFactory();
            SSLServerSocket serverSocket = (SSLServerSocket) factory.createServerSocket(5001);
            serverSocket.setNeedClientAuth(false);  // No client authentication required

            // Log server startup success
            logger.info("Java HTTPS server started on port 5001...");

            while (true) {
                SSLSocket socket = (SSLSocket) serverSocket.accept();
                logger.info("New connection established");

                // Start a new thread to handle the client connection
                new Thread(() -> handleClient(socket)).start();
            }
        } catch (Exception e) {
            logger.severe("Error in server: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Setup logger to write logs to console and file
    private static void setupLogger() {
        try {
            // Create a FileHandler that writes to "server.log"
            FileHandler fileHandler = new FileHandler("server.log", true);
            fileHandler.setFormatter(new SimpleFormatter());
            logger.addHandler(fileHandler);

            // Set the log level to INFO to capture all logs at INFO level or higher
            logger.setLevel(Level.INFO);
        } catch (IOException e) {
            System.err.println("Failed to set up logger: " + e.getMessage());
        }
    }

    // Handles client connections
    private static void handleClient(SSLSocket socket) {
        try {
            // Read data from the client
            BufferedReader reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            String line;
            StringBuilder request = new StringBuilder();
            while ((line = reader.readLine()) != null) {
                request.append(line).append("\n");
                if (line.isEmpty()) break;  // End of request headers
            }

            // Log the received request for debugging
            logger.fine("Request received:\n" + request.toString());

            // If the client requests the "/data" endpoint, return some JSON
            PrintWriter writer = new PrintWriter(socket.getOutputStream(), true);
            if (request.toString().contains("GET /data")) {
                writer.println("HTTP/1.1 200 OK");
                writer.println("Content-Type: application/json;charset=UTF-8");
                writer.println("Connection: close");
                writer.println();  // End of headers

                // Sending JSON data with proper UTF-8 encoding
                String jsonResponse = "{\"message\": \"Hello from the server running minimus image and using json format!\", \"status\": \"success\"}";
                writer.println(jsonResponse);

                // Log that the JSON response was sent
                logger.info("Sent JSON response to client");
            } else {
                // Default response for other requests
                writer.println("HTTP/1.1 200 OK");
                writer.println("Content-Type: text/plain;charset=UTF-8");
                writer.println("Connection: close");
                writer.println();  // End of headers
                writer.println("✅ Hello over HTTPS from Java TLS Server running minimus images!");

                // Log the text response
                logger.info("Sent text response to client");
            }

            // Close connection
            socket.close();
            logger.info("Connection closed");
        } catch (IOException e) {
            logger.severe("Error in handling client connection: " + e.getMessage());
        }
    }
}
