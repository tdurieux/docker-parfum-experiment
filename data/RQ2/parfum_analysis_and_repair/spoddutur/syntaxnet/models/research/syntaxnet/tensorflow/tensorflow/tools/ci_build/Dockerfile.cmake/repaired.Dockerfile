# Copyright 2017 The TensorFlow Authors. All Rights Reserved.
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
# ==============================================================================
FROM ubuntu:16.04

MAINTAINER Shanqing Cai <cais@google.com>

# Copy and run the install scripts.
COPY install/*.sh /install/
RUN /install/install_bootstrap_deb_packages.sh
RUN /install/install_deb_packages.sh

RUN apt-get update
RUN apt-get install -y --no-install-recommends python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade numpy
RUN pip install --no-cache-dir --upgrade autograd

# Install golang
RUN add-apt-repository -y ppa:ubuntu-lxc/lxd-stable
RUN apt-get install --no-install-recommends -y golang && rm -rf /var/lib/apt/lists/*;
