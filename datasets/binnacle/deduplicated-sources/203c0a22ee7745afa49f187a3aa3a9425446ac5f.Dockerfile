# From base OS image
# docker build -t eason02/filebeat-alpine:5.6.3
FROM alpine:3.6

MAINTAINER Eason Lau <eason.lau02@hotmail.com>

ENV FILEBEAT_VERSION=5.6.3

COPY ./config/filebeat.yml /

RUN apk add --update-cache curl && \
    rm -rf /var/cache/apk/* && \
    curl https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz -o /filebeat.tar.gz && \
    tar xzvf filebeat.tar.gz && \
    rm filebeat.tar.gz && \
    mv filebeat-${FILEBEAT_VERSION}-linux-x86_64 filebeat && \
    cd filebeat && \
    cp filebeat /usr/bin && \
    rm -rf /filebeat/filebeat.yml && \
    cp /filebeat.yml /filebeat/ && \
    ls -ltr /filebeat && \
    cat /filebeat/filebeat.yml

VOLUME /filebeat/data

WORKDIR /filebeat/
CMD ["filebeat","-e","filebeat.yml"]
