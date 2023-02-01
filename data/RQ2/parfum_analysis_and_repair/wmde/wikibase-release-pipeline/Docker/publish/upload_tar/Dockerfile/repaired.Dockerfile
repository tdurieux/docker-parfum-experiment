FROM alpine:latest

RUN apk add --no-cache --update openssh

COPY publish.sh publish.sh
RUN mkdir /uploads
ENTRYPOINT sh /publish.sh