# Build
FROM openjdk:8-jdk-alpine as build
WORKDIR /root/application
COPY . .
RUN ./gradlew clean build installDist

# Image