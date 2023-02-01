# Copyright 2018 The kube-fledged authors.
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

ARG ALPINE_VERSION
FROM alpine:$ALPINE_VERSION

RUN apk update && apk add --no-cache bash curl openssh-client

ARG DOCKER_VERSION
ARG CRICTL_VERSION
ARG TARGETPLATFORM

RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
 curl -f -L -o /tmp/docker-$DOCKER_VERSION.tgz https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION.tgz; \
 elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
 curl -f -L -o /tmp/docker-$DOCKER_VERSION.tgz https://download.docker.com/linux/static/stable/aarch64/docker-$DOCKER_VERSION.tgz; \
 elif [ "$TARGETPLATFORM" = "linux/arm/v7" ]; then \
 curl -f -L -o /tmp/docker-$DOCKER_VERSION.tgz https://download.docker.com/linux/static/stable/armhf/docker-$DOCKER_VERSION.tgz; \
 else\
 :;\
 fi

RUN tar -xz -C /tmp -f /tmp/docker-$DOCKER_VERSION.tgz && \
    mv /tmp/docker/docker /usr/bin && \
    rm -rf /tmp/docker-$DOCKER_VERSION.tgz /tmp/docker

RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
 curl -f -L -o /tmp/crictl-$CRICTL_VERSION.tgz https://github.com/kubernetes-sigs/cri-tools/releases/download/$CRICTL_VERSION/crictl-$CRICTL_VERSION-linux-amd64.tar.gz; \
 elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
 curl -f -L -o /tmp/crictl-$CRICTL_VERSION.tgz https://github.com/kubernetes-sigs/cri-tools/releases/download/$CRICTL_VERSION/crictl-$CRICTL_VERSION-linux-arm64.tar.gz; \
 elif [ "$TARGETPLATFORM" = "linux/arm/v7" ]; then \
 curl -f -L -o /tmp/crictl-$CRICTL_VERSION.tgz https://github.com/kubernetes-sigs/cri-tools/releases/download/$CRICTL_VERSION/crictl-$CRICTL_VERSION-linux-arm.tar.gz; \
 else\
 :;\
 fi

RUN tar -xz -C /tmp -f /tmp/crictl-$CRICTL_VERSION.tgz && \
    mv /tmp/crictl /usr/bin && \
    rm -rf /tmp/crictl-$CRICTL_VERSION.tgz /tmp/crictl
