# This Dockerfile represents a multistage build. The stages, respectively:
#
# 1. build federation binaries
# 2. copy binaries in, add OLM manifests, labels, etc

# build stage 1: build federation binaries
FROM openshift/origin-release:golang-1.12 as builder

ENV GOPATH /go
COPY . /go/src/github.com/openshift/kubefed-operator/
ENV BIN_DIR="build/_output/bin" \
    PROJECT_NAME=kubefed-operator \
    BUILD_PATH="./cmd/manager"

WORKDIR /go/src/github.com/openshift/kubefed-operator

RUN mkdir -p ${BIN_DIR} \
    && echo "Building "${PROJECT_NAME}"..." \
    && CGO_ENABLED=0 GO111MODULE=off go build -o ${BIN_DIR}/${PROJECT_NAME} -i ${BUILD_PATH}

FROM registry.access.redhat.com/ubi7-dev-preview/ubi-minimal:7.6

ENV OPERATOR=/usr/local/bin/kubefed-operator \
    USER_UID=1001 \
    USER_NAME=kubefed-operator

LABEL com.redhat.delivery.appregistry=true

COPY --from=builder /go/src/github.com/openshift/kubefed-operator/deploy/olm-catalog/kubefed-operator /manifests

# install operator binary