FROM golang:1.18-alpine

RUN apk update
RUN apk add --no-cache alpine-sdk

WORKDIR /testfixtures
COPY . .

RUN go mod download
