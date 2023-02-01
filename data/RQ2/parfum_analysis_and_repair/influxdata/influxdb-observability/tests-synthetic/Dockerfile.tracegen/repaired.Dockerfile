FROM golang:1.16-alpine AS builder

RUN \
  --mount=type=cache,id=opentelemetry-collector-contrib-influxdb-gocache,sharing=locked,target=/root/.cache/go-build \
  --mount=type=cache,id=opentelemetry-collector-contrib-influxdb-gomodcache,sharing=locked,target=/go/pkg/mod \
  CGO_ENABLED=0 go get github.com/open-telemetry/opentelemetry-collector-contrib/tracegen

FROM scratch

COPY --from=builder /go/bin/tracegen /