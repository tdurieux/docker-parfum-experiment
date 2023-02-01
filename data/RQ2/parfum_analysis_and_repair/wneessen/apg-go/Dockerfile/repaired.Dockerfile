## Build first
FROM golang:latest as builder
RUN mkdir /builddir
ADD . /builddir/
WORKDIR /builddir
RUN CGO_ENABLED=0 go build -a -installsuffix cgo -ldflags '-w -s -extldflags "-static"' -o apg-go \
    github.com/wneessen/apg-go/cmd/apg

## Create scratch image