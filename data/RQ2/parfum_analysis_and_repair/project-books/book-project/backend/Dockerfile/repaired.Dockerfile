# Create jar
FROM maven:3.8.3-openjdk-11-slim AS builder
WORKDIR /app
COPY . /app
ARG mvn_arg="clean package -DskipTests"

RUN --mount=type=cache,target=/root/.m2 mvn -f /app/pom.xml $mvn_arg

# Run jar