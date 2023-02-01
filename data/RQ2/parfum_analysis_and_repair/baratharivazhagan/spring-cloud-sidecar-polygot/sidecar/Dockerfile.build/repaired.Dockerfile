# Builder stage
FROM maven:3.6.3-jdk-8-slim as builder
WORKDIR /opt
COPY . /opt
RUN mvn clean install


# Final stage