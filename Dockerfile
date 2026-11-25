
# Stage 1: Build the Java application
FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app

# Copy Maven configuration
COPY pom.xml .

# Copy application source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Stage 2: Run the application
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy the generated JAR
COPY --from=build /app/target/*.jar app.jar

# Application port
EXPOSE 8080

# Start the Java application
CMD ["java", "-jar", "app.jar"]
