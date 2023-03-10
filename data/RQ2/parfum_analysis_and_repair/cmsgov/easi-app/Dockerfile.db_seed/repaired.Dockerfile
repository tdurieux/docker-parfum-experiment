FROM golang:1.16.6 AS base

WORKDIR /easi/

FROM base AS modules

COPY go.mod ./
COPY go.sum ./
RUN go mod download

FROM modules AS build

COPY cmd ./cmd
COPY pkg ./pkg

ENTRYPOINT ["go", "run", "cmd/devdata/main.go"]