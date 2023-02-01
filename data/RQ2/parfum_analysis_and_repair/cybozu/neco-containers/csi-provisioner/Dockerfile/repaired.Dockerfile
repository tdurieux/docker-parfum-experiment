# Stage1: build from source
FROM quay.io/cybozu/golang:1.17-focal AS build

ARG SRC_DIR=/work/go/src/github.com/kubernetes-csi/external-provisioner
ARG VERSION=3.1.0

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN git clone -b v${VERSION} --depth=1 https://github.com/kubernetes-csi/external-provisioner.git ${SRC_DIR}

WORKDIR ${SRC_DIR}

RUN make

# Stage2: setup runtime container