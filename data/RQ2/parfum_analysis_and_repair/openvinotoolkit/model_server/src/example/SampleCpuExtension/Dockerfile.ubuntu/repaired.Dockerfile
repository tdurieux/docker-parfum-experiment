#
# Copyright (c) 2021 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

ARG BASE_IMAGE=ubuntu:20.04
FROM $BASE_IMAGE as base_build

ARG TEMP_DIR=/tmp/openvino_installer
ARG DLDT_PACKAGE_URL
ARG APT_OV_PACKAGE

RUN apt update && apt install --no-install-recommends -y build-essential wget make python3 && rm -rf /var/lib/apt/lists/*;

WORKDIR /

# OV toolkit package
RUN echo "installing apt package" && \
    wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB && \
    apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB && \
    echo "deb https://apt.repos.intel.com/openvino/2022 focal main" | tee /etc/apt/sources.list.d/intel-openvino-2022.list && \
    apt update && \
    apt install --no-install-recommends -y $APT_OV_PACKAGE && rm -rf /var/lib/apt/lists/*;

WORKDIR /workspace
COPY Makefile ov_extension.cpp CustomReluOp.cpp CustomReluOp.hpp ./

RUN make
