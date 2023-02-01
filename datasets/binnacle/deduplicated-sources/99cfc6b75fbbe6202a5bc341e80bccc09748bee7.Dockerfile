FROM ubuntu:18.04
# FROM arm=armhf/ubuntu:16.04 arm64=arm64v8/ubuntu:18.04

ARG DAPPER_HOST_ARCH
ENV HOST_ARCH=${DAPPER_HOST_ARCH} ARCH=${DAPPER_HOST_ARCH}
ENV CATTLE_HELM_VERSION v2.10.0-rancher10

RUN apt-get update && \
    apt-get install -y gcc ca-certificates git wget curl vim less file xz-utils unzip && \
    rm -f /bin/sh && ln -s /bin/bash /bin/sh
RUN curl -sLf https://github.com/rancher/machine-package/releases/download/v0.15.0-rancher5-3/docker-machine-${ARCH}.tar.gz | tar xvzf - -C /usr/bin

ENV GOLANG_ARCH_amd64=amd64 GOLANG_ARCH_arm=armv6l GOLANG_ARCH_arm64=arm64 GOLANG_ARCH=GOLANG_ARCH_${ARCH} \
    GOPATH=/go PATH=/go/bin:/usr/local/go/bin:${PATH} SHELL=/bin/bash

RUN wget -O - https://storage.googleapis.com/golang/go1.11.linux-${!GOLANG_ARCH}.tar.gz | tar -xzf - -C /usr/local && \
    go get github.com/rancher/trash && \
    go get -u golang.org/x/lint/golint && \
    go get -d golang.org/x/tools/cmd/goimports && \
    # This needs to be kept up to date with rancher/types
    git -C /go/src/golang.org/x/tools/cmd/goimports checkout -b release-branch.go1.12 origin/release-branch.go1.12 && \
    go install golang.org/x/tools/cmd/goimports

ENV DOCKER_URL_amd64=https://get.docker.com/builds/Linux/x86_64/docker-1.10.3 \
    DOCKER_URL_arm=https://github.com/rancher/docker/releases/download/v1.10.3-ros1/docker-1.10.3_arm \
    DOCKER_URL_arm64=https://github.com/rancher/docker/releases/download/v1.10.3-ros1/docker-1.10.3_arm64 \
    DOCKER_URL=DOCKER_URL_${ARCH}

ENV HELM_URL_amd64=https://github.com/rancher/helm/releases/download/${CATTLE_HELM_VERSION}/helm \
    HELM_URL_arm64=https://github.com/rancher/helm/releases/download/${CATTLE_HELM_VERSION}/helm-arm64 \
    HELM_URL=HELM_URL_${ARCH} \
    TILLER_URL_amd64=https://github.com/rancher/helm/releases/download/${CATTLE_HELM_VERSION}/tiller \
    TILLER_URL_arm64=https://github.com/rancher/helm/releases/download/${CATTLE_HELM_VERSION}/tiller-arm64 \
    TILLER_URL=TILLER_URL_${ARCH}

RUN curl -sLf ${!HELM_URL} > /usr/bin/helm && \
    curl -sLf ${!TILLER_URL} > /usr/bin/tiller && \
    chmod +x /usr/bin/helm /usr/bin/tiller && \
    helm init -c && \
    helm plugin install https://github.com/rancher/helm-unittest

RUN wget -O - ${!DOCKER_URL} > /usr/bin/docker && chmod +x /usr/bin/docker

# FIXME: Update to Rancher RKE when released
ENV RKE_URL_amd64=https://github.com/rancher/rke/releases/download/v0.2.0-rc8/rke_linux-amd64 \
    RKE_URL_arm64=https://github.com/rancher/rke/releases/download/v0.2.0-rc8/rke_linux-arm64 \
    RKE_URL=RKE_URL_${ARCH}

RUN wget -O - ${!RKE_URL} > /usr/bin/rke && chmod +x /usr/bin/rke
ENV KUBECTL_URL=https://storage.googleapis.com/kubernetes-release/release/v1.11.0/bin/linux/${ARCH}/kubectl
RUN wget -O - ${KUBECTL_URL} > /usr/bin/kubectl && chmod +x /usr/bin/kubectl

RUN apt-get update && \
    apt-get install -y tox python3.7 python3-dev python3.7-dev libffi-dev libssl-dev

ENV HELM_HOME /root/.helm
ENV DAPPER_ENV REPO TAG DRONE_TAG SYSTEM_CHART_DEFAULT_BRANCH
ENV DAPPER_SOURCE /go/src/github.com/rancher/rancher/
ENV DAPPER_OUTPUT ./bin ./dist
ENV DAPPER_DOCKER_SOCKET true
ENV TRASH_CACHE ${DAPPER_SOURCE}/.trash-cache
ENV HOME ${DAPPER_SOURCE}
WORKDIR ${DAPPER_SOURCE}

ENTRYPOINT ["./scripts/entry"]
CMD ["ci"]
