# Blockchain2graph container.                                                                                                                                                                                     # Blockchain2graph container.
FROM openjdk:11-jre-slim
MAINTAINER Stéphane Traumat, stephane.traumat@gmail.com

# Install and configure blockchain2graph.
ARG JAR_FILE
ADD ${JAR_FILE} /app.jar

# Container port configuration.
EXPOSE 8080

# Container entry point configuration.