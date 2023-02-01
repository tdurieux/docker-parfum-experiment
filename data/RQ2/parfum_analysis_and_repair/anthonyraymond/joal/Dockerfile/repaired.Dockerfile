# Builder image with jdk
FROM maven:3.8.3-eclipse-temurin-11 AS build

WORKDIR /build

COPY . /build/

RUN mvn -B --quiet package -DskipTests=true \
    && mkdir /artifact \
    && mv /build/target/jack-of-all-trades-*.jar /artifact/joal.jar


# Actual joal image with jre only