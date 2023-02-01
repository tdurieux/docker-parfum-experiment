# build docui
FROM golang:1.16.0 AS build-docui
ENV GOOS linux
ENV GOARCH amd64
ENV CGO_ENABLED 0
COPY . ./src/github.com/skanehira/docui
WORKDIR /go/src/github.com/skanehira/docui
RUN go build

# copy artifact from the build stage