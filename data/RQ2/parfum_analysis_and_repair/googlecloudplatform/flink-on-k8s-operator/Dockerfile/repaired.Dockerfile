# Docker image for the Flink Operator.
#
# This image relies on the flink-operator-builder image to be available locally,
# as it copies the flink-operator binary from the builder image.

# Use distroless as minimal base image to package the Flink Operator binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details