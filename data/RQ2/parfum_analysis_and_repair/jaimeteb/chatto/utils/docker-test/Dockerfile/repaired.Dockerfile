FROM golang:1.15-alpine

RUN apk add --no-cache --update alpine-sdk

WORKDIR /testdir
COPY . .

RUN go mod download
ENTRYPOINT go test -race ./... -cover
