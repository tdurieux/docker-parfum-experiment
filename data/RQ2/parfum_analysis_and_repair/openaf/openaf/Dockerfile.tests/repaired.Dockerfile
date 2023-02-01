FROM openjdk:8-jdk-alpine

# Update SSL certificates
RUN apk update\
 && apk add --no-cache ca-certificates wget\
 && update-ca-certificates\
 && apk --no-cache add openssl wget

RUN mkdir /openaf

COPY openaf.jar /openaf/openaf.jar
COPY openaf.jar.orig /openaf/openaf.jar.orig
COPY tests /openaf/tests
COPY js /openaf/js

RUN cd /openaf\
 && java -jar openaf.jar --install\
 && /openaf/opack install ojob-common

WORKDIR /openaf