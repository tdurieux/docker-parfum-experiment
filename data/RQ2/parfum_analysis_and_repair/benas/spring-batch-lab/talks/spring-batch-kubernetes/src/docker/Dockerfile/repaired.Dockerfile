# use multi-stage build to optimize final image size
FROM maven:3.6.3-jdk-8-slim AS build
WORKDIR /tmp
COPY src/* ./src/main/
COPY pom.xml ./
RUN mvn package dependency:copy-dependencies

FROM openjdk:8-jre-alpine
# use separate layers for app/dependencies to re-use cached layers