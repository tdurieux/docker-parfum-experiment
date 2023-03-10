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

ARG DISTRO_VERSION=xenial
FROM ubuntu:${DISTRO_VERSION} AS devtools
ARG NCPU=4

## [START INSTALL.md]

# Install the minimal development tools, OpenSSL and libcurl:

# ```bash
RUN apt-get update && \
    apt-get --no-install-recommends install -y apt-transport-https apt-utils \
        automake build-essential ccache cmake ca-certificates git gcc g++ \
        libcurl4-openssl-dev libssl-dev libtool m4 make \
        pkg-config tar wget zlib1g-dev && rm -rf /var/lib/apt/lists/*;
# ```

# #### Protobuf

# We need to install a version of Protobuf that is recent enough to support the
# Google Cloud Platform proto files:

# ```bash
@INSTALL_PROTOBUF_FROM_SOURCE@
# ```

# #### c-ares

# Recent versions of gRPC require c-ares >= 1.11, while Ubuntu-16.04
# distributes c-ares-1.10. Manually install a newer version:

# ```bash
@INSTALL_C_ARES_FROM_SOURCE@
# ```

# #### gRPC

# We also need a version of gRPC that is recent enough to support the Google
# Cloud Platform proto files. We can install gRPC from source using:

# ```bash
@INSTALL_GRPC_FROM_SOURCE@
# ```

@BUILD_AND_TEST_PROJECT_FRAGMENT@
