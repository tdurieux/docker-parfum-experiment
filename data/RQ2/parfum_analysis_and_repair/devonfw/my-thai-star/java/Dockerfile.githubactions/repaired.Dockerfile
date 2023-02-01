# 1. Build
FROM maven:3.6-jdk-11 AS build
WORKDIR /app
COPY java/mtsj/. /app
RUN mvn clean install

# 2. Deploy Java war