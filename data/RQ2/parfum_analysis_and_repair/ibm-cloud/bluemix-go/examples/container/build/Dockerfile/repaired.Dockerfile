FROM golang:alpine
RUN apk update
RUN apk add --no-cache build-base git bash
