FROM golang:1.15-alpine as builder

RUN apk add --no-cache git make gcc libc-dev

# Where factom-walletd sources will live
WORKDIR $GOPATH/src/github.com/FactomProject/factom-walletd

# Populate the rest of the source
COPY . .

ARG GOOS=linux

# Build and install factom-walletd
RUN make install

# Now squash everything
FROM alpine:3.12

RUN mkdir -p /go/bin
COPY --from=builder /go/bin/factom-walletd /go/bin/factom-walletd

ENTRYPOINT ["/go/bin/factom-walletd"]

EXPOSE 8089