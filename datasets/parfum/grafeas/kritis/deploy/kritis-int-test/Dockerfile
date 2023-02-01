# Copyright 2018 Google, Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM gcr.io/gcp-runtimes/ubuntu_16_0_4 as runtime_deps

RUN apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y \
        python-dev \
        git

ENV KUBECTL_VERSION v1.14.10
RUN curl -Lo /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl  && \
    chmod +x /usr/local/bin/kubectl

ENV HELM_VERSION v2.8.1
RUN curl -LO https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    tar -zxvf helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm

ENV CLOUD_SDK_VERSION 193.0.0
RUN curl -LO https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
 tar -zxvf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    CLOUDSDK_PYTHON="python2.7" /google-cloud-sdk/install.sh --usage-reporting=false \
        --bash-completion=false \
        --disable-installation-options

ENV DOCKER_CREDENTIAL_GCR_VERSION=1.4.3
RUN curl -LO https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/download/v${DOCKER_CREDENTIAL_GCR_VERSION}/docker-credential-gcr_linux_amd64-${DOCKER_CREDENTIAL_GCR_VERSION}.tar.gz && \
    tar -zxvf docker-credential-gcr_linux_amd64-${DOCKER_CREDENTIAL_GCR_VERSION}.tar.gz && \
    mv docker-credential-gcr /usr/bin/docker-credential-gcr && \
    rm docker-credential-gcr_linux_amd64-${DOCKER_CREDENTIAL_GCR_VERSION}.tar.gz && \
    docker-credential-gcr configure-docker

ENV PATH /usr/local/go/bin:/go/bin:/google-cloud-sdk/bin:${PATH}

FROM runtime_deps as builder

RUN apt-get install --no-install-recommends --no-install-suggests -y \
        build-essential

COPY --from=golang:1.12 /usr/local/go /usr/local/go
ENV PATH /usr/local/go/bin:/go/bin:${PATH}
ENV GOPATH /go/

WORKDIR /go/src/github.com/grafeas/kritis

COPY . .

FROM builder as integration

CMD ["make", "integration-prod"]

