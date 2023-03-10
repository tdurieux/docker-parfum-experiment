#Build stage 1
FROM maven:3.5.3-jdk-8 AS builder
MAINTAINER Hazem Ben Khalfallah <benkhalfallahhazem@gmail.com>

RUN mkdir /app
ADD . /app/
WORKDIR /app
RUN mvn package -Dskip.unit.tests=true -Dskip.integration.tests=true

#Setup stage 2
FROM openjdk:8-jre-alpine3.7
RUN apk add --no-cache bash

WORKDIR /app

COPY --from=builder /app/target/scrum_poker.jar .

EXPOSE 8080
# Define active profile