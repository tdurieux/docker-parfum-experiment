FROM golang:1.18 AS golang-base

WORKDIR /go/src/github.com/furiko-io/furiko
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
        go build \
        -a -v \
        -o build/execution-controller \
        /go/src/github.com/furiko-io/furiko/cmd/execution-controller && \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
        go build \
        -a -v \
        -o build/execution-webhook \
        /go/src/github.com/furiko-io/furiko/cmd/execution-webhook

FROM alpine:3.15.0

RUN addgroup -S furiko-io && adduser -S furiko -G furiko-io
WORKDIR /home/furiko

# Install various tools in the base image.
# NOTE(irvinlim): This installs the latest tz database at time of build.
RUN apk add --update --no-cache ca-certificates tzdata && \
    rm -rf /var/cache/apk/*

# Add built binaries
COPY --from=golang-base /go/src/github.com/furiko-io/furiko/build/* /

USER 100:101