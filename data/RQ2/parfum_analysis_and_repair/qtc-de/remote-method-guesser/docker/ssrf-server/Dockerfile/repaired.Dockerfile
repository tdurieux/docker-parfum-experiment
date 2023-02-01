###########################################
###            Build Stage 1            ###
###########################################
FROM maven:3.8.2-openjdk-8 AS maven-builder
COPY ./resources/server /usr/src/app
WORKDIR /usr/src/app
RUN mvn clean package

###########################################
###            Build Stage 2            ###
###########################################
FROM alpine:latest AS jdk-builder
RUN set -ex \
    && apk add --no-cache openjdk9 \
    && /usr/lib/jvm/java-9-openjdk/bin/jlink --add-modules java.rmi,java.management.rmi,jdk.management.agent,jdk.naming.rmi,jdk.httpserver \
    --verbose --strip-debug --compress 2 --no-header-files --no-man-pages --module-path  /usr/lib/jvm/java-9-openjdk/jmods/ --output /jdk

###########################################
###          Container Stage            ###
###########################################