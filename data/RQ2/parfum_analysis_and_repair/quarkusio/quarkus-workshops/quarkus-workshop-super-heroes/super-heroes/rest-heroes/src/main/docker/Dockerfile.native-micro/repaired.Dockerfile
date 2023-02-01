####
# This Dockerfile is a multi-stage Docker build.
# It allows building the native executable directly in a container without having a final container containing the build tools.
# That approach is possible with a multi-stage Docker build:
#   1. The first stage builds the native executable using Maven or Gradle
#   2. The second stage is a minimal image copying the produced native executable
#
# Before building the container image run:
#
# ./mvnw package -Pnative
#
# Then, build the image with:
#
# docker build -f src/main/docker/Dockerfile.native-micro -t quarkus/rest-heroes .
#
# Then run the container using:
#
# docker run -i --rm -p 8080:8080 quarkus/rest-heroes
#
###