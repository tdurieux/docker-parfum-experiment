############################
# STEP 0 get dependencies
############################
FROM golang:1.16.5 AS dependencies
WORKDIR /go/src
COPY go.mod .
COPY go.sum .
RUN go mod download
############################
# STEP 1 build executable binary
############################
FROM dependencies AS builder
##
ENV GO111MODULE=on \
  CGO_ENABLED=0 \
  GOOS=linux \
  GOARCH=amd64

WORKDIR /go/src
COPY . .
##
RUN go build -o /bin/mock .
############################
# STEP 2 build a small image
############################