# Build stage
FROM golang:1.16.6-alpine3.14 AS build-env
ARG PLUGIN_PATH=github.com/nokia/CPU-Pooler

RUN apk add --no-cache curl git
WORKDIR ${GOPATH}/src/${PLUGIN_PATH}
ADD go.* ./
RUN go mod download
ADD . ./
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' -o cpu-device-webhook ${PLUGIN_PATH}/cmd/webhook


# Final image creation
FROM alpine:latest

ARG PLUGIN_PATH=github.com/nokia/CPU-Pooler
COPY --from=build-env /go/src/${PLUGIN_PATH}/cpu-device-webhook /

ENTRYPOINT ["/cpu-device-webhook"]
