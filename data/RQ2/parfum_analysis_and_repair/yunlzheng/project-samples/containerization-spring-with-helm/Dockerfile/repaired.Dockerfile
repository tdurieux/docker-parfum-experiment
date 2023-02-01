# Build
FROM maven:3.5.0-jdk-8-alpine AS builder

ADD ./pom.xml pom.xml
ADD ./src src/
RUN mvn clean package


# Package
FROM java:8

ADD entrypoint.sh entrypoint.sh
#ADD target/gs-spring-boot-0.1.0.jar gs-spring-boot-0.1.0.jar