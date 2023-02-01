FROM openjdk:8-jdk-alpine
RUN apk --no-cache update \
  && apk add --no-cache --update bash jq ca-certificates curl openssl \
  && update-ca-certificates