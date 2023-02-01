FROM alpine:latest

RUN apk update
RUN apk add --no-cache lua5.3

COPY run.sh /var/run/
