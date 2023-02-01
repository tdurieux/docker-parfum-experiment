FROM alpine:latest

RUN apk -U upgrade && apk add --no-cache shellcheck

RUN mkdir /code
WORKDIR /code
