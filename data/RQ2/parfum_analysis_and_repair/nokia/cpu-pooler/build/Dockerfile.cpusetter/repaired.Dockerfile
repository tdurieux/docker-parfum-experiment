# Build stage
FROM golang:1.16.6-alpine3.14 AS build-env
ARG PLUGIN_PATH=github.com/nokia/CPU-Pooler

RUN apk add --no-cache curl git
WORKDIR ${GOPATH}/src/${PLUGIN_PATH}
ADD go.* ./
RUN go mod download
ADD . ./
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' -o cpusetter ${PLUGIN_PATH}/cmd/cpusetter


# Final image creation
FROM alpine:latest

ARG PLUGIN_PATH=github.com/nokia/CPU-Pooler
RUN apk add --no-cache util-linux
COPY --from=build-env /go/src/${PLUGIN_PATH}/cpusetter /

ENTRYPOINT ["/cpusetter"]
