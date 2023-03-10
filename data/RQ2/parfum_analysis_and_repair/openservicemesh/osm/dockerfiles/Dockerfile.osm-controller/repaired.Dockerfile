ARG GO_VERSION
FROM --platform=$BUILDPLATFORM openservicemesh/proxy-wasm-cpp-sdk:956f0d500c380cc1656a2d861b7ee12c2515a664@sha256:2f97f075a73f2d85d12b9ced0e052ffc87f00808385ffd7631c96d4e03fbda92 AS wasm

WORKDIR /wasm
COPY ./wasm .
RUN /build_wasm.sh

FROM --platform=$BUILDPLATFORM golang:$GO_VERSION AS builder
ARG LDFLAGS
ARG TARGETOS
ARG TARGETARCH

WORKDIR /osm
COPY . .
COPY --from=wasm /wasm/stats.wasm pkg/envoy/lds
RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg \
    CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -v -o osm-controller -ldflags "$LDFLAGS" ./cmd/osm-controller

FROM gcr.io/distroless/static
COPY --from=builder /osm/osm-controller /