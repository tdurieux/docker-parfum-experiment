# -*- mode: dockerfile -*-
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
#
# Dockerfile to build MXNet for ARM64/ARMv8

FROM mxnetcipinned/dockcross-linux-arm64:11262018

ENV ARCH aarch64
ENV HOSTCC gcc
ENV TARGET ARMV8

WORKDIR /work/deps

# gh issue #11567 https://github.com/apache/incubator-mxnet/issues/11567
#RUN sed -i '\#deb http://cdn-fastly.deb.debian.org/debian-security jessie/updates main#d' /etc/apt/sources.list
#RUN sed -i 's/cdn-fastly.//' /etc/apt/sources.list