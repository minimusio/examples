# Step 1: Build the server using a JDK image (for compilation)
#FROM openjdk:11-jdk-slim AS builder
FROM reg.mini.dev/openjdk:latest-dev AS builder


# Set working directory
WORKDIR /app

# Copy the Java source code
COPY Server.java .

# Compile the Java server
RUN javac Server.java

# Step 2: Run the server using a minimal JRE image
#FROM openjdk:11-jre-slim
FROM reg.mini.dev/openjre:latest-dev


# Set working directory
WORKDIR /app

# Copy the compiled .class file from the builder stage
COPY --from=builder /app/Server.class .

# Run the server
CMD ["java", "Server"]
