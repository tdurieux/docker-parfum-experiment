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
FROM opensuse/leap:${DISTRO_VERSION} AS devtools
ARG NCPU=4

## [START INSTALL.md]

# Install the minimal development tools, libcurl and OpenSSL. The gRPC Makefile
# uses `which` to determine whether the compiler is available. Install this
# command for the extremely rare case where it may be missing from your
# workstation or build server.

# ```bash
RUN zypper refresh && \
    zypper install --allow-downgrade -y automake ccache cmake gcc gcc-c++ git \
        gzip libcurl-devel libopenssl-devel libtool make tar wget which
# ```

# The following steps will install libraries and tools in `/usr/local`. openSUSE
# does not search for shared libraries in these directories by default, there
# are multiple ways to solve this problem, the following steps are one solution:

# ```bash
RUN (echo "/usr/local/lib" ; echo "/usr/local/lib64") | \
    tee /etc/ld.so.conf.d/usrlocal.conf
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/lib64/pkgconfig
ENV PATH=/usr/local/bin:${PATH}
# ```

# #### Protobuf

# We need to install a version of Protobuf that is recent enough to support the
# Google Cloud Platform proto files:

# ```bash
@INSTALL_PROTOBUF_FROM_SOURCE@
# ```

# #### c-ares

# Recent versions of gRPC require c-ares >= 1.11, while openSUSE/Leap
# distributes c-ares-1.9. Manually install a newer version:

# ```bash
@INSTALL_C_ARES_FROM_SOURCE@
# ```

# #### gRPC

# We also need a version of gRPC that is recent enough to support the Google
# Cloud Platform proto files. We manually install it using:

# ```bash
@INSTALL_GRPC_FROM_SOURCE@
# ```