FROM golang:1.8-alpine

RUN apk add --no-cache git make musl-dev musl-utils gcc lvm2-dev btrfs-progs-dev
ENV GOPATH=/go
WORKDIR /go/src/github.com/bblfsh/tools