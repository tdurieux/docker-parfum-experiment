FROM openjdk:17.0.2-slim

# Set image information, but could be set to different location from command line
ARG IMAGE_VERSION="0.0.1-SNAPSHOT"
ARG IMAGE_NAME="Image Service"
ARG MAINTAINER="Hristijan Dimitrieski <hristijan.dimitrieski@gmail.com>"

LABEL version=${IMAGE_VERSION} name=${IMAGE_NAME} maintainer=${MAINTAINER}

ADD ./target/image-service.jar image-service.jar

# Expose the service to port 8080
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "/image-service.jar"]
