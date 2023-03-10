# Copyright 2014 Google Inc. All rights reserved.
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

# This file creates a standard build environment for building Kubernetes

FROM kube-build:cross
MAINTAINER  Joe Beda <jbeda@google.com>

# (set an explicit GOARM of 5 for maximum compatibility)
ENV GOARM 5
ENV GOOS    linux
ENV GOARCH  amd64

# Get the code coverage tool and godep
RUN go get code.google.com/p/go.tools/cmd/cover github.com/tools/godep

# We use rsync to copy some binaries around.  It is faster (0.3s vs. 1.1s) on my
# machine vs. `install`
RUN rm -rf /var/lib/apt/lists/
RUN apt-get update && apt-get install --no-install-recommends -y rsync && rm -rf /var/lib/apt/lists/*;

# Download and symlink etcd.  We need this for our integration tests.
RUN mkdir -p /usr/local/src/etcd &&\
    cd /usr/local/src/etcd && \
    curl -f -L -O -s https://github.com/coreos/etcd/releases/download/v0.4.6/etcd-v0.4.6-linux-amd64.tar.gz && \
    tar xzf etcd-v0.4.6-linux-amd64.tar.gz && \
    ln -s ../src/etcd/etcd-v0.4.6-linux-amd64/etcd /usr/local/bin/ && rm etcd-v0.4.6-linux-amd64.tar.gz

# Mark this as a kube-build container
RUN touch /kube-build-image

WORKDIR /go/src/github.com/GoogleCloudPlatform/kubernetes

# Propagate the git tree version into the build image
ADD kube-version-defs /kube-version-defs
ENV KUBE_GIT_VERSION_FILE /kube-version-defs

# Make output from the dockerized build go someplace else
ENV KUBE_OUTPUT_SUBPATH _output/dockerized

# Upload Kubernetes source
ADD kube-source.tar.gz /go/src/github.com/GoogleCloudPlatform/kubernetes
