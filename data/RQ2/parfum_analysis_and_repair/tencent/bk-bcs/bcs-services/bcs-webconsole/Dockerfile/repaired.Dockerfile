# FROM golang:alpine AS builder
# ENV CGO_ENABLED=0 GOOS=linux
# WORKDIR /go/src/bcs-webconsole
# RUN apk --update --no-cache add ca-certificates gcc libtool make musl-dev protoc
# COPY Makefile go.mod go.sum ./
# RUN go mod download
# COPY . .
# RUN make tidy build