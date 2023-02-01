# Build stage
FROM maven:3-openjdk-11-slim AS build
COPY pom.xml /

RUN mvn -B package


# Package stage