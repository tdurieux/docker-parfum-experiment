# Build
FROM openjdk:8-jdk as baseimage

WORKDIR swagger-brake
COPY . .
RUN sh gradlew clean build shadowJar

# Actual container