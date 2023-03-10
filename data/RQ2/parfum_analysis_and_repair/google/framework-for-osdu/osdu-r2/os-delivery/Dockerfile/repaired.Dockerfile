# Use the official maven/java 8 image to create a build artifact.
# http://hub.docker.com/_/maven
FROM maven:3-jdk-8-alpine AS builder

# Copy local code to container image.
## Create all the needed folders
WORKDIR /app
COPY pom.xml .
COPY .m2/ .m2/
COPY delivery-core/ delivery-core/
COPY provider/ provider/

# Build a release artifact for the child project
RUN mvn -T2 package -DskipTests -B -s .m2/settings.xml

# Use the official AdoptOpenJDK for a base image.
# https://hub.docker.com/_/openjdk
FROM openjdk:8-slim
WORKDIR /app
ARG PROVIDER_NAME
ENV PROVIDER_NAME $PROVIDER_NAME
# Copy the jar to the production image from the builder stage.
COPY --from=builder /app/provider/delivery-${PROVIDER_NAME}/target/delivery-${PROVIDER_NAME}-*.jar delivery-${PROVIDER_NAME}.jar
# Run the web service on container startup.