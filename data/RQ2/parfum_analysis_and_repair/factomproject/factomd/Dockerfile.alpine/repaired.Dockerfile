FROM golang:1.14-alpine  as builder

# Get git, make...
RUN apk add --no-cache curl git make gcc libc-dev

# Where factomd sources will live
WORKDIR $GOPATH/src/github.com/FactomProject/factomd

# Populate the rest of the source
COPY . .

# Build and install factomd
RUN make install

# Setup the cache directory
RUN mkdir -p /root/.factom/m2
COPY factomd.conf /root/.factom/m2/factomd.conf

# Now squash everything
FROM alpine:3.12

# Get git
RUN apk add --no-cache ca-certificates curl git

RUN mkdir -p /root/.factom/m2 /go/bin
COPY --from=builder /root/.factom/m2/factomd.conf /root/.factom/m2/factomd.conf
COPY --from=builder /go/bin/factomd /go/bin/factomd

ENTRYPOINT ["/go/bin/factomd"]

EXPOSE 8088 8090 8108 8109 8110