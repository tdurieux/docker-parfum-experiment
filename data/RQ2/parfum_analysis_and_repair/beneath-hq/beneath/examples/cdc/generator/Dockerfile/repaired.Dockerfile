# Create builder image
FROM gradle:7.3.3-jdk17-alpine as builder
WORKDIR /app
COPY build.gradle settings.gradle .
COPY src src
RUN gradle --no-daemon build

# Create run image