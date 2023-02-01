####
# This Dockerfile is used in order to build a container that runs the Quarkus application in native (no JVM) mode
#
# Before building the docker image run:
#
# mvn package -Pnative -Dquarkus.native.container-build=true
#
# Then, build the image with:
#
# docker build -f src/main/docker/Dockerfile.native -t optaplanner/activemq-school-timetabling .
#
# Then run the container using:
#
# docker run -i --rm --network host optaplanner/activemq-school-timetabling
#
###