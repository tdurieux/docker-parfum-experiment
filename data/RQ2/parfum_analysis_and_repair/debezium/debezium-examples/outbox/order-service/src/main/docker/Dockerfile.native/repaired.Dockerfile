####
# This Dockerfile is used in order to build a container that runs order-service-quarkus in native (non-JVM) mode
#
# Before building the docker image run:
#
# mvn package -Pnative -Dnative-image.docker-build=true
#
# Then, build the image with:
#
# docker build -f src/main/docker/Dockerfile.native -t quarkus/order-service-quarkus .
#
# Then run the containeer using:
#
# docker run -i --rm -p 8080:8080 quarkus/order-service-quarkus
#
###