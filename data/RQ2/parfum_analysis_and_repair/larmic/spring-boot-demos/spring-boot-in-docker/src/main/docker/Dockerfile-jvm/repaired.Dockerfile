# Build spring boot app
FROM eclipse-temurin:18 as app-build

COPY mvnw .
COPY .mvn/ .mvn/
COPY pom.xml .

# Maven should be executable
RUN chmod +x ./mvnw

# Download dependencies if needed (i.e. pom has changed)
RUN ./mvnw dependency:go-offline -B

# Copy application sources to docker build stage
COPY src src

# Build artifact
RUN ./mvnw package -DskipTests
RUN mv target/*.jar target/spring-boot-app.jar


# Build Spring Boot docker image using eclipse-temurin:17
FROM eclipse-temurin:18

MAINTAINER Lars Michaelis <mail@larmic.de>

# Container should run in non-root user mode
ENV USER_NAME="change-me"
ENV USER_UID=999
ENV USER_GID=999

# Copy application from app-build docker stage
COPY --from=app-build /target/spring-boot-app.jar .

# Create non-root user