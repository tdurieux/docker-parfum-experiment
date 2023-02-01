# Compiling Katan
FROM openjdk:8-jdk-alpine AS TEMP_BUILD_IMAGE
ENV BUILD_HOME=/usr/katan-build/
COPY . $BUILD_HOME

WORKDIR $BUILD_HOME
USER root
RUN ./gradlew katan-bootstrap:shadowJar

# Production build