################################################################################
# Build stage 0: builder
################################################################################
FROM maven:3-jdk-11 AS builder

WORKDIR /usr/src/app

COPY . .

RUN mvn --batch-mode package -DskipTests -DskipITs; \
    mv /usr/src/app/target/campsite-booking-$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout).jar \
        /usr/src/app/target/app.jar

################################################################################
# Build stage 1: actual campsite-booking api image
################################################################################
FROM openjdk:11-jre-slim

LABEL \
    maintainer="Igor Baiborodine <igor@kiroule.com>" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.name="campsite-booking" \
    org.label-schema.vcs-url="https://github.com/igor-baiborodine/campsite-booking" \
    org.label-schema.usage="https://github.com/igor-baiborodine/campsite-booking/blob/master/README.md"

ENV APP_HOME /opt/campsite
ENV APP_USER campsite
ENV APP_GROUP campsite

RUN groupadd ${APP_GROUP}; \
    useradd -g ${APP_GROUP} ${APP_USER}

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        # su tool for easy step-down from root