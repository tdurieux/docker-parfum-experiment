# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

FROM ubuntu:18.04

ARG UNAME=jenkins
ARG GNAME=jenkins
ARG UID=1000
ARG GID=1000

COPY scripts/ansible /ansible

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install make build-essential git jq vim curl wget netcat && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ bionic main" | \
      tee /etc/apt/sources.list.d/azure-cli.list && \
    wget https://packages.microsoft.com/keys/microsoft.asc && \
    apt-key add microsoft.asc && \
    apt-get update && \
    apt-get -y install apt-transport-https azure-cli unzip && \
    curl https://oejenkins.blob.core.windows.net/oejenkins/oe-engine -o /usr/bin/oe-engine  && \
    chmod +x /usr/bin/oe-engine && \
    wget https://releases.hashicorp.com/packer/1.3.5/packer_1.3.5_linux_amd64.zip && \
    unzip packer_1.3.5_linux_amd64.zip -d /usr/sbin && \
    rm packer_1.3.5_linux_amd64.zip && \
    groupadd --gid ${GID} ${GNAME} && \
    useradd --create-home --uid ${UID} --gid ${GID} --shell /bin/bash ${UNAME} && \
    /ansible/install-ansible.sh
