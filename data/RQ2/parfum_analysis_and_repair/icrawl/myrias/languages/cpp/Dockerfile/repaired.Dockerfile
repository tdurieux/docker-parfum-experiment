FROM alpine:latest
LABEL author="1Computer1"

RUN apk update
RUN apk add --no-cache g++

COPY run.sh /var/run/
