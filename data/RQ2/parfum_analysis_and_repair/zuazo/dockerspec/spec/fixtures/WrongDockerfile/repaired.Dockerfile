FROM alpine:3.2

RUN apk add --no-cache --update wrong-package-name
