# Multistage - Builder
FROM maven:3.6.3-jdk-11-slim as s3proxy-builder
LABEL maintainer="Andrew Gaul <andrew@gaul.org>"

WORKDIR /opt/s3proxy
COPY . /opt/s3proxy/

RUN mvn package -DskipTests

# Multistage - Image