#Build stage
FROM maven:3.6.1-jdk-11 AS build-env

ADD . /rfc3161timestampingserver

WORKDIR rfc3161timestampingserver

RUN mvn -U compile package assembly:single

# Run it