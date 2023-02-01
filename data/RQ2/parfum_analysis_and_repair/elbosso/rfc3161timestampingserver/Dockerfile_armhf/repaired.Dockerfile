#Build stage
FROM arm32v7/maven AS build-env

ADD . /rfc3161timestampingserver

WORKDIR rfc3161timestampingserver

RUN mvn -U compile package assembly:single

# Run it