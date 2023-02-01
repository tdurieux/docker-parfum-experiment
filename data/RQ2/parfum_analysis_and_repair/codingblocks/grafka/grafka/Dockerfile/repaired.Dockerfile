# Stage 1
FROM openjdk:11 as build
WORKDIR /app

COPY build.gradle settings.gradle gradlew gradle /app/

COPY . ./
RUN sh /app/gradlew build

# Stage 2