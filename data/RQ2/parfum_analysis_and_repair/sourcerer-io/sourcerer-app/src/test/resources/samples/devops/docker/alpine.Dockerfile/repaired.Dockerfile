FROM alpine:3.4

RUN apk update
RUN apk add --no-cache vim
RUN apk add --no-cache curl
