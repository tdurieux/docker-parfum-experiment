# Build JPetStore war
FROM openjdk:8 as builder
COPY . /src
WORKDIR /src
RUN ./build.sh all

# Use WebSphere Liberty base image from the Docker Store
FROM websphere-liberty:javaee7

# Copy war from build stage and server.xml into image