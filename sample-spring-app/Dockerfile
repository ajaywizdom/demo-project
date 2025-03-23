# Stage 1: Build Stage
FROM maven:3.8.5-eclipse-temurin-17 AS builder
WORKDIR /app

# Leverage caching by copying only the pom.xml and resolving dependencies
COPY pom.xml ./
RUN mvn dependency:go-offline -B

# Copy the source code and build the project
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime Stage
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Add a non-root user for security purposes
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Copy the built artifact from the builder stage
COPY --from=builder /app/target/*.war app.war

# Configure a health check (optional but recommended)
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s \
  CMD curl --fail http://localhost:8080/actuator/health || exit 1

# Set the command to run the application
CMD ["java", "-jar", "app.war"]