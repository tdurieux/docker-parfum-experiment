####
# This Dockerfile is used in order to build a container that runs the Quarkus application in JVM mode
#
# Before building the docker image run:
#
# mvn package
#
# Then, build the image with:
#
# docker build -f src/main/docker/Dockerfile.jvm -t quarkus/debezium-auditing-demo-jvm .
#
# Then run the container using:
#
# docker run -i --rm -p 8080:8080 quarkus/debezium-auditing-demo-jvm
#
###
# FROM fabric8/java-alpine-openjdk8-jre