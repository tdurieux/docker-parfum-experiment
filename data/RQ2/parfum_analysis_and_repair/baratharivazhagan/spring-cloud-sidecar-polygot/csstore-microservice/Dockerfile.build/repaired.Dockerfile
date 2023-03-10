# Builder stage
FROM maven:3.6.3-jdk-8-slim as builder
WORKDIR /opt
COPY . /opt
RUN mvn clean install


# Final stage

FROM openjdk:8-jdk-alpine as final
# best practice is not to use root user