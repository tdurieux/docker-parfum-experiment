# build stage
FROM golang:alpine AS build-env
RUN apk update && apk upgrade && \
    apk add --no-cache git

WORKDIR $GOPATH/src/github.com/autocert/controller
COPY go.mod go.sum ./
COPY controller/client.go controller/main.go ./
RUN go build -o /server .

# final stage