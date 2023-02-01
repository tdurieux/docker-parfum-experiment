FROM maven:alpine

RUN apk update && apk upgrade && \
  apk --update --no-cache add fontconfig ttf-dejavu bash git openssh openjdk8-jre
RUN mkdir -p /data
WORKDIR /data
