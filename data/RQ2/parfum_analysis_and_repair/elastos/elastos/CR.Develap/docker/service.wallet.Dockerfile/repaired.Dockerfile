# Wallet Service - elastos.org
# This is an official but unsupported docker image

FROM maven:3.6.0-jdk-8-alpine AS builder

LABEL maintainer="kpachhai"

RUN apk update

# copy folders
COPY service.wallet /restful-services/wallet-service

RUN cd /restful-services/wallet-service \
    && mvn clean                        \
    && mvn install -Dmaven.test.skip -Dgpg.skip

# Maven 3.6.0