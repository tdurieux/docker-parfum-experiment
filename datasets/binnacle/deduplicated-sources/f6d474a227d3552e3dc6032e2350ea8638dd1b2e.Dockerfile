# Copyright 2018 Google LLC
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

ARG DISTRO_VERSION=latest
FROM opensuse/tumbleweed:${DISTRO_VERSION} AS devtools

## [START INSTALL.md]

# Install the minimal development tools:

## [START README.md]

# ```bash
RUN zypper refresh && \
    zypper install --allow-downgrade -y cmake gcc gcc-c++ git gzip \
        libcurl-devel libopenssl-devel make tar wget zlib-devel
# ```

## [END README.md]

FROM devtools
COPY ci/install-retry.sh /retry3

## [START IGNORED]
# Verify that the tools above are enough to compile google-cloud-cpp when using
# external projects.
WORKDIR /home/build/external
COPY . /home/build/external
RUN cmake -H. -Bcmake-out -DCMAKE_BUILD_TYPE=Debug
RUN cmake --build cmake-out -- -j $(nproc)
RUN (cd cmake-out && ctest --output-on-failure)
## [END IGNORED]

# OpenSUSE:tumbleweed provides packages for gRPC, libcurl, and protobuf, and the
# versions of these packages are recent enough to support the Google Cloud
# Platform proto files.

# ```bash
RUN /retry3 zypper refresh && \
    /retry3 zypper install -y grpc-devel gzip libcurl-devel pkg-config tar wget
# ```

# #### crc32c

# There is no OpenSUSE package for this library. To install it, use:

# ```bash
WORKDIR /var/tmp/build
RUN /retry3 wget -q https://github.com/google/crc32c/archive/1.0.6.tar.gz
RUN tar -xf 1.0.6.tar.gz
WORKDIR /var/tmp/build/crc32c-1.0.6
RUN cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_SHARED_LIBS=yes \
      -DCRC32C_BUILD_TESTS=OFF \
      -DCRC32C_BUILD_BENCHMARKS=OFF \
      -DCRC32C_USE_GLOG=OFF \
      -H. -Bcmake-out/crc32c
RUN cmake --build cmake-out/crc32c --target install -- -j $(nproc)
RUN ldconfig
# ```

# #### google-cloud-cpp

# We can now compile and install `google-cloud-cpp`.

# ```bash
WORKDIR /home/build/google-cloud-cpp
COPY . /home/build/google-cloud-cpp
RUN cmake -H. -Bcmake-out \
    -DGOOGLE_CLOUD_CPP_DEPENDENCY_PROVIDER=package \
    -DGOOGLE_CLOUD_CPP_GMOCK_PROVIDER=external
RUN cmake --build cmake-out -- -j $(nproc)
WORKDIR /home/build/google-cloud-cpp/cmake-out
RUN ctest --output-on-failure
RUN cmake --build . --target install
# ```

## [END INSTALL.md]

# Verify that the installed files are actually usable
WORKDIR /home/build/test-install-plain-make
ENV PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig
COPY ci/test-install /home/build/test-install-plain-make
RUN make

WORKDIR /home/build/test-install-cmake-bigtable
COPY ci/test-install/bigtable /home/build/test-install-cmake-bigtable
RUN env -u PKG_CONFIG_PATH cmake -H. -Bcmake-out
RUN cmake --build cmake-out -- -j $(nproc)

WORKDIR /home/build/test-install-cmake-storage
COPY ci/test-install/storage /home/build/test-install-cmake-storage
RUN env -u PKG_CONFIG_PATH cmake -H. -Bcmake-out
RUN cmake --build cmake-out -- -j $(nproc)

WORKDIR /home/build/test-submodule
COPY ci/test-install /home/build/test-submodule
COPY . /home/build/test-submodule/submodule/google-cloud-cpp
RUN cmake -Hsubmodule -Bcmake-out
RUN cmake --build cmake-out -- -j $(nproc)
