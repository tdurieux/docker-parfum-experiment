# build stage build the jar with all our resources
FROM maven:3-openjdk-11 as build

VOLUME /tmp
WORKDIR /build

COPY pom.xml .
RUN mvn dependency:go-offline

ADD src/ /build/src/
RUN mvn package

# package stage