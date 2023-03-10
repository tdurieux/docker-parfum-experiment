# Use AdoptOpenJDK for base image.
# It's important to use OpenJDK 8u191 or above that has container support enabled.
# https://hub.docker.com/r/adoptopenjdk/openjdk8
# https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
FROM openjdk:8-slim
WORKDIR /app
ARG SERVICE_NAME
ENV SERVICE_NAME $SERVICE_NAME
# Copy the jar to the production image from the builder stage.
COPY service/${SERVICE_NAME}/target/osdu-gcp-service-${SERVICE_NAME}-*.jar osdu-gcp-service-${SERVICE_NAME}.jar
# Run the web service on container startup.