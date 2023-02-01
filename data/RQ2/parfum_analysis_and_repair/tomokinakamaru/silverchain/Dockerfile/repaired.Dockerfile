# Build JAR
FROM openjdk:8-jdk-alpine as builder

COPY . /src

RUN cd /src && \
    sh gradlew --no-daemon --info shadowJar && \
    mv $(find build/libs -name '*.jar') /silverchain.jar


# Main