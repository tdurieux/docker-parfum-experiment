# Build the manager binary
FROM golang:1.18.1 as builder

WORKDIR /workspace
# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum

RUN --mount=type=cache,target=/go/pkg/mod \
    go mod download

COPY controllers/api controllers/api/

# Copy the go source
COPY statefulset-runner/main.go statefulset-runner/main.go
COPY statefulset-runner/api/ statefulset-runner/api/
COPY statefulset-runner/controllers/ statefulset-runner/controllers/

# Build
RUN --mount=type=cache,target=/root/.cache/go-build --mount=type=cache,target=/go/pkg/mod \
     CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o manager statefulset-runner/main.go

# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
FROM gcr.io/distroless/static:nonroot
WORKDIR /
COPY --from=builder /workspace/manager .
USER 65532:65532

ENTRYPOINT ["/manager"]
