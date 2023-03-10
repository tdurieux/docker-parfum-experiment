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

@WARNING_GENERATED_FILE_FRAGMENT@

ARG DISTRO_VERSION=buster
FROM debian:${DISTRO_VERSION} AS devtools
ARG NCPU=4

## [START INSTALL.md]

# Install the minimal development tools, libcurl, and OpenSSL:

# ```bash
RUN apt-get update && \
    apt-get --no-install-recommends install -y apt-transport-https apt-utils \
        automake build-essential ca-certificates ccache cmake git gcc g++ \
        libc-ares-dev libc-ares2 libcurl4-openssl-dev libssl-dev m4 make \
        pkg-config tar wget zlib1g-dev && rm -rf /var/lib/apt/lists/*;
# ```

# Debian 10 includes versions of gRPC and Protobuf that support the
# Google Cloud Platform proto files. We simply install these pre-built versions:

# ```bash
RUN apt-get update && \
    apt-get --no-install-recommends install -y libgrpc++-dev libprotobuf-dev libc-ares-dev \
        protobuf-compiler protobuf-compiler-grpc && rm -rf /var/lib/apt/lists/*;
# ```

@BUILD_AND_TEST_PROJECT_FRAGMENT@
