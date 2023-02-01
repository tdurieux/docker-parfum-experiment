#
# Copyright 2016 Google Inc.
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

FROM ubuntu:16.04

ENV APT_LISTCHANGES_FRONTEND none
ENV DEBIAN_FRONTEND noninteractive

#RUN sed -i -e 's/archive.ubuntu.com/mirror.symnds.com/g' /etc/apt/sources.list && \
COPY requirements.txt /tmp/requirements.txt

RUN sed -i -e 's/archive.ubuntu.com/mirrors.kernel.org/g' /etc/apt/sources.list && \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends apt-utils curl iputils-ping telnet netcat-traditional python-setuptools python-pip libraw-dev && \
    pip install --upgrade pip && \
    pip install -r /tmp/requirements.txt && \
    apt-get clean && rm -rf /tmp/* /var/tmp/*
