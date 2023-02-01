# Sidechain Service - elastos.org
# This is an official but unsupported docker image

FROM maven:3.6.0-jdk-8-alpine AS builder

LABEL maintainer="kpachhai"

RUN apk update

# copy folders
COPY service.sidechain /restful-services/sidechain-service

RUN sed -i 's#localhost:21606#privnet-sidechain-did-node:20606#g' /restful-services/sidechain-service/did.api/src/main/resources/application.properties
RUN sed -i 's#clark##g' /restful-services/sidechain-service/did.api/src/main/resources/application.properties
RUN sed -i 's#123456##g' /restful-services/sidechain-service/did.api/src/main/resources/application.properties
RUN sed -i 's#8091#8080#g' /restful-services/sidechain-service/did.api/src/main/resources/application.properties
RUN cd /restful-services/sidechain-service    \
    && mvn clean                        \
    && mvn install -Dmaven.test.skip -Dgpg.skip

# Maven 3.6.0