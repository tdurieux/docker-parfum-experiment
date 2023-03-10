#
# Copyright (c) 2019, 2020 Oracle and/or its affiliates. All rights reserved.
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

FROM container-registry.oracle.com/os/oraclelinux:7.5

RUN yum install -y gcc cmake java-1.8.0-openjdk-devel.x86_64 make && rm -rf /var/cache/yum
RUN yum install -y gcc-c++ && rm -rf /var/cache/yum

RUN mkdir  /build
WORKDIR /build

