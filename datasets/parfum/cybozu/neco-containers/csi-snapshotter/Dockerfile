# Stage1: build from source
FROM quay.io/cybozu/golang:1.18-focal AS build

ARG SRC_DIR=/work/go/src/github.com/kubernetes-csi/external-snapshotter
ARG VERSION=6.0.1

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN git clone -b v${VERSION} --depth=1 https://github.com/kubernetes-csi/external-snapshotter.git ${SRC_DIR}

WORKDIR ${SRC_DIR}

RUN make

# Stage2: setup runtime container
FROM quay.io/cybozu/ubuntu:20.04

ARG SRC_DIR=/work/go/src/github.com/kubernetes-csi/external-snapshotter
LABEL description="CSI External Snapshotter Sidecar"

COPY --from=build ${SRC_DIR}/bin/csi-snapshotter /
ENTRYPOINT ["/csi-snapshotter"]
