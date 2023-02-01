# builder
FROM golang:latest AS builder
WORKDIR /client
COPY . .
RUN make tidy
RUN env GOARCH=386 GOOS=linux CGO_ENABLED=0 make client

# runner