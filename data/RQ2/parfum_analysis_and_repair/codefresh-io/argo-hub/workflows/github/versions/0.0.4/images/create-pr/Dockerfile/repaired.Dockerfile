FROM golang:alpine

RUN apk update
RUN apk add --no-cache git curl
RUN go install github.com/github/hub@latest

ENTRYPOINT hub
