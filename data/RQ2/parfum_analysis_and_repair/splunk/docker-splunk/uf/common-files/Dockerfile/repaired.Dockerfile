# Copyright 2018-2021 Splunk
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

ARG SPLUNK_BASE_IMAGE=base-debian-10

#
# Download and unpack Splunk Universal Forwarder
#
FROM ${SPLUNK_BASE_IMAGE}:latest as package
ARG SPLUNK_BUILD_URL
ENV SPLUNK_HOME=/opt/splunkforwarder
RUN echo "Downloading Splunk and validating the checksum at: ${SPLUNK_BUILD_URL}" \
    && wget -qO /tmp/`basename ${SPLUNK_BUILD_URL}` ${SPLUNK_BUILD_URL} \
    && wget -qO /tmp/splunk.tgz.sha512 ${SPLUNK_BUILD_URL}.sha512 \
    && cd /tmp \
    && echo "$(cat /tmp/splunk.tgz.sha512)" | sha512sum --check  --status \
    && rm /tmp/splunk.tgz.sha512 \
    && tar -C /opt -zxf /tmp/`basename ${SPLUNK_BUILD_URL}` \ 
    && mv ${SPLUNK_HOME}/etc ${SPLUNK_HOME}-etc \
    && mkdir -p ${SPLUNK_HOME}/etc ${SPLUNK_HOME}/var
COPY uf/common-files/apps ${SPLUNK_HOME}-etc/apps/


#
# Bare Splunk Universal Forwarder Image without Ansible (BYO entrypoint)
#
FROM ${SPLUNK_BASE_IMAGE}:latest as bare
LABEL maintainer="support@splunk.com"

# Currently kubernetes only accepts UID and not USER field to
# start a container as a particular user. So we create Splunk
# user with pre-determined UID.
ARG UID=41812
ARG GID=41812

ENV SPLUNK_HOME=/opt/splunkforwarder \
    SPLUNK_GROUP=splunk \
    SPLUNK_USER=splunk

# Simple script used to populate/upgrade splunk/etc directory
COPY [ "uf/common-files/updateetc.sh", "/sbin/"]

# Setup users and groups
RUN groupadd -r -g ${GID} ${SPLUNK_GROUP} \
    && useradd -r -m -u ${UID} -g ${GID} -s /bin/bash ${SPLUNK_USER} \
    && chmod 755 /sbin/updateetc.sh

# Copy files from package
COPY --from=package --chown=splunk:splunk /opt /opt

USER ${SPLUNK_USER}
WORKDIR ${SPLUNK_HOME}
EXPOSE 8089 8088 9997
VOLUME [ "/opt/splunkforwarder/etc", "/opt/splunkforwarder/var" ]



#
# Full Splunk Universal Forwarder Image with Ansible
#
FROM bare

ARG SPLUNK_DEFAULTS_URL

ENV SPLUNK_ROLE=splunk_universal_forwarder \
    SPLUNK_DEFAULTS_URL=${SPLUNK_DEFAULTS_URL} \
    SPLUNK_ANSIBLE_HOME=/opt/ansible \
    SPLUNK_OPT=/opt \
    ANSIBLE_USER=ansible \
    ANSIBLE_GROUP=ansible \
    CONTAINER_ARTIFACT_DIR=/opt/container_artifact

# Copy ansible playbooks
COPY splunk-ansible ${SPLUNK_ANSIBLE_HOME}

# Copy scripts
COPY [ "uf/common-files/entrypoint.sh", "uf/common-files/checkstate.sh", "uf/common-files/createdefaults.py", "/sbin/"]

USER root

# Setup users and groups