# syntax = docker/dockerfile:experimental
# Build Container
FROM golang:1.13.5 as send-anything-builder

ENV GO111MODULE on
WORKDIR /go/src/bitbucket.org/latonaio

COPY go.mod .

RUN go mod download

COPY . .

# RUN NOWTIME=$(date +%m/%d_%H:%M)
# RUN COMMAND=$(echo "go build -o send-anything -ldflags "$(echo '"-X main.buildDate='$NOWTIME'"')" ./cmd/send-anything")
# RUN $(echo $COMMAND)
RUN go build -o send-anything ./cmd/send-anything


# Runtime Container