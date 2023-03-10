FROM golang:1.18.3-alpine AS builder

WORKDIR /workspace
# Copy the go source and go modules manifests
COPY cmd/dynamic-analyzer .

# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -a -o dynamic-analyzer ./...

FROM alpine:3.16.0
WORKDIR /
COPY --from=builder /workspace/dynamic-analyzer .
ENTRYPOINT ["/dynamic-analyzer"]