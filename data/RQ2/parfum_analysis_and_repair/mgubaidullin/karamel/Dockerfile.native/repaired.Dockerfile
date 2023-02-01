## Stage 1 : build with maven builder image with native capabilities
FROM quay.io/quarkus/centos-quarkus-maven:20.3.0-java11 AS build
COPY maven/pom.xml /usr/src/app/pom.xml
RUN mvn -f /usr/src/app/pom.xml -B de.qaware.maven:go-offline-maven-plugin:1.2.5:resolve-dependencies
COPY maven/src /usr/src/app/src
USER root
RUN chown -R quarkus /usr/src/app
USER quarkus
RUN mvn -f /usr/src/app/pom.xml -Pnative clean package -Dquarkus.package.type=native

## Source of libs
FROM debian:stable-slim AS lib-env

## Stage 2 : create the docker final image