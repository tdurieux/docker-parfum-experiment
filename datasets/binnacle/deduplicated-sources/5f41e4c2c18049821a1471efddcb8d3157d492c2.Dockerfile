FROM ubuntu:16.04
# FROM arm=armhf/ubuntu:16.04

ARG DAPPER_HOST_ARCH
ENV HOST_ARCH=${DAPPER_HOST_ARCH} ARCH=${DAPPER_HOST_ARCH} DAPPER_ENV=REPO DAPPER_ENV=TAG \
    DAPPER_SOURCE=/go/src/github.com/rancher/submariner DAPPER_DOCKER_SOCKET=true \
    TRASH_CACHE=${DAPPER_SOURCE}/.trash-cache HOME=${DAPPER_SOURCE} DAPPER_OUTPUT=output \
    LINT_VERSION=v1.16.0 \
    HELM_VERSION=v2.14.1 \
    KIND_VERSION=v0.3.0 \
    KUBEFED_VERSION=0.1.0-rc2

RUN rm -f /bin/sh && ln -s /bin/bash /bin/sh

ENV GOLANG_ARCH_amd64=amd64 GOLANG_ARCH_arm=armv6l GOLANG_ARCH=GOLANG_ARCH_${ARCH} \
    GOPATH=/go PATH=/go/bin:/usr/local/go/bin:${PATH} SHELL=/bin/bash

RUN apt-get -q update && \
    apt-get install -y git curl docker.io && \
    curl https://storage.googleapis.com/golang/go1.11.linux-${!GOLANG_ARCH}.tar.gz | tar -xzf - -C /usr/local && \
    go get -v github.com/rancher/trash && \
    curl -Lo /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/${ARCH}/kubectl && \
    chmod a+x /usr/bin/kubectl && \
    curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | sh -s -- -b $(go env GOPATH)/bin ${LINT_VERSION} && \
    curl "https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-${ARCH}.tar.gz" | tar -xzf - && \
    cp linux-${ARCH}/helm /usr/bin/ && chmod a+x /usr/bin/helm && \
    curl -LO "https://github.com/kubernetes-sigs/kubefed/releases/download/v${KUBEFED_VERSION}/kubefedctl-${KUBEFED_VERSION}-linux-${ARCH}.tgz" && \
    tar -xzf kubefedctl-${KUBEFED_VERSION}-linux-${ARCH}.tgz && cp kubefedctl /usr/bin/ && chmod a+x /usr/bin/kubefedctl && \
    curl -Lo /usr/bin/kind "https://github.com/kubernetes-sigs/kind/releases/download/${KIND_VERSION}/kind-linux-${ARCH}" && chmod a+x /usr/bin/kind && \
    go get -v github.com/onsi/ginkgo/ginkgo && go get -v github.com/onsi/gomega/... && \
    go get -v golang.org/x/tools/cmd/goimports

WORKDIR ${DAPPER_SOURCE}

ENTRYPOINT ["./scripts/entry"]
CMD ["ci"]
