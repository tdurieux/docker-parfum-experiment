# Base build image
FROM golang:1.13 AS build_base

WORKDIR /go/src/github.com/creativesoftwarefdn/weaviate

# Force the go compiler to use modules
ENV GO111MODULE=on
# ENV GOPROXY=https://goproxy.cn,direct

# We want to populate the module cache based on the go.{mod,sum} files.
COPY go.mod .
COPY go.sum .

#This is the ‘magic’ step that will download all the dependencies that are specified in
# the go.mod and go.sum file.

# Because of how the layer caching system works in Docker, the go mod download
# command will _ only_ be re-run when the go.mod or go.sum file change
# (or when we add another docker instruction this line)
RUN go mod download


FROM build_base as builder

ENV GO111MODULE on
ENV CGO_ENABLED 0
ENV GOOS linux
ENV GOARCH amd64

WORKDIR /go/src/github.com/oam-dev/trait-injector
ADD . .

# Build the manager binary
RUN make


FROM alpine

RUN apk --no-cache add ca-certificates && mkdir -p /app
WORKDIR /app
COPY --from=builder /go/src/github.com/oam-dev/trait-injector/bin/manager .
COPY --from=builder /go/src/github.com/oam-dev/trait-injector/ssl ssl
CMD ["/app/manager"]
