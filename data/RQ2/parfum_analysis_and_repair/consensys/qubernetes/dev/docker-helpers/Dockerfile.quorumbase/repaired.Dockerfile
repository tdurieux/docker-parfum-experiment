# Build Geth in a stock Go builder container
# docker build -t quorum-base-local -f Dockerfile.quorumbase .
FROM golang:1.13-alpine

RUN apk add --no-cache make gcc musl-dev linux-headers git ca-certificates

#ADD /Users/libby/go/src/github.com/ethereum/go-ethereum /go-ethereum