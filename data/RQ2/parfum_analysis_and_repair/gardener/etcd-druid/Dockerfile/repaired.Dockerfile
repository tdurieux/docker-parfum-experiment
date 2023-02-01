# Build the manager binary
FROM golang:1.17.6 as builder
WORKDIR /go/src/github.com/gardener/etcd-druid
COPY . .

# # cache deps before building and copying source so that we don't need to re-download as much
# # and so that source changes don't invalidate our downloaded layer
#RUN go mod download

# Build
RUN .ci/build

# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details