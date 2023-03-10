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


FROM centos:7 AS mysql_tpm_gauge

RUN yum -y update
RUN yum -y install epel-release && rm -rf /var/cache/yum
RUN yum -y install python36 python-pip python36-pip which make git mysql && rm -rf /var/cache/yum

RUN pip3 install --no-cache-dir mysql-connector-python==8.0.19

WORKDIR /mysql-tpm-gauge

COPY mysql_tpm_gauge.py .
