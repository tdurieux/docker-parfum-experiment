FROM golang:1.17.8-alpine3.14 AS builder

## Note: this Dockerfile will only be built from the plugins context

RUN apk add --update --no-cache gcc g++

WORKDIR /plugins
COPY api ./api

WORKDIR /plugins/common

COPY common/go.* ./
RUN go mod download

COPY common ./

WORKDIR /plugins/gateway/kong
COPY gateway/kong/go.* ./

RUN go mod download

COPY gateway/kong .

# Build the plugin.
RUN go build -o bin/kong-plugin plugin.go

FROM busybox
COPY --from=builder ["/plugins/gateway/kong/bin/kong-plugin", "/kong-plugin"]