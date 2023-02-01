# Create image for log-service.
#
# Build the log-service image using:
# > bazel build --platforms=@io_bazel_rules_go//go/toolchain:linux_amd64 //product/log-service/...
#
# > docker build -t harness/log-service:valpha-0.1 -f product/log-service/docker/Dockerfile $(bazel info bazel-bin)/product/log-service/

FROM alpine:3.12
# Copy go binary