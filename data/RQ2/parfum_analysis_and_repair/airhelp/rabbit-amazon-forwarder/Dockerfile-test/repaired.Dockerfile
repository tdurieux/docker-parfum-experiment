FROM golang:1.18-alpine

WORKDIR /go/src/github.com/AirHelp/rabbit-amazon-forwarder

RUN apk --no-cache add git gcc musl-dev

COPY go.mod go.sum ./
RUN go mod tidy -go=1.18 -compat=1.18

COPY . .