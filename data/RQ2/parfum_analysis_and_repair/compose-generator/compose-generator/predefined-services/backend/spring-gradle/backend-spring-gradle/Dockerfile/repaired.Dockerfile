# Builder
FROM gradle:7.4-jdk18 AS builder
WORKDIR /server
COPY *.gradle *.kts ./
RUN gradle build -q || return 0

COPY ./src ./src
RUN gradle build -w
RUN java -Djarmode=layertools -jar build/libs/demo-0.0.1-SNAPSHOT.jar extract


# Minimalistic image