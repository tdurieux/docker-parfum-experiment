# Use the official AdoptOpenJDK for a base image.
# https://hub.docker.com/_/openjdk
FROM openjdk:8-slim
WORKDIR /app
ARG PROVIDER_NAME
ENV PROVIDER_NAME $PROVIDER_NAME
# Copy the jar to the production image from the builder stage.
COPY provider/workflow-${PROVIDER_NAME}/target/workflow-${PROVIDER_NAME}-*.jar workflow-${PROVIDER_NAME}.jar
# Run the web service on container startup.