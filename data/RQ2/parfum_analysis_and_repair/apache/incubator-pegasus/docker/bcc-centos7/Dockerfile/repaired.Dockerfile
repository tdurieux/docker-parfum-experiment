# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

FROM centos:7.5.1804 as builder

LABEL maintainer=wutao

RUN yum install -y epel-release \
  && yum update -y \
  && yum groupinstall -y "Development tools" \
  && yum install -y elfutils-libelf-devel git bison flex ncurses-devel python3 \
  && yum install -y luajit luajit-devel \
  && yum -y install centos-release-scl \
  && yum-config-manager --enable rhel-server-rhscl-7-rpms \
  && yum install -y devtoolset-7 llvm-toolset-7 llvm-toolset-7-llvm-devel llvm-toolset-7-llvm-static llvm-toolset-7-clang-devel \
  && yum clean all \
  && rm -rf /var/cache/yum;

RUN pip3 install --no-cache-dir cmake

# install results to /root/bcc