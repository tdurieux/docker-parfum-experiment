# build server base image

FROM golang:1.18-alpine3.13

RUN apk add --no-cache build-base
RUN apk add --no-cache openssh
RUN apk add --no-cache make
RUN apk add --no-cache git
RUN apk add --no-cache --update docker openrc
RUN rc-update add docker boot