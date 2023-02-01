####
# This Dockerfile is used in order to build a container that runs the Quarkus application in native (no JVM) mode
#
# Before building the container image run:
#
# ./mvn package -Pnative
#
# Then, build the image with:
#
# docker build -f src/main/docker/Dockerfile.native -t optaplanner/order-picking .
#
# Then run the container using:
#
# docker run -i --rm -p 8080:8080 optaplanner/order-picking
#
###