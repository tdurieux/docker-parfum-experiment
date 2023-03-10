# Copyright 2020 Sony Corporation. All Rights Reserved.
# Copyright 2022 Sony Group Corporation. All Rights Reserved.
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

RUN yum install -y epel-release yum-utils \
    && yum install -y bzip2 curl libffi-devel make openssl-devel zlib-devel \
    && yum group install -y "Development Tools" \
    && yum clean all && rm -rf /var/cache/yum

RUN mkdir -p /tmp/deps \
    && cd /tmp/deps \
    && curl -f -O https://www.python.org/ftp/python/3.7.10/Python-3.7.10.tgz \
    && tar xzf Python-3.7.10.tgz \
    && cd Python-3.7.10 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-optimizations \
    && make altinstall \
    && ln -sf /usr/local/bin/python3.7 /usr/local/bin/python3 \
    && ln -sf /usr/local/bin/pip3.7 /usr/local/bin/pip3 \
    && rm -rf /tmp/deps && rm Python-3.7.10.tgz

RUN pip3 install --no-cache-dir -U pip \
    && pip install --no-cache-dir setuptools wheel

