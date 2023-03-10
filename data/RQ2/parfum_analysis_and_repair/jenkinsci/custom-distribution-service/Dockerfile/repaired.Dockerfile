# Start with a base image containing Java runtime
FROM maven:3.6.0-jdk-8-alpine AS MAVEN_BUILD

# Add Maintainer Info
LABEL maintainer="sladynnunes98@gmail.com"

# Creates a build directory in the image and copies the pom.xml into it
COPY pom.xml /build/

# Copies the src directory into the build directory in the image.
COPY src /build/src/

# Copies the config directory into the build directory in the image.
COPY config /build/config/

# Set Workdir
WORKDIR /build/

# Runs the mvn package command to compile and package the application as an executable JAR
RUN mvn clean package spring-boot:repackage

FROM maven:3.6.0-jdk-8-alpine

# Create a new working directory in the image called /app