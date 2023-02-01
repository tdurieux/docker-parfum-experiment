##
## Build
##
FROM golang:1.16-alpine as build-env

COPY . /build
WORKDIR /build
RUN CGO_ENABLED=0 GOOS=linux go build -o gogdl-ng .

##
## Deploy
##