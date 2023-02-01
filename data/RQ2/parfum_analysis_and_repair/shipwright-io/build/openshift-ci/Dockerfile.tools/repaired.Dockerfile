# Copyright The Shipwright Contributors
#
# SPDX-License-Identifier: Apache-2.0

FROM centos:7 as build-tools
ENV LANG=en_US.utf8
ENV GOPATH /tmp/go
ARG GO_PACKAGE_PATH=github.com/shipwright-io/build

ENV GIT_COMMITTER_NAME devtools
ENV GIT_COMMITTER_EMAIL devtools@redhat.com

RUN yum install epel-release -y \
    && yum install --enablerepo=centosplus install -y --quiet \
    findutils \
    git \
    make \
    gcc \
    procps-ng \
    tar \
    wget \
    which \
    bc \
    jq \
    python36-virtualenv \
    && yum clean all && rm -rf /var/cache/yum

ENV PATH=:$GOPATH/bin:/tmp/goroot/go/bin:$PATH

WORKDIR /tmp

RUN mkdir -p $GOPATH/bin
RUN mkdir -p /tmp/goroot

RUN curl -f -Lo go1.17.linux-amd64.tar.gz https://dl.google.com/go/go1.17.linux-amd64.tar.gz && tar -C /tmp/goroot -xzf go1.17.linux-amd64.tar.gz && rm go1.17.linux-amd64.tar.gz
RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x kubectl && mv kubectl $GOPATH/bin/

RUN go install github.com/onsi/ginkgo/ginkgo@latest  # installs the ginkgo CLI
RUN go install github.com/onsi/gomega/...            # fetches the matcher library

RUN mkdir -p ${GOPATH}/src/${GO_PACKAGE_PATH}/

WORKDIR ${GOPATH}/src/${GO_PACKAGE_PATH}

ENTRYPOINT [ "/bin/bash" ]
