# Copyright (c) 2019 Intel Corporation
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

FROM centos:7

RUN yum -y update
RUN yum -y install epel-release git make gcc libuuid libuuid-devel libxml2-devel libxml2
RUN git clone https://bitbucket.org/jisooy/pmbench
WORKDIR /pmbench
ADD pmbench.patch .
RUN git apply pmbench.patch
RUN make pmbench

RUN useradd -M pmbench
