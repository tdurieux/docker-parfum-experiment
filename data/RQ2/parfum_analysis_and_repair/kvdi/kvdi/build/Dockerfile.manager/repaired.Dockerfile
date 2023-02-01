# Compile image
ARG BASE_IMAGE=ghcr.io/tinyzimmer/kvdi:build-base-latest
FROM ${BASE_IMAGE} as builder

# Go build options
ENV GO111MODULE=on
ENV CGO_ENABLED=0

# Copy go code
COPY apis/         /build/apis
COPY pkg/          /build/pkg
COPY controllers/  /build/controllers
COPY cmd/manager   /build/cmd/manager

# Build the binary
ARG LDFLAGS
RUN go build \
  -o /tmp/manager \
  -ldflags="${LDFLAGS}" \
  ./cmd/manager && upx /tmp/manager

##
# Build the runtime image
##
FROM scratch

# Install operator binary