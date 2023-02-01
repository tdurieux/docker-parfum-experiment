# build stage
FROM golang:alpine AS build-env
RUN apk add --no-cache git
ADD . /src
RUN cd /src/cmd/decode-web && go build -o decode-web

# final stage