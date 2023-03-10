FROM centos:7

RUN yum install -y \
    genisoimage-1.1.11 \
    libvirt \
    unzip \
    git \
    wget && rm -rf /var/cache/yum

RUN curl -f -O https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_linux_amd64.zip \
    && unzip ./terraform_* \
    && mv ./terraform /usr/local/bin/terraform

RUN curl -f -LO https://github.com/dmacvicar/terraform-provider-libvirt/releases/download/v0.4.4/terraform-provider-libvirt-0.4.4.CentOS_7.x86_64.tar.gz \
    && tar -zxvf ./terraform-provider-* \
    && mkdir -p /root/.terraform.d/plugins \
    && mv ./terraform-provider-libvirt /root/.terraform.d/plugins/ \
    && rm -f ./terraform*

RUN curl -f -LO https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.10.3.linux-amd64.tar.gz \
    && echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bash_profile \
    && mkdir -p ~/go/src/github.com/mahakamcloud/mahakam \
    && echo "export GOPATH=~/go" >> ~/.bash_profile \
    && source ~/.bash_profile && rm go1.10.3.linux-amd64.tar.gz

RUN wget https://storage.googleapis.com/kubernetes-helm/helm-v2.12.1-linux-amd64.tar.gz \
    && tar -zxvf ./helm-v2.12.1-linux-amd64.tar.gz \
    && mv ./linux-amd64/helm /usr/local/bin/helm \
    && helm init --client-only && rm ./helm-v2.12.1-linux-amd64.tar.gz
