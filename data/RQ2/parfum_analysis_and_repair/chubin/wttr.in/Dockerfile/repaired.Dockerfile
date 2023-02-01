# Build stage
FROM golang:1-alpine as builder

WORKDIR /app

COPY ./share/we-lang/we-lang.go /app
COPY ./share/we-lang/go.mod /app

RUN apk add --no-cache git


RUN go get -u github.com/mattn/go-colorable && \
    go get -u github.com/klauspost/lctime && \
    go get -u github.com/mattn/go-runewidth && \
    CGO_ENABLED=0 go build /app/we-lang.go
# Results in /app/we-lang