####
# This Dockerfile is used in order to build a container that runs the Quarkus application in native (no JVM) mode
#
# Before building the docker image run:
#
# mvn package -Pnative -Dquarkus.native.container-build=true
#
# Then, build the image with:
#
# docker build -f src/main/docker/Dockerfile.native -t quarkus/microprofile-health-quickstart .
#
# Then run the container using:
#
# docker run -i --rm -p 8080:8080 quarkus/microprofile-health-quickstart
#
###
FROM registry.access.redhat.com/ubi8/ubi-minimal:8.1
WORKDIR /work/
COPY build/*-runner /work/application

# set up permissions for user `1001`