FROM golang:1.16-alpine

WORKDIR /src/
COPY * /src/

RUN apk add --no-cache --update alpine-sdk \
 && make \
 && mv bin/restockbot /usr/local/bin/restockbot \
 && rm -rf /src/*

WORKDIR /root/
