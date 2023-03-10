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

FROM nvidia/cuda:9.0-devel-ubuntu16.04

COPY utils/apt-install-and-clear.sh /usr/local/bin/apt-install-and-clear

RUN apt-get update --fix-missing

RUN apt-install-and-clear -y bzip2 wget sudo binutils git

RUN wget -q https://developer.download.nvidia.com/compute/redist/cudnn/v7.6.0/cudnn-9.0-linux-x64-v7.6.0.64.tgz && \
    tar --no-same-owner -xzf cudnn-9.0-linux-x64-v7.6.0.64.tgz -C /usr/local && \
    rm cudnn-9.0-linux-x64-v7.6.0.64.tgz && \
    ldconfig

COPY install/ubuntu_install_conda.sh /install/ubuntu_install_conda.sh
RUN bash /install/ubuntu_install_conda.sh

ENV PATH /opt/conda/bin:$PATH
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64
ENV CONDA_BLD_PATH /tmp
