# Copyright 2022 DigitalOcean
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

### base build containers
FROM golang:1.13 AS builder

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends rsync && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /go/src/k8s.io
WORKDIR /go/src/k8s.io

### Kubernetes 1.23
FROM builder AS tests-1.23
ARG KUBE_VERSION_1_23=1.23.7
ARG KUBE_VERSION_1_23_E2E_BIN_SHA256_CHECKSUM=e1a9a632b7715d4bfbac3322da5d32072eaf544b31a81a6c3df205d0dc0e96b7

RUN curl --fail --location https://dl.k8s.io/v${KUBE_VERSION_1_23}/kubernetes-test-linux-amd64.tar.gz | tar xvzf - --strip-components 3 kubernetes/test/bin/e2e.test
RUN echo "${KUBE_VERSION_1_23_E2E_BIN_SHA256_CHECKSUM}" e2e.test | sha256sum --check
RUN cp e2e.test /e2e.1.23.test

### Kubernetes 1.22
FROM builder AS tests-1.22
ARG KUBE_VERSION_1_22=1.22.5
ARG KUBE_VERSION_1_22_E2E_BIN_SHA256_CHECKSUM=8665242697896acf544fee3e060ccdacc49ddac68adca083ce4de131c4a7e829

RUN curl --fail --location https://dl.k8s.io/v${KUBE_VERSION_1_22}/kubernetes-test-linux-amd64.tar.gz | tar xvzf - --strip-components 3 kubernetes/test/bin/e2e.test
RUN echo "${KUBE_VERSION_1_22_E2E_BIN_SHA256_CHECKSUM}" e2e.test | sha256sum --check
RUN cp e2e.test /e2e.1.22.test

### Kubernetes 1.21
FROM builder AS tests-1.21
ARG KUBE_VERSION_1_21=1.21.6
ARG KUBE_VERSION_1_21_E2E_BIN_SHA256_CHECKSUM=74db305a069c82a7cf874c483a1d4ef163ae061bb259cdaea3047066b21c2a6c

RUN curl --fail --location https://dl.k8s.io/v${KUBE_VERSION_1_21}/kubernetes-test-linux-amd64.tar.gz | tar xvzf - --strip-components 3 kubernetes/test/bin/e2e.test
RUN echo "${KUBE_VERSION_1_21_E2E_BIN_SHA256_CHECKSUM}" e2e.test | sha256sum --check
RUN cp e2e.test /e2e.1.21.test

### ginkgo and tools
FROM golang:1.13 AS tools
# See comment at the bottom on why we need tini.
ARG TINI_VERSION=0.18.0
# doctl is needed to support clusters that had their kubeconfig fetched via the
# CLI because those leverage a kubeconfig authentication plugin based on doctl.
ARG DOCTL_VERSION=1.76.2
# ginkgo is needed to run the upstream end-to-end tests.
ARG GINKGO_VERSION=1.10.3
# kubectl is needed by some tests.
ARG KUBECTL_VERSION=1.23.7

RUN curl --fail --location --output /tini https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini
RUN chmod u+x /tini

RUN curl --fail --location https://github.com/digitalocean/doctl/releases/download/v${DOCTL_VERSION}/doctl-${DOCTL_VERSION}-linux-amd64.tar.gz | tar -xzv
RUN cp doctl /

RUN GO111MODULE=on go get github.com/onsi/ginkgo/ginkgo@v${GINKGO_VERSION}
RUN cp bin/ginkgo /

RUN curl --fail --location --remote-name https://storage.googleapis.com/kubernetes-release/release/$(curl --fail --silent https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod u+x kubectl
RUN cp kubectl /

### final test container
FROM bitnami/minideb:buster AS runtime
# Certificates needed to trust the CA for any HTTPS connections to the DO API.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/*;
COPY --from=tests-1.23 /e2e.1.23.test /
COPY --from=tests-1.22 /e2e.1.22.test /
COPY --from=tests-1.21 /e2e.1.21.test /
COPY --from=tools /tini /sbin/
COPY --from=tools /doctl /usr/local/bin/
COPY --from=tools /ginkgo /usr/local/bin/
COPY --from=tools /kubectl /usr/local/bin/

COPY cleanup-clusters.sh /

# Docker comes with built-in tini support (--init parameter) but does not allow
# to enable child process group killing
# (https://github.com/krallin/tini#process-group-killing) via "-g". We need this
# since our entrypoint script spawns child processes during multiple invocations
# of ginkgo. The usual approach of using "exec" to replace the shell does not
# work here as that would terminate the script prematurely.
# We also enable subreaping (https://github.com/krallin/tini#subreaping) to fix
# a startup warning.
# See also https://hynek.me/articles/docker-signals/ for the usual pid 1
# gotchas.
ENTRYPOINT ["/sbin/tini", "-g", "-s", "--", "/run-versioned-e2e-tests.sh"]
COPY run-versioned-e2e-tests.sh /
