#
# Build stage
#
FROM maven:3.6.0-jdk-8-slim AS build
WORKDIR /build
COPY pom.xml .
COPY src ./src
RUN mvn clean package

#
# Package stage
#