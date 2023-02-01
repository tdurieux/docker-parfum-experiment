# Packaging the gdv-xport-service.war
FROM maven:3.6.3-openjdk-8 AS build-env
COPY . .
RUN mvn -DskipTests package

# Starting the service