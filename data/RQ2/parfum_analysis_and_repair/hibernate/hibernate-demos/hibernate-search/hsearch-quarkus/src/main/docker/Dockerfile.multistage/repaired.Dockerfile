####
# This Dockerfile is used in order to build a container that runs the Quarkus application in native (no JVM) mode
# WITHOUT requiring to have GraalVM installed locally.
#
# To build the image, run:
#
# docker build -f src/main/docker/Dockerfile.multistage -t quarkus/hsearch-quarkus .
#
# Then run the container using:
#
# docker run -i --rm -p 8080:8080 quarkus/hsearch-quarkus
#
###

## Stage 1 : build with maven builder image with native capabilities
FROM quay.io/quarkus/centos-quarkus-maven:19.2.1 AS build
COPY src/main /usr/src/app/src/main
COPY pom.xml /usr/src/app
USER root
RUN chown -R quarkus /usr/src/app
USER quarkus
RUN mvn -f /usr/src/app/pom.xml -Pnative clean package

## Stage 2 : create the docker final image
FROM registry.access.redhat.com/ubi8/ubi-minimal
WORKDIR /work/
COPY --from=build /usr/src/app/target/*-runner /work/application
RUN chmod 775 /work
EXPOSE 8080

# Startup script that waits for backends to be ready