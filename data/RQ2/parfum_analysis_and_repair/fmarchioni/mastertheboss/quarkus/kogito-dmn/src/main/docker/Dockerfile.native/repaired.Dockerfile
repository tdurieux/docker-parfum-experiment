####
# This Dockerfile is used in order to build a container that runs the Quarkus application in native (no JVM) mode
#
# Before building the container image run:
#
# ./mvnw package -Pnative
#
# Then, build the image with:
#
# docker build -f src/main/docker/Dockerfile.native -t quarkus/kogito-dmn-quickstart .
#
# Then run the container using:
#
# docker run -i --rm -p 8080:8080 quarkus/kogito-dmn-quickstart
#
###