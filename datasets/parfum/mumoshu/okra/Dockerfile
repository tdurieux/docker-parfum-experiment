FROM golang:1.17 as builder

ARG TARGETPLATFORM

WORKDIR /workspace

ENV GO111MODULE=on \
  CGO_ENABLED=0

# Copy the Go Modules manifests
COPY go.mod go.sum ./

# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate our downloaded layer
RUN go mod download

# Copy the go source
COPY . .

# Build
RUN export GOOS=$(echo ${TARGETPLATFORM} | cut -d / -f1) && \
  export GOARCH=$(echo ${TARGETPLATFORM} | cut -d / -f2) && \
  GOARM=$(echo ${TARGETPLATFORM} | cut -d / -f3 | cut -c2-) && \
  go build -a -o . ./cmd/*

# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
FROM gcr.io/distroless/static:nonroot

WORKDIR /

COPY --from=builder /workspace/okra /workspace/okrad .
COPY --from=builder /workspace/okractl /bin/okractl
COPY --from=builder /workspace/aws /bin/aws

USER nonroot:nonroot

ENTRYPOINT ["/okrad"]
