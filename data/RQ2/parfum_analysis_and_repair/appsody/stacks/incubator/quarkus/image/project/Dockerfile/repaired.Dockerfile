## Stage 1 : build with maven builder image with native capabilities
FROM quay.io/quarkus/centos-quarkus-maven:19.3.1-java11 AS build

COPY . /project
RUN cd /project && mvn -B install dependency:go-offline -DskipTests
# Install user-app dependencies
WORKDIR /project/user-app
COPY ./user-app/src ./src
COPY ./user-app/pom.xml ./
USER root
RUN chown -R quarkus .
USER quarkus
RUN mvn -B -Pnative clean package


## Stage 2 : create the docker final image