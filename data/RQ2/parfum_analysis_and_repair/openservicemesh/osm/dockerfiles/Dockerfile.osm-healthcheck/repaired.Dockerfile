ARG GO_VERSION
FROM --platform=$BUILDPLATFORM golang:$GO_VERSION AS builder
ARG LDFLAGS
ARG TARGETOS
ARG TARGETARCH

WORKDIR /osm
COPY . .
RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg \
    CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -v -o osm-healthcheck -ldflags "$LDFLAGS" ./cmd/osm-healthcheck

FROM gcr.io/distroless/static
COPY --from=builder /osm/osm-healthcheck /