# Stage 1: Build the application
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app

# Copy maven executable and pom.xml
COPY . .

# Run JUnit tests and package the application
# This step covers the "Test use JUnit" requirement implicitly via Maven
RUN mvn clean package -DskipTests=false

# Stage 2: Run the application
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Copy the jar from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose port 8080 for the app
EXPOSE 8080

# Configure Spring Boot to expose Prometheus metrics
ENV MANAGEMENT_ENDPOINTS_WEB_EXPOSURE_INCLUDE=health,info,prometheus
ENV MANAGEMENT_METRICS_EXPORT_PROMETHEUS_ENABLED=true

ENTRYPOINT ["java", "-jar", "app.jar"]
