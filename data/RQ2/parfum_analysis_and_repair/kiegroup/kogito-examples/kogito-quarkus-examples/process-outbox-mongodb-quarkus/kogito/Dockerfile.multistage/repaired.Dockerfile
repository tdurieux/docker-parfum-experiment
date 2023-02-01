## Stage 1 : build with maven builder image with native capabilities
FROM quay.io/quarkus/ubi-quarkus-native-image:21.2.0-java11 AS build
COPY --chown=quarkus target/base/pom.xml /code/pom.xml
COPY --chown=quarkus target/base/mvnw /code/mvnw
COPY --chown=quarkus target/base/.mvn /code/.mvn
COPY --chown=quarkus target/pom.xml /code/kogito/
RUN chmod 775 /code/mvnw
USER quarkus
WORKDIR /code/kogito
# RUN ../mvnw -B org.apache.maven.plugins:maven-dependency-plugin:3.1.2:go-offline
COPY --chown=quarkus target/src /code/kogito/src
RUN ../mvnw package -Pmultistage

## Stage 2 : create the docker final image
FROM registry.access.redhat.com/ubi8/ubi-minimal:8.4
WORKDIR /work/
COPY --from=build /code/kogito/target/*-runner /work/application

# set up permissions for user `1001`