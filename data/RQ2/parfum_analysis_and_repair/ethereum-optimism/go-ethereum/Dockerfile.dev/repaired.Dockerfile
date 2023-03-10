# Requires the root repo dir to be mounted at /mnt/go-ethereum in order to run this!
FROM golang:1.14-alpine

RUN apk add --no-cache make gcc musl-dev linux-headers git
RUN apk add --no-cache ca-certificates

EXPOSE 8545 8546 8547 30303 30303/udp

# Used to mount the code so image isn't re-built every time code changes