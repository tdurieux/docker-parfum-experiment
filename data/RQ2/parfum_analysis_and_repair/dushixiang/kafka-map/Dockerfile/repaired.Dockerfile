#
# Build stage
#
FROM maven:3.6.0-jdk-11-slim AS build

WORKDIR /app

COPY src src
COPY pom.xml pom.xml
COPY LICENSE LICENSE

RUN mvn -f pom.xml clean package -Dmaven.test.skip=true


#
# Package stage
#