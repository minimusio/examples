
# JDK + JRE TLS Testing Framework

**Company**: Minimus  
**Author**: Alexander Haytovich  

This project provides a test framework for validating a Java application with TLS enabled. The setup involves a Java container running an application server over HTTPS, a Python test client that verifies the application's functionality, and the creation of self-signed certificates.

---

## 🧱 Components

### 1. `certgen.sh`
- Generates a self-signed certificate using OpenSSL
- Certs are stored in a shared volume for use by other services

### 2. `create-certs.yml`
- Runs `certgen.sh` in a container to create certificates
- The certificates are stored in a shared volume for use by other services

### 3. `docker-compose.yml`
- Runs the following services:
  - `app`: A Java application server running over HTTPS
  - `testclient`: A Python script that verifies HTTPS functionality
- Both services share the same certificate volume

### 4. `Server.java`
- Java server that listens for HTTPS requests and sends either a text or JSON response
- Uses SSL/TLS for secure communication

### 5. `test_client.py`
- Python script using `requests` to connect to the Java server over HTTPS
- Verifies the server's TLS certificate and checks the response format (either text or JSON)

### 6. `Dockerfile.app`
- Multi-stage Dockerfile for building the Java server
- First builds with JDK to compile the server, then runs it using a minimal JRE image

### 7. `Dockerfile.testclient`
- Builds the Python test client image with a virtual environment to run the test client

### 8. `test_runner.sh`
- Iterates over image pairs in `minimus_images.txt`
- Swaps base and builder images in Dockerfiles for testing various configurations

---

## 🚀 Usage

1. **Generate certificates**:  
   Run the following command to generate self-signed certificates using `certgen.sh`:
   ```bash
   docker-compose -f create-certs.yml up --abort-on-container-exit
   ```

2. **Run the test suite**:  
   After the certificates are generated, run the test suite using the following command:
   ```bash
   ./test_runner.sh
   ```

   This script will:
   - Build the required images
   - Run the Java server and test client containers
   - Test the Java app over HTTPS, checking both text and JSON responses

   Results will be printed to stdout and summarized at the end.

---

## 📂 Files Overview

| File                     | Description                                                   |
|--------------------------|---------------------------------------------------------------|
| `certgen.sh`              | TLS certificate generation script                             |
| `create-certs.yml`        | Compose file for running the certificate generation container |
| `docker-compose.yml`      | Compose file for Java app and test client                     |
| `Server.java`             | Java server for handling HTTPS requests                       |
| `test_client.py`          | Python client to verify Java server functionality             |
| `Dockerfile.app`          | Multi-stage Dockerfile for building the Java app container    |
| `Dockerfile.testclient`   | Dockerfile for creating the Python test client container      |
| `test_runner.sh`          | Test runner script that iterates over image combinations      |
| `minimus_images.txt`      | List of images for testing various configurations             |

---

## ✅ Output Example

```bash
[INFO] Starting Java server over HTTPS...
[INFO] Waiting for the app to become available...
[SUCCESS] Received: ✅ Hello over HTTPS from Java TLS Server!
[INFO] Received JSON response: {"message": "Hello from the server!", "status": "success"}
```

---

## 📜 License

Minimus internal use only.