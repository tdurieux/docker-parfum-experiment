# Copyright 2016 The Kubernetes Authors.
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

FROM golang:GO_VERSION

# Install dep as root
ENV DEP_VERSION=v0.5.0
RUN curl -sSL -o /usr/local/bin/dep https://github.com/golang/dep/releases/download/$DEP_VERSION/dep-linux-amd64 && \
    chmod +x /usr/local/bin/dep

# Install etcd
RUN curl -sSL https://github.com/coreos/etcd/releases/download/v3.2.24/etcd-v3.2.24-linux-amd64.tar.gz \
    | tar -vxz -C /usr/local/bin --strip=1 etcd-v3.2.24-linux-amd64/etcd

# Install the golint, use this to check our source for niceness
COPY vendor/golang.org /go/src/golang.org
RUN go install golang.org/x/lint/golint

# Install the href checker for our md files, update PATH to include it
RUN git clone https://github.com/duglin/vlinker.git /vlinker
ENV PATH=$PATH:/vlinker/bin

# Install the azure client, used to publish svcat binaries
ENV AZCLI_VERSION=v0.3.1
RUN curl -sLo /usr/local/bin/az https://github.com/carolynvs/az-cli/releases/download/$AZCLI_VERSION/az-linux-amd64 && \
    chmod +x /usr/local/bin/az

# Create the full dir tree that we'll mount our src into when we run the image
RUN mkdir -p /go/src/github.com/kubernetes-sigs/service-catalog

# Default to our src dir
WORKDIR /go/src/github.com/kubernetes-sigs/service-catalog
