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

ARG DISTRO_VERSION=latest
FROM opensuse/tumbleweed:${DISTRO_VERSION} AS devtools
ARG NCPU=4

## [START INSTALL.md]

# Install the minimal development tools, libcurl and OpenSSL:

# ```bash
RUN zypper refresh && \
    zypper install --allow-downgrade -y ccache cmake gcc gcc-c++ git gzip \
        libcurl-devel libopenssl-devel make tar wget zlib-devel
# ```

# The versions of gRPC and Protobuf packaged with openSUSE/Tumbleweed are recent
# enough to support the Google Cloud Platform proto files.

# ```bash
RUN zypper refresh && \
    zypper install -y grpc-devel
# ```

# The following steps will install libraries and tools in `/usr/local`. By
# default pkg-config does not search in these directories.

# ```bash
ENV PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig
# ```