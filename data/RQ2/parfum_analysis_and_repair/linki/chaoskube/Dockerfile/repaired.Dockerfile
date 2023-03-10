# builder image
FROM golang:1.18-alpine3.16 as builder

ENV CGO_ENABLED 0
RUN apk --no-cache add alpine-sdk
WORKDIR /go/src/github.com/linki/chaoskube
COPY . .
RUN go test -v ./...
RUN go build -o /usr/local/bin/chaoskube -v \
  -ldflags "-X main.version=$(git describe --tags --always --dirty) -w -s"
RUN /usr/local/bin/chaoskube --version

# final image