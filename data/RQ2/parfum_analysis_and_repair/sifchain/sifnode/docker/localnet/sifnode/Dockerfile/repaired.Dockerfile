#
# Build
#
FROM golang:1.17 AS build

ENV GOBIN=/go/bin
ENV GOPATH=/go
ENV CGO_ENABLED=0
ENV GOOS=linux

WORKDIR /sif
COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN make install

#
# Main
#