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
# Dockerfile to build and run MXNet on Ubuntu 16.04 for CPU

FROM ubuntu:16.04

WORKDIR /work

RUN apt-get update
COPY install/ubuntu_python.sh /work/
RUN /work/ubuntu_python.sh

COPY install/ubuntu_arm_qemu.sh /work
RUN /work/ubuntu_arm_qemu.sh

COPY install/ubuntu_arm_qemu_bin.sh /work
RUN /work/ubuntu_arm_qemu_bin.sh

ARG USER_ID=0
ARG GROUP_ID=0
COPY install/ubuntu_adduser.sh /work/
RUN /work/ubuntu_adduser.sh

COPY runtime_functions.sh /work/
COPY qemu/* /work/

# SSH to the Qemu VM