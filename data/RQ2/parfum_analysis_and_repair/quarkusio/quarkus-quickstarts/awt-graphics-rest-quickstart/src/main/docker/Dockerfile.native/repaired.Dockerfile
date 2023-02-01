####
# This Dockerfile is used in order to build a container that runs the Quarkus application in native (no JVM) mode
#
# Before building the container image run:
#
# ./mvnw package -Pnative
#
# or
#
# ./mvnw package -Pnative -Dquarkus.native.container-build=true -Dquarkus.native.builder-image=quay.io/quarkus/ubi-quarkus-mandrel:21.3-java11
#
# If you don't have necessary libraries installed locally.
#
# Then, build the image with:
#
# docker build -f src/main/docker/Dockerfile.native -t quarkus/awt-graphics-rest .
#
# Then run the container using:
#
# docker run -i --rm -p 8080:8080 quarkus/awt-graphics-rest
#
###