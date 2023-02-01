# build
FROM golang:alpine AS build
RUN apk --no-cache add curl build-base gcc
ADD . /src
WORKDIR /src
RUN make build

# final