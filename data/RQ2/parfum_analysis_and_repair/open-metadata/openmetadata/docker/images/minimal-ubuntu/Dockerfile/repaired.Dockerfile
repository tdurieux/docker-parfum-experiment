#  Copyright 2021 Collate
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#  http://www.apache.org/licenses/LICENSE-2.0
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

# Dockerfile - minimal-ubuntu
# usage: docker build -t minimal-ubuntu:0.1 .

FROM ubuntu:xenial-20210416

# environment variables
ENV DEBIAN_FRONTEND noninteractive

# update
RUN apt update -y && \
    # editor
    apt install --no-install-recommends -y vim nano && \
    # general
    apt install --no-install-recommends -y man sudo sshpass less jq ntp bc && \
    # network commands
    apt install --no-install-recommends -y net-tools iputils-ping dnsutils lsof curl wget telnet && rm -rf /var/lib/apt/lists/*;

# python
RUN apt install --no-install-recommends -y python-dev && \
    curl -f "https://bootstrap.pypa.io/get-pip.py" -o /tmp/get-pip.py && \
    python /tmp/get-pip.py && rm -rf /var/lib/apt/lists/*;

# java
RUN apt install --no-install-recommends -y openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;
# maven
#RUN apt install -y maven=3.3.9-3

# supervisord
RUN pip install --no-cache-dir supervisor==3.3.3 && \
    mkdir -p /var/log/supervisord/

# converts the dash to bash terminal for easy scripting
RUN update-alternatives --install /bin/sh sh /bin/bash 100 && \
    update-alternatives --install /bin/sh sh /bin/dash 200 && \
    echo 1 | update-alternatives --config sh