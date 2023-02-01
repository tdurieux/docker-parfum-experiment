####
# This Dockerfile is used in order to build a container that runs the Quarkus application in JVM mode
#
# Before building the docker image run:
#
# ./gradlew assemble
#
# Then, build the image with:
#
# docker build -f src/main/docker/Dockerfile.jvm -t trellisldp/trellis-<name-of-image> .
#
# Then run the container using:
#
# docker run -i --rm -p 8080:8080 trellisldp/trellis-<name-of-image>
#
###