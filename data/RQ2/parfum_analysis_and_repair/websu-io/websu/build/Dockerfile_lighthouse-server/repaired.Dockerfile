FROM golang:1.14 AS builder

WORKDIR /go/src/github.com/websu-io/websu
COPY go.mod go.sum ./
# Download dependencies and cache in docker layer
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build ./cmd/lighthouse-server && mv lighthouse-server /

FROM alpine:3.15
ENV USE_DOCKER=false
WORKDIR /opt/lighthouse

ARG LH_VERSION="9.4.0"
RUN apk --update-cache --no-cache \
     add npm chromium \
    && npm -g install lighthouse@$LH_VERSION && npm cache clean --force;

VOLUME /var/lighthouse
COPY --from=builder /lighthouse-server /opt/lighthouse/lighthouse-server

ENTRYPOINT ["/opt/lighthouse/lighthouse-server"]
EXPOSE 50051/tcp
