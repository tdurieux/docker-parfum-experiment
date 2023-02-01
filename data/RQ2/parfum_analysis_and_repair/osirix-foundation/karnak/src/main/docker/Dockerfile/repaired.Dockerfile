# To build, run the following command from the top level project directory:
#
# docker build -t osirixfoundation/karnak:latest -f src/main/docker/Dockerfile .

# Based on build image containing maven, jdk and git
FROM maven:3.8-eclipse-temurin-17 as builder
ARG JAR_FILE=target/karnak*.jar
WORKDIR /app
COPY ${JAR_FILE} application.jar
RUN java -Djarmode=layertools -jar application.jar extract

# Build the final deployment image