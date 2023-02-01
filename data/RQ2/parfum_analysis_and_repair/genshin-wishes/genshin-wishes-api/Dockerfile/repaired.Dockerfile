### STAGE 1: Build ###
FROM maven:3.6.3-openjdk-15-slim AS build
RUN mkdir -p /workspace
WORKDIR /workspace
COPY pom.xml /workspace
COPY src /workspace/src
RUN mvn -f pom.xml clean package -Dmaven.test.skip=true

### STAGE 2: Run ###