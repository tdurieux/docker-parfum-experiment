# build stage
FROM golang:latest AS build-stage
WORKDIR /go/src/github.com/dairycart/dairycart

ADD . .
RUN go build -o /dairycart github.com/dairycart/dairycart/cmd/server/v1

# final stage