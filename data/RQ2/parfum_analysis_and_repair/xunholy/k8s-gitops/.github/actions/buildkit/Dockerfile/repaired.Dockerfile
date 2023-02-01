FROM ubuntu:22.04

ARG TARGETARCH
ARG KUBESEAL_VERSION=0.15.0
ARG KUSTOMIZE_VERSION=3.9.3
ARG YQ_VERSION=3.4.1

WORKDIR /

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
  apt-get install --no-install-recommends -y \
  apt-transport-https \
  build-essential \
  ca-certificates \
  openssh-client \
  curl \
  gnupg \
  gnupg2 \
  git \
  jq \
  shellcheck \
  dnsutils \
  git-crypt && rm -rf /var/lib/apt/lists/*;

# Install kubectl
RUN curl -f -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
  apt-get update && \
  apt-get install --no-install-recommends -y kubectl && rm -rf /var/lib/apt/lists/*;

# Install helm v3
RUN curl -f https://baltocdn.com/helm/signing.asc | apt-key add - && \
  echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list && \
  apt-get update && \
  apt-get install --no-install-recommends -y helm && rm -rf /var/lib/apt/lists/*;

# Install yq
RUN curl -f -sL https://github.com/mikefarah/yq/releases/download/3.3.0/yq_linux_${TARGETARCH} -o /usr/bin/yq && \
  chmod +x /usr/bin/yq

# Install kubeseal
RUN curl -f -sL -o /usr/bin/kubeseal https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION}/kubeseal-linux-${TARGETARCH} && \
  chmod +x /usr/bin/kubeseal

# Install kustomize
RUN curl -f -sL -o kustomize.tar.gz https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_${TARGETARCH}.tar.gz && \
  tar -C /usr/bin -xvzf kustomize.tar.gz && \
  chmod +x /usr/bin/kustomize && rm kustomize.tar.gz

# Install kubeval - Only supports AMD64 currently
# TODO: Consider compiling from source code for arm64
RUN curl -f -sL -o kubeval.tar.gz https://github.com/instrumenta/kubeval/releases/latest/download/kubeval-linux-amd64.tar.gz && \
  tar -C /usr/bin -xvzf kubeval.tar.gz && \
  chmod +x /usr/bin/kubeval && rm kubeval.tar.gz

CMD bash
