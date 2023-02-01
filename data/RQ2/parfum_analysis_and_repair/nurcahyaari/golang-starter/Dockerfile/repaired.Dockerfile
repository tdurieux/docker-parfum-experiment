## BUILD STAGE
FROM golang:1.18-alpine as builder

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

WORKDIR /app/golang-stater

COPY . .

RUN go generate .
RUN go build -o app .

## DISTRIBUTION