# Copyright (c) 2018 SAP SE or an SAP affiliate company. All rights reserved. This file is licensed under the Apache Software License, v. 2 except as noted otherwise in the LICENSE file
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# build gardenctl binary
FROM golang:1.14
RUN mkdir -p /go/src/github.com/gardener/gardenctl &&\
    cd /go/src/github.com/gardener &&\
    git clone https://github.com/gardener/gardenctl.git &&\
    cd ./gardenctl &&\
    CGO_ENABLED=0 GOOS=linux go build -mod=vendor -a -installsuffix cgo -o gardenctl cmd/gardenctl/main.go

# minimal Ubuntu LTS version
FROM ubuntu:20.04

COPY --from=0 /go/src/github.com/gardener/gardenctl/gardenctl .
#COPY clusters /root/clusters
#COPY config /root/.garden/config

# run as root in root
USER root
WORKDIR /

# install basic tools
RUN apt-get --yes update; \
    apt-get --yes --no-install-recommends install curl; rm -rf /var/lib/apt/lists/*; \
    apt-get --yes --no-install-recommends install tree; \
    apt-get --yes --no-install-recommends install silversearcher-ag; \
    apt-get --yes --no-install-recommends install htop; \
    apt-get --yes --no-install-recommends install less; \
    apt-get --yes --no-install-recommends install vim; \
    apt-get --yes --no-install-recommends install tmux; \
    apt-get --yes --no-install-recommends install bash-completion; \
    apt-get --yes --no-install-recommends install unzip; \
    curl -f -sL https://github.com/jingweno/ccat/releases/download/v1.1.0/linux-amd64-1.1.0.tar.gz -o ccat.tar.gz && tar -zxvf ccat.tar.gz linux-amd64-1.1.0/ccat && mv linux-amd64-1.1.0/ccat /bin/cat && rm -rf linux-amd64-1.1.0 ccat.tar.gz && chmod 755 /bin/cat; \
    curl -f -sL https://stedolan.github.io/jq/download/linux64/jq -o /bin/jq && chmod 755 /bin/jq; \
    curl -f -sL https://github.com/bronze1man/yaml2json/raw/master/builds/linux_amd64/yaml2json -o /bin/yaml2json && chmod 755 /bin/yaml2json; \
    # remove package lists to safe space
    rm -rf /var/lib/apt/lists

# install network tools
RUN apt-get --yes update; \
    apt-get --yes --no-install-recommends install dnsutils; rm -rf /var/lib/apt/lists/*; \
    apt-get --yes --no-install-recommends install netcat-openbsd; \
    apt-get --yes --no-install-recommends install iproute2; \
    apt-get --yes --no-install-recommends install dstat; \
    apt-get --yes --no-install-recommends install ngrep; \
    apt-get --yes --no-install-recommends install tcpdump; \
    # remove package lists to safe space
    rm -rf /var/lib/apt/lists

# install Kubernetes CLI
RUN curl -f -sL https://storage.googleapis.com/kubernetes-release/release/$( curl -f -sL https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && chmod 755 /usr/local/bin/kubectl

# install minimal python
RUN apt-get --yes update; \
    apt-get --yes --no-install-recommends install python3-minimal; rm -rf /var/lib/apt/lists/*; \
    apt-get --yes --no-install-recommends install python3-distutils; \
    curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py; \
    python3 get-pip.py

# launch sh
ENTRYPOINT ["/bin/sh"]

# install Alibaba Cloud CLI
RUN curl -f https://aliyuncli.alicdn.com/aliyun-cli-linux-3.0.54-amd64.tgz -o aliyun-cli-linux-3.0.54-amd64.tgz; \
    tar xzvf  aliyun-cli-linux-3.0.54-amd64.tgz; rm aliyun-cli-linux-3.0.54-amd64.tgz \
    mv aliyun /usr/local/bin

# install AWS CLI
RUN pip install --no-cache-dir awscli

# install Azure CLI
RUN apt-get --yes update; \
    apt-get --yes --no-install-recommends install lsb-release gnupg apt-transport-https; rm -rf /var/lib/apt/lists/*; \
    AZ_REPO="$(lsb_release -cs)"; \
    echo "deb https://packages.microsoft.com/repos/azure-cli $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list; \
    curl -f -sL https://packages.microsoft.com/keys/microsoft.asc | apt-key add -; \
    apt-get --yes update && apt-get --yes --no-install-recommends install azure-cli; \
    apt-get --yes --purge remove lsb-release gnupg apt-transport-https; \
    # remove package lists to safe space
    rm -rf /var/lib/apt/lists

# install GCP CLI
RUN apt-get --yes update; \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list; \
    apt-get install -y --no-install-recommends apt-transport-https ca-certificates gnupg; rm -rf /var/lib/apt/lists/*; \
    curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -; \
    apt-get update && apt-get install --no-install-recommends --yes google-cloud-sdk; \
    # remove package lists to safe space
    rm -rf /var/lib/apt/lists

# install OpenStack CLI
# does currently not support python 3
# RUN pip install python-novaclient python-glanceclient python-cinderclient python-swiftclient

# install terraform
RUN TER_VER=$( curl -f -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep tag_name | cut -d: -f2 | tr -d \"\,\v | awk '{$1=$1};1') ; \
    curl -f -sL https://releases.hashicorp.com/terraform/${TER_VER}/terraform_${TER_VER}_linux_amd64.zip -o terraform_${VER}_linux_amd64.zip; \
    unzip terraform_${VER}_linux_amd64.zip; \
    mv terraform /bin/terraform

# install Gardener CLI
RUN mkdir -p /opt/gardenctl/bin &&\
    mv gardenctl /opt/gardenctl/bin/gardenctl &&\
    ln -s /opt/gardenctl/bin/gardenctl /usr/local/bin/gardenctl &&\
    gardenctl completion bash > /root/gardenctl_bash_completion.sh &&\
    echo ". /etc/profile" >> /root/.bashrc &&\
    echo ". /root/gardenctl_bash_completion.sh" >> /root/.bashrc
