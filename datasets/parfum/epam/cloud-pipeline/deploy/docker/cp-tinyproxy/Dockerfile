# Copyright 2017-2020 EPAM Systems, Inc. (https://www.epam.com/)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM centos:7

# 1. TinyProxy (HTTP proxy)
RUN yum install wget \
                gcc \
                make -y

RUN mkdir -p /opt/tinyproxy && \
    cd /opt/tinyproxy && \
    wget https://github.com/tinyproxy/tinyproxy/releases/download/1.10.0/tinyproxy-1.10.0.tar.gz -O tinyproxy.tgz && \
    tar -zxf tinyproxy.tgz && \
    rm -f tinyproxy.tgz && \
    cd tinyproxy* && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install

# This is a template file to format usage statistics (curl tinyproxy.stats)
# See http://tinyproxy.github.io/: "StatHost" option
ADD stats.json /opt/tinyproxy/stats.json

# 2. NGINX (TCP/UDP forward proxy)
RUN yum install -y epel-release
# Since 1.20 we shall install "stream" explicitly
RUN yum install -y nginx nginx-mod-stream

ADD init /init
RUN chmod +x /init
