## Stage 1 : build with maven builder image with native capabilities
FROM quay.io/quarkus/centos-quarkus-maven:19.2.1 AS build
RUN mkdir -p /tmp/ssl-libs/lib \
  && cp /opt/graalvm/jre/lib/security/cacerts /tmp/ssl-libs \
  && cp /opt/graalvm/jre/lib/amd64/libsunec.so /tmp/ssl-libs/lib/
COPY src /usr/src/app/src
COPY pom.xml /usr/src/app
USER root
RUN chown -R quarkus /usr/src/app
USER quarkus
RUN mvn -f /usr/src/app/pom.xml -Pnative clean package

## Stage 2 : create the docker final image