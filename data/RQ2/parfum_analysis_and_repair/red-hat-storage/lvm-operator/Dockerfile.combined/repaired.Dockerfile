# Build the manager binary
FROM golang:1.17 as builder

WORKDIR /workspace
# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum
# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate our downloaded layer
RUN go mod download

# Copy the go source
COPY main.go main.go
COPY api/ api/
COPY controllers/ controllers/
COPY cmd/ cmd/
COPY pkg/ pkg/

# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o manager main.go
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o vgmanager cmd/vgmanager/main.go
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o metricsexporter cmd/metricsexporter/exporter.go

# vgmanager needs 'nsenter' and other basic linux utils to correctly function
FROM quay.io/centos/centos:stream8

# Install required utilities
RUN dnf install -y openssl && dnf clean all

WORKDIR /
COPY --from=builder /workspace/manager .
COPY --from=builder /workspace/vgmanager .
COPY --from=builder /workspace/metricsexporter .
EXPOSE 23532
USER 65532:65532

# '/manager' is lvm-operator entrypoint
ENTRYPOINT ["/manager"]

# '/vgmanager' is vgmanager entrypoint which is used in daemonset image
# ENTRYPOINT ["/vgmanager"]