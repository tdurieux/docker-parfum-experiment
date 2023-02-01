# This is a multi-staged Dockerfile that uses Maven builder image to build the whole project with Maven.
# In the second phase, the standalone Quarkus executable JAR is placed into an OpenJDK JRE image.
#
# Build an image:
# docker build -t optaweb/employee-rostering --ulimit nofile=98304:98304 .
#
# Run the image with default profile (using in-memory H2 database):
# docker run -p 8080:8080 --rm -it optaweb/employee-rostering
#
# Run the image with production profile (using PostgreSQL database):
# docker run -p 8080:8080 --rm -it -e QUARKUS_PROFILE=production optaweb/employee-rostering