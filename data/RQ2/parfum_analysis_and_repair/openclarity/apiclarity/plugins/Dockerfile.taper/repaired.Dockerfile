FROM golang:1.16.6-alpine AS builder

# Set necessary environment variables needed for our image.
ENV CGO_ENABLED=1 GOOS=linux GOARCH=amd64

RUN apk add --no-cache libpcap-dev gcc g++ make bash

WORKDIR /plugins

COPY api ./api
COPY common ./common

WORKDIR /plugins/taper

COPY taper/go.* ./
RUN go mod download

ARG VERSION
COPY taper .
RUN go build -ldflags="-s -w \
     -X 'github.com/openclarity/apiclarity/plugins/taper/version.Version=${VERSION}'" -o agent .

WORKDIR /plugins/taper/extensions/http

COPY taper/extensions/http .
RUN go build -buildmode=plugin -o ../http.so .

FROM alpine:3.14

RUN apk add --no-cache bash libpcap-dev tcpdump
WORKDIR /app

# Copy binary and config files from /build to root folder of scratch container.
COPY --from=builder ["/plugins/taper/agent", "."]
COPY --from=builder ["/plugins/taper/extensions/http.so", "extensions/http.so"]

ENTRYPOINT ["/app/agent"]