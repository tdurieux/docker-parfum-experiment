# Stage1: build from source
FROM quay.io/cybozu/golang:1.18-focal AS build

ARG SRC_DIR=/work/go/src/github.com/kubernetes-csi/external-snapshotter
ARG VERSION=6.0.1

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN git clone -b v${VERSION} --depth=1 https://github.com/kubernetes-csi/external-snapshotter.git ${SRC_DIR}

WORKDIR ${SRC_DIR}

RUN make

# Stage2: setup runtime container