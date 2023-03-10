FROM golang:1.14-alpine

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh && \
    go get -u github.com/cespare/reflex

WORKDIR /app

ADD . .

RUN go install ./...