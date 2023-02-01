# *****************************************************************************
#
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
#
# ******************************************************************************

FROM ubuntu:20.04
ARG OS
ARG SRC_PATH

# Install any .deb dependecies
RUN apt-get update && \
    apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install python3-pip python3-dev python3-virtualenv groff vim less git wget nano libssl-dev libffi-dev libffi7 && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# To cahnge POSIX locale to en_US.UTF-8
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y locales && rm -rf /var/lib/apt/lists/*;

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install any python dependencies
RUN python3 -m pip install -UI qtconsole==5.1.1 pip==21.1.2 && \
    python3 -m pip install boto3 backoff patchwork fabric fabvenv awscli argparse requests ujson jupyter pycryptodome

# Configuring ssh for user
RUN mkdir -p /root/.ssh; echo "Host *" > /root/.ssh/config; \
    echo "StrictHostKeyChecking no" >>  /root/.ssh/config; \
    echo "UserKnownHostsFile=/dev/null" >> /root/.ssh/config; \
    echo "GlobalKnownHostsFile=/dev/null" >> /root/.ssh/config; \
    echo "ConnectTimeout=30" >> /root/.ssh/config

# Configuring log directories
RUN mkdir -p /response; chmod a+rwx /response && \
    mkdir -p /logs/ssn; chmod a+rwx /logs/ssn && \
    mkdir -p /logs/project; chmod a+rwx /logs/project && \
    mkdir -p /logs/edge; chmod a+rwx /logs/edge && \
    mkdir -p /logs/status; chmod a+rwx /logs/status && \
    mkdir -p /logs/notebook; chmod a+rwx /logs/notebook && \
    mkdir -p /logs/dataengine; chmod a+rwx /logs/dataengine && \
    mkdir -p /logs/dataengine-service; chmod a+rwx /logs/dataengine-service

# Copying all base scripts to docker
ENV PROVISION_CONFIG_DIR /root/conf/
ENV KEYFILE_DIR /root/keys/
ENV AWS_DIR /root/.aws

RUN mkdir -p /root/conf && \
    mkdir -p /root/scripts && \
    mkdir -p /root/templates && \
    mkdir -p /root/files && \
    mkdir -p /usr/lib/python3.8/datalab && \
    mkdir -p /root/keys/.ssh

COPY ${SRC_PATH}base/ /root
COPY ${SRC_PATH}general/conf/* /root/conf/
COPY ${SRC_PATH}general/api/*.py /bin/
COPY ${SRC_PATH}general/scripts/aws/common_* /root/scripts/
COPY ${SRC_PATH}general/lib/aws/* /usr/lib/python3.8/datalab/
COPY ${SRC_PATH}general/lib/os/${OS}/common_lib.py /usr/lib/python3.8/datalab/common_lib.py
COPY ${SRC_PATH}general/lib/os/fab.py /usr/lib/python3.8/datalab/fab.py
COPY ${SRC_PATH}general/lib/os/logger.py /usr/lib/python3.8/datalab/logger.py
COPY ${SRC_PATH}general/files/os/ivysettings.xml /root/templates/
COPY ${SRC_PATH}general/files/os/local_endpoint.json /root/files/
COPY ${SRC_PATH}project/templates/locations/ /root/locations/

RUN chmod a+x /root/*.py && \
    chmod a+x /root/scripts/* && \
    chmod a+x /bin/*.py

ENTRYPOINT ["/root/entrypoint.py"]
