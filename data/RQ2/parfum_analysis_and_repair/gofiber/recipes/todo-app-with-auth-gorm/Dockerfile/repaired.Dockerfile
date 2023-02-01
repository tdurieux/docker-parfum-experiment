#build stage
FROM golang:alpine AS builder
WORKDIR /go/src/app
COPY . .
RUN go get -d -v . && go build -ldflags="-s -w" main.go

#final stage