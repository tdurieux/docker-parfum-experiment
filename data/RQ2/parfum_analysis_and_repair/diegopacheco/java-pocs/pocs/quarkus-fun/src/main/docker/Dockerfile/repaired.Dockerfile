####
# Before building the docker image run:
#
# mvn package -Pnative -Dnative-image.docker-build=true
#
# Then, build the image with:
#
# docker build -f src/main/docker/Dockerfile -t quarkus/getting-started .
#
# Then run the container using:
#
# docker run -i --rm -p 8080:8080 quarkus/getting-started
#
###