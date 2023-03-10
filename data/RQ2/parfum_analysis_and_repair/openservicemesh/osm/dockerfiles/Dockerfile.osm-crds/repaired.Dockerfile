FROM --platform=$BUILDPLATFORM busybox:1.33 AS builder
ARG TARGETPLATFORM
# Talking to the internet in an arm64 container doesn't seem to work from a
# amd64 Mac, so download the kubectl binary in a stage running the native arch.
RUN wget https://dl.k8s.io/release/v1.23.5/bin/$TARGETPLATFORM/kubectl -O /bin/kubectl && \
    chmod +x /bin/kubectl
FROM busybox:1.33
COPY --from=builder /bin/kubectl /bin
COPY * /osm-crds/
ENTRYPOINT ["/bin/kubectl"]