FROM openjdk:8-jdk-alpine

RUN apk add --no-cache --update bash && rm -rf /var/cache/apk/*