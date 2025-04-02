# Stage 1: Build the application
FROM gradle:8-jdk21 AS builder

WORKDIR /app

# Copy source code
COPY --chown=gradle:gradle . .

# Build the application
RUN gradle clean build -x test

# Stage 2: Run the application using a minimal OpenJDK image
FROM openjdk:21-jdk-slim

WORKDIR /app

# Copy the built JAR file from the builder stage
COPY --from=builder /app/build/libs/*.jar app.jar

# Expose the port (Spring Boot default is 8080)
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
