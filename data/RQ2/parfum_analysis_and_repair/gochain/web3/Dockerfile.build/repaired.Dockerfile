FROM golang:1.17-alpine AS build-env
RUN apk --no-cache add build-base git mercurial gcc linux-headers