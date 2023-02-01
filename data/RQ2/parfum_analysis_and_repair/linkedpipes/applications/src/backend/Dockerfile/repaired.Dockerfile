# Using OpenJDK 11
FROM gradle:5.6.4-jdk11 as builder

# Tomcat will eventually create directories here
VOLUME /tmp

# copy files
COPY --chown=gradle . /app
WORKDIR /app

# build the app
RUN gradle unpack

FROM openjdk:11-jre-slim

# Expose port 8080