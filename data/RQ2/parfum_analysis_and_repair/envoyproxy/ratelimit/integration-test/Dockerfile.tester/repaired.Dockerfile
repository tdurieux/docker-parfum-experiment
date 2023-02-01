FROM alpine:latest

USER root

RUN apk update && apk upgrade && apk add --no-cache bash curl sed grep

ENTRYPOINT [ "bash" ]
