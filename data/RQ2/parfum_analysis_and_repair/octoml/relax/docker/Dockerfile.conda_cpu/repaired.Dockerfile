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

FROM ubuntu:16.04

RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y bzip2 wget sudo binutils git && rm -rf /var/lib/apt/lists/*;

COPY install/ubuntu_install_conda.sh /install/ubuntu_install_conda.sh
RUN bash /install/ubuntu_install_conda.sh

ENV PATH /opt/conda/bin:$PATH
ENV CONDA_BLD_PATH /tmp
ENV CONDA_PKGS_DIRS /workspace/.conda/pkgs
ENV CONDA_ENVS_DIRS /workspace/.conda/env
