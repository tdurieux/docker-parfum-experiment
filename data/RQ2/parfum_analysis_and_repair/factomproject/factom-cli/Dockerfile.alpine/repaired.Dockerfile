FROM golang:1.15-alpine as builder

RUN apk add --no-cache git make gcc libc-dev

# Where factom-cli sources will live
WORKDIR $GOPATH/src/github.com/FactomProject/factom-cli

# Populate the rest of the source
COPY . .

ARG GOOS=linux

# Build and install factom-cli
RUN make install

# Now squash everything
FROM alpine:3.12

# Get git
RUN apk add --no-cache ca-certificates curl git

RUN mkdir -p /go/bin

COPY --from=builder /go/bin/factom-cli /go/bin/factom-cli

ENTRYPOINT ["/go/bin/factom-cli"]