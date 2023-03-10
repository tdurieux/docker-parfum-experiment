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

#
# WARNING: This is an automatically generated file. Consider changing the
#     sources instead. You can find the source templates and scripts at:
#     https://github.com/googleapis/google-cloud-cpp-common/tree/master/ci/templates
#

ARG DISTRO_VERSION=7
FROM centos:${DISTRO_VERSION} AS devtools

## [START README.md]

# Install the development tools and OpenSSL. The development tools distributed
# with CentOS (notably CMake) are too old to build the
# `google-cloud-cpp-common` project. We recommend you install cmake3 from
# [Software Collections](https://www.softwarecollections.org/).

# ```bash
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum install -y centos-release-scl && rm -rf /var/cache/yum
RUN yum-config-manager --enable rhel-server-rhscl-7-rpms
RUN yum makecache && \
    yum install -y automake cmake3 curl-devel gcc gcc-c++ git libtool \
        make openssl-devel pkgconfig tar wget which zlib-devel && rm -rf /var/cache/yum
RUN ln -sf /usr/bin/cmake3 /usr/bin/cmake && ln -sf /usr/bin/ctest3 /usr/bin/ctest
# ```

## [END README.md]

FROM devtools AS readme
ARG NCPU=4

WORKDIR /home/build/super
COPY . /home/build/super
RUN cmake -Hsuper -Bcmake-out \
        -DGOOGLE_CLOUD_CPP_EXTERNAL_PREFIX=$HOME/local
RUN cmake --build cmake-out -- -j ${NCPU:-4}
