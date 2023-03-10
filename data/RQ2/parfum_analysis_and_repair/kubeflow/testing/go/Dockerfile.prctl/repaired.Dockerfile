# Build the manager binary
#
# The Docker context is expected to be:
#
# ${PATH_TO_KUBEFLOW/KUBEFLOW repo}/components
#
# This is necessary because the Jupyter controller now depends on
# components/common
ARG GOLANG_VERSION=1.14
FROM golang:${GOLANG_VERSION} as builder

WORKDIR /workspace

COPY . /workspace

# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -a -o prctl cmd/prctl/main.go

# TODO(jlewi): We would really like to use a distroless images but we need to shell out to
# git. I tried running git on a base-debian10 distrolless but that was missing some of the
# libraries. Ideally if prctl uses go libraries instead of shelling out to git
# we could replace this with a distroless image
#
# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
FROM ubuntu:18.04 as kustomize_builder

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

# Add Kustomize so we can hydrate manifests
#
# TODO(jlewi): Should we create a separate image for Kustomize?
RUN cd /tmp && \
    curl -f -LO https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv3.6.1/kustomize_v3.6.1_linux_amd64.tar.gz && \
    tar -xvf kustomize_v3.6.1_linux_amd64.tar.gz && \
    cp kustomize /usr/local/bin/kustomize && \
    chmod a+x /usr/local/bin/kustomize && rm kustomize_v3.6.1_linux_amd64.tar.gz

# TODO(jlewi): We would really like to use a distroless images but we need to shell out to
# git. I tried running git on a base-debian10 distrolless but that was missing some of the
# libraries. Ideally if prctl uses go libraries instead of shelling out to git
# we could replace this with a distroless image
#
# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
FROM alpine:3.11

WORKDIR /

# Without openssh we will get SSL errors with git.
# Include make because we often wrap commands in make.
# bash is needed so we can run tekton scripts
RUN set -ex \
    && apk update \
    && apk upgrade \
    && apk add --no-cache git bash openssh make \
    && rm -rf /var/lib/apt/lists/* \
    && rm /var/cache/apk/*

COPY --from=kustomize_builder /usr/local/bin/kustomize /usr/local/bin/
COPY --from=builder /workspace/prctl /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/prctl"]