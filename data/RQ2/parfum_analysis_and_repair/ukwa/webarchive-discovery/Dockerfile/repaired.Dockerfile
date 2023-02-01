# Build in a Maven image:
FROM maven:3-jdk-8 AS build-env

# Allow e.g. proxy setting via build-arg if needed:
ARG MAVEN_OPTS

WORKDIR /webarchive-discovery
COPY . .
#RUN mvn package -q -DskipTests
RUN mvn package -DskipTests

# Install the JARs in a clean image: