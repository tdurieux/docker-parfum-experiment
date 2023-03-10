# Copyright (c) 2018 Intel Corporation
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


# Single staged Dockerfile to build wca as pex file that includes
# confluent kafka python library build from sources.


FROM centos:7

RUN echo "" && rpm --import https://packages.confluent.io/rpm/5.2/archive.key
COPY /configs/confluent_repo/confluent.repo /etc/yum.repos.d/confluent.repo

RUN yum -y update && yum -y install epel-release && rm -rf /var/cache/yum
RUN yum -y install python3 python-pip which make git \
        librdkafka1 librdkafka-devel gcc python3-devel && rm -rf /var/cache/yum

WORKDIR /wca

RUN git clone https://github.com/confluentinc/confluent-kafka-python

WORKDIR /wca/confluent-kafka-python
RUN git checkout v1.2.0  # newest version as for 2019-12-10

WORKDIR /wca

ENV OPTIONAL_FEATURES=kafka_storage

# Cache will be probably invalidated here.
COPY . .
RUN make clean
RUN make venv

RUN make wca_package
