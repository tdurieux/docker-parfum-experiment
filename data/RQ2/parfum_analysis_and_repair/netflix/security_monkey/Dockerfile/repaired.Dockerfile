# Copyright 2018 Netflix, Inc.
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

FROM ubuntu:18.04
MAINTAINER Netflix Open Source Development <talent@netflix.com>

ENV SECURITY_MONKEY_VERSION=v1.1.3 \
    SECURITY_MONKEY_SETTINGS=/usr/local/src/security_monkey/env-config/config-docker.py

SHELL ["/bin/bash", "-c"]
WORKDIR /usr/local/src/security_monkey
COPY requirements.txt /usr/local/src/security_monkey/

RUN echo "UTC" > /etc/timezone\

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update && apt-get install --no-install-recommends -y \
        python3.7 \
        python3-pip && rm -rf /var/lib/apt/lists/*;
RUN python3.7 -m pip install pip
RUN apt-get update && apt-get install --no-install-recommends -y \
        python3-distutils \
        python3-setuptools && rm -rf /var/lib/apt/lists/*;

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get install --no-install-recommends -y build-essential && \
    apt-get install --no-install-recommends -y wget postgresql postgresql-contrib libpq-dev libffi-dev libxml2-dev libxmlsec1-dev && \
    apt-get clean -y && \
    pip3 install --no-cache-dir setuptools --upgrade && \
    pip3 install --no-cache-dir pip --upgrade && \
    hash -d pip3 && \
    pip3 install --no-cache-dir "urllib3[secure]" --upgrade && \
    pip3 install --no-cache-dir google-compute-engine && \
    pip3 install --no-cache-dir cloudaux\[gcp\] && \
    pip3 install --no-cache-dir cloudaux\[openstack\] && \
    pip3 install --no-cache-dir python3-saml && \
    pip3 install --no-cache-dir -r requirements.txt && rm -rf /var/lib/apt/lists/*;

COPY . /usr/local/src/security_monkey
RUN pip3 install --no-cache-dir ."[onelogin]" && \
    /bin/mkdir -p /var/log/security_monkey/ && \
    /usr/bin/touch /var/log/security_monkey/securitymonkey.log

EXPOSE 5000
