# Build the manager binary
FROM docker.io/golang:1.17 as builder

WORKDIR /workspace
# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum
# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate our downloaded layer
RUN go mod download

RUN CGO_ENABLED=0 go get github.com/go-delve/delve/cmd/dlv@v1.8.0

# Copy the go source
COPY . .

# Build
RUN CGO_ENABLED=0 GOOS=linux go build -gcflags "all=-N -l" -v -o manager cmd/manager/main.go

# Directory for the files created and used by the manager, to be copied for static rootless images since we don't have shell to create it there
RUN mkdir -m=00755 /opt/manager

# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details