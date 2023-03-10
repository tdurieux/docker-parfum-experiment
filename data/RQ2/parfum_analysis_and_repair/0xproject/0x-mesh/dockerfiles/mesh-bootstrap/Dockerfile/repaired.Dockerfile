# Note: this must be built from the root of the project with:
#
#     docker build . -f ./cmd/mesh-bootstrap/Dockerfile
#

# mesh-builder produces a statically linked binary
FROM golang:1.15.2-alpine3.12 as mesh-builder


RUN apk update && apk add --no-cache ca-certificates nodejs-current npm make git dep gcc build-base musl linux-headers

WORKDIR /0x-mesh

ADD . ./

RUN go build ./cmd/mesh-bootstrap

# Final Image
FROM alpine:3.12

RUN apk update && apk add ca-certificates --no-cache

WORKDIR /usr/mesh

COPY --from=mesh-builder /0x-mesh/mesh-bootstrap /usr/mesh/mesh-bootstrap

# Default port for TCP multiaddr
EXPOSE 60558
# Default port for WebSockets multiaddr
EXPOSE 60559

RUN chmod +x ./mesh-bootstrap

ENTRYPOINT ./mesh-bootstrap
