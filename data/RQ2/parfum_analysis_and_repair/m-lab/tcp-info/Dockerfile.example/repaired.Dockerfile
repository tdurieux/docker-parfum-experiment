# Build example-eventsocket-client.
FROM golang:1.18-alpine as build
RUN apk --no-cache add git
COPY . /go/src/github.com/m-lab/tcp-info
WORKDIR /go/src/github.com/m-lab/tcp-info
RUN go get -v ./cmd/example-eventsocket-client && \
    go install ./cmd/example-eventsocket-client

# Put it in its own image.