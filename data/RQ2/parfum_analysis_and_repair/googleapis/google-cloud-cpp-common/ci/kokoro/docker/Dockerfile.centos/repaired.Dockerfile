# Copyright 2020 Google LLC
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

ARG DISTRO_VERSION=7
FROM centos:${DISTRO_VERSION}

# We need to install cmake3, which on CentOS-7 requires an extra source
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum install -y centos-release-scl && rm -rf /var/cache/yum
RUN yum-config-manager --enable rhel-server-rhscl-7-rpms

RUN yum makecache && \
    yum install -y automake cmake3 curl-devel gcc gcc-c++ git libtool \
        make openssl-devel pkgconfig tar wget which zlib-devel && rm -rf /var/cache/yum
RUN ln -sf /usr/bin/cmake3 /usr/bin/cmake && ln -sf /usr/bin/ctest3 /usr/bin/ctest
