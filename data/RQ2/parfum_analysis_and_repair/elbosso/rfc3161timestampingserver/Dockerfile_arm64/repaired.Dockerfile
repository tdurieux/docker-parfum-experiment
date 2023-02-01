#Build stage
FROM arm64v8/maven AS build-env

ADD . /rfc3161timestampingserver

WORKDIR rfc3161timestampingserver

RUN mvn -U compile package assembly:single

# Run it