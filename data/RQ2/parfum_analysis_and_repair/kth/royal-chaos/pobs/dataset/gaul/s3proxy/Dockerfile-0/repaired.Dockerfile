# Multistage - Builder
FROM maven:3.5.0-jdk-7-alpine as s3proxy-builder
LABEL maintainer="Andrew Gaul <andrew@gaul.org>"

WORKDIR /opt/s3proxy
COPY . /opt/s3proxy/

RUN mvn package -DskipTests

# Multistage - Image