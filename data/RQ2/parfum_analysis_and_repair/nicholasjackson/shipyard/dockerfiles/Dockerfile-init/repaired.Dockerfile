FROM ubuntu:latest

ENV TERM=xterm-256color
ENV KIND_VERSION=v0.5.1
ENV KUBECTL_VERSION=latest
ENV HELM_VERSION=v3.0.0-beta.4

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
      curl \
      zip \
      git && \
      apt-get clean && \
      apt-get autoremove --purge && rm -rf /var/lib/apt/lists/*;

# Install Kind
RUN curl -f -sLo ./kind https://github.com/kubernetes-sigs/kind/releases/download/$KIND_VERSION/kind-$(uname)-amd64 && \
    chmod +x ./kind && \
    mv ./kind /usr/local/bin/kind

# Install K3d
RUN curl -f -s https://raw.githubusercontent.com/rancher/k3d/master/install.sh | bash

# Install Kubectl
RUN curl -f -sLO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin

# Install Helm
RUN curl -f -sL https://get.helm.sh/helm-$HELM_VERSION-linux-amd64.tar.gz -o ./helm.tar.gz && \
    tar -xzf ./helm.tar.gz && \
    mv ./linux-amd64/helm /usr/local/bin && \
    rm ./helm.tar.gz