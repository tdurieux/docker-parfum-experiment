####
# This Dockerfile is used in order to build a container that runs the Quarkus application in native (no JVM) mode
#
# Before building the docker image run:
#
# mvn package -Pnative -Dnative-image.docker-build=true
#
# Then, build the image with:
#
# docker build -f src/main/docker/Dockerfile.native -t quay.io/kiegroup/jit-runner-native .
#
# Then run the container using:
#
# docker run -i --rm -p 8080:8080 quay.io/kiegroup/jit-runner-native
#
###