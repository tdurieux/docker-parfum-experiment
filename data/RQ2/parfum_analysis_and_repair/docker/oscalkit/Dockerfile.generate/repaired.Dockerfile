FROM golang:1.13-alpine
RUN apk add --no-cache git
WORKDIR /go/src/github.com/docker/oscalkit/metaschema