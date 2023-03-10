# Share the same base image to reduce layers used in testing
FROM openzipkin/jre-full:1.8.0_212
MAINTAINER OpenZipkin "http://zipkin.io/"

ENV ZIPKIN_VERSION 2.18.2

# Temporarily hard-code zipkin's configuration to a class that looks up the container's IP
ADD ZipkinConfigurationLoader.class /cassandra/build/classes/main/ZipkinConfigurationLoader.class
ENV CASSANDRA_VERSION=3.11.4 \
    JAVA=/usr/local/java/jre/bin/java \
    JVM_OPTS="-Dcassandra -Dcassandra.config.loader=ZipkinConfigurationLoader -Djava.net.preferIPv4Stack=true"

ADD install.sh /usr/local/bin/install
RUN /usr/local/bin/install

# cassandra complains if run as root