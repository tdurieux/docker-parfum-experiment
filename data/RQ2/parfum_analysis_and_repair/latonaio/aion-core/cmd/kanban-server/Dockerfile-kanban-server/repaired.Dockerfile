# syntax = docker/dockerfile:experimental
# Build Container
FROM golang:1.13.5 as kanban-server-builder

ENV GO111MODULE on
WORKDIR /go/src/bitbucket.org/latonaio

COPY go.mod .

RUN go mod download

COPY . .

RUN go build -o kanban-server ./cmd/kanban-server


# Runtime Container