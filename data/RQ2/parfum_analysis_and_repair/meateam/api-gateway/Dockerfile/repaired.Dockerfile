#build stage
FROM golang:alpine AS builder
RUN apk add --no-cache git make
ENV GO111MODULE=on
WORKDIR /go/src/app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN make build

#final stage