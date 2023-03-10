# syntax=docker/dockerfile:experimental


# Build stream
FROM golang:1.15-alpine as slurp
RUN apk add --no-cache git ca-certificates gcc linux-headers musl-dev 
COPY . /go/src/github.com/tinkerbell/hub/actions/slurp/v1
WORKDIR /go/src/github.com/tinkerbell/hub/actions/slurp/v1
ENV GO111MODULE=on
RUN --mount=type=cache,sharing=locked,id=gomod,target=/go/pkg/mod/cache \
    --mount=type=cache,sharing=locked,id=goroot,target=/root/.cache/go-build \
    CGO_ENABLED=1 GOOS=linux go build -a -ldflags "-linkmode external -extldflags '-static' -s -w" -o slurp

# Build final image
FROM scratch
# Add Certificates into the image, for anything that does HTTPS calls