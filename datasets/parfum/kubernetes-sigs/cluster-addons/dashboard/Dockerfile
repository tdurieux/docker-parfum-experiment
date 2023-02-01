FROM ubuntu:latest as kubectl
RUN apt-get update
RUN apt-get install -y curl
RUN curl -fsSL https://dl.k8s.io/release/v1.13.4/bin/linux/amd64/kubectl > /usr/bin/kubectl
RUN chmod a+rx /usr/bin/kubectl

# Build the manager binary
FROM golang:1.13 as builder

# Copy in the go src
WORKDIR /workspace
# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum
# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate our downloaded layer
RUN go mod download

COPY main.go main.go
COPY api/ api/
COPY controllers/ controllers/

# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -a -o manager main.go

# Copy the channels so we can chmod them before we go distroless
COPY channels/ /channels/
RUN chmod -R a=rX /channels/

# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
FROM gcr.io/distroless/static:nonroot
WORKDIR /
COPY --from=builder /workspace/manager .
COPY --from=kubectl /usr/bin/kubectl /usr/bin/kubectl
COPY --from=builder /channels/ channels/
USER nonroot:nonroot
ENTRYPOINT ["./manager"]
