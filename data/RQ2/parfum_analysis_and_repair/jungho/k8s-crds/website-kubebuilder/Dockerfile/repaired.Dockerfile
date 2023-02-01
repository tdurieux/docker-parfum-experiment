# Build the manager binary
FROM golang:1.10.3 as builder

# Copy in the go src
WORKDIR /go/src/github.com/jungho/k8s-crds/website-kubebuilder
COPY pkg/    pkg/
COPY cmd/    cmd/
COPY vendor/ vendor/

# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o manager github.com/jungho/k8s-crds/website-kubebuilder/cmd/manager

# Copy the controller-manager into a thin image
FROM scratch
#required for TLS