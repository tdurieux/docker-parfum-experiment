# Copyright 2019 Google LLC
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

FROM debian:buster
LABEL maintainer="esp-eng@google.com"

# add env we can debug with the image name:tag
ARG IMAGE_ARG
ENV IMAGE=${IMAGE_ARG}


RUN apt-get update -y
RUN apt-get -y --no-install-recommends install \
    wget make cmake python python-pip pkg-config coreutils \
    zlib1g-dev curl libtool automake zip time rsync ninja-build \
    git bash-completion jq default-jdk python3-distutils libicu-dev libbrotli-dev && rm -rf /var/lib/apt/lists/*;


# install nodejs, which is needed for integration tests
RUN sh -c 'curl -sL https://deb.nodesource.com/setup_12.x | bash -'
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# install Bazelisk
RUN wget -O /usr/local/bin/bazelisk https://github.com/bazelbuild/bazelisk/releases/download/v1.11.0/bazelisk-linux-amd64 && \
    chmod +x /usr/local/bin/bazelisk

# install clang-10 and associated tools (new envoy)
RUN wget -O- https://apt.llvm.org/llvm-snapshot.gpg.key| apt-key add - && \
    echo "deb https://apt.llvm.org/buster/ llvm-toolchain-buster-13 main" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y llvm-13 llvm-13-dev libclang-13-dev clang-13 \
        lld-13 clang-tools-13 clang-format-13 libc++-dev xz-utils && rm -rf /var/lib/apt/lists/*;

ENV CC clang-13
ENV CXX clang++-13

# install golang and setup Go standard envs
ENV GOPATH /go
ENV PATH /usr/local/go/bin:$PATH
ENV PATH $GOPATH/bin:$PATH

ENV GO_TARBALL "go1.18.2.linux-amd64.tar.gz"
RUN wget -q "https://golang.org/dl/${GO_TARBALL}" && \
    tar xzf "${GO_TARBALL}" -C /usr/local && \
    rm "${GO_TARBALL}"

# Install buildifier
RUN go install github.com/bazelbuild/buildtools/buildifier@latest

# install gcloud package
RUN curl -f https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz
RUN mkdir -p /usr/local/gcloud \
  && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
  && /usr/local/gcloud/google-cloud-sdk/install.sh && rm /tmp/google-cloud-sdk.tar.gz
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin
