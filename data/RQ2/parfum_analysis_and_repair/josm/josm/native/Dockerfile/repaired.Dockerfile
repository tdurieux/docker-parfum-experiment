FROM openjdk:8-jdk-alpine

RUN apk update && \
    apk add --no-cache apache-ant && \
    apk add --no-cache ttf-dejavu && \
    apk add --no-cache subversion && \
    apk add --no-cache git && \
    rm /var/cache/apk/*

COPY . /josm

RUN mkdir -p /josm/test/report

CMD cd /josm && \
    ant test-html -DnoJavaFX=true
