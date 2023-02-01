# Builder
FROM maven:3-jdk-8-slim AS builder

RUN mkdir /opt/jmqtt
WORKDIR /opt/jmqtt

ADD . ./

RUN mvn -Ppackage-all -DskipTests clean install -U

# App