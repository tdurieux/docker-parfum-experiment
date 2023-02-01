FROM golang:1.17.9-alpine AS builder

ARG VERSION
ARG BUILD_TIMESTAMP
ARG COMMIT_HASH

RUN apk add --update --no-cache gcc g++ git ca-certificates

# Copy runtime scan api code
WORKDIR /build/runtime_scan
COPY runtime_scan/api ./api

# Copy shared code
WORKDIR /build/shared
COPY shared .

# Copy cis docker benchmark scanner go.mod & go.sum
WORKDIR /build/cis_docker_benchmark_scanner
COPY cis_docker_benchmark_scanner/go.* ./
RUN go mod download

# Copy and build cis docker benchmark scanner code
WORKDIR /build/cis_docker_benchmark_scanner
COPY cis_docker_benchmark_scanner .
RUN CGO_ENABLED=0 go build -ldflags="-s -w \
     -X 'github.com/openclarity/kubeclarity/cis_docker_benchmark_scanner/pkg/version.Version=${VERSION}' \
     -X 'github.com/openclarity/kubeclarity/cis_docker_benchmark_scanner/pkg/version.CommitHash=${COMMIT_HASH}' \
     -X 'github.com/openclarity/kubeclarity/cis_docker_benchmark_scanner/pkg/version.BuildTimestamp=${BUILD_TIMESTAMP}'" \
     -o cis_docker_benchmark_scanner ./cmd/main.go

FROM alpine:3.15.4

WORKDIR /app

COPY --from=builder ["/build/cis_docker_benchmark_scanner/cis_docker_benchmark_scanner", "./cis_docker_benchmark_scanner"]

RUN chmod +x /app/cis_docker_benchmark_scanner

ENTRYPOINT ["/app/cis_docker_benchmark_scanner"]