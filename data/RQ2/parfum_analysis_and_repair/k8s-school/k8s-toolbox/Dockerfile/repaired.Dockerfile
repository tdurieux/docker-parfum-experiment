FROM debian:bookworm
MAINTAINER Fabrice Jammes <fabrice.jammes@in2p3.fr>

# RUN echo "deb http://ftp.debian.org/debian stretch-backports main" >> /etc/apt/sources.list

# Start with this long step not to re-run it on
# each Dockerfile update
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install apt-utils && \
    apt-get -y upgrade && \
    apt-get -y clean && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y update && \
    apt-get -y --no-install-recommends install curl bash-completion git gnupg jq \
    kubectx lsb-release locales make \
    nano openssh-client parallel \
    unzip vim wget zsh && rm -rf /var/lib/apt/lists/*;

# Uncomment en_US.UTF-8 for inclusion in generation
RUN sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen

# Generate locale
RUN locale-gen

# Install Google cloud SDK
ENV CLOUD_SDK google-cloud-sdk-360.0.0-linux-x86_64.tar.gz
RUN cd /opt && curl -f -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${CLOUD_SDK} && \
    tar zxvf $CLOUD_SDK && \
    rm $CLOUD_SDK

# Install helm
ENV HELM_VERSION 3.5.4
RUN wget -O /tmp/helm.tgz \
    https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    cd /tmp && \
    tar zxvf /tmp/helm.tgz && \
    rm /tmp/helm.tgz && \
    chmod +x /tmp/linux-amd64/helm && \
    mv /tmp/linux-amd64/helm /usr/local/bin/helm

# Install kubectl
ENV KUBECTL_VERSION 1.19.0
RUN wget -O /usr/local/bin/kubectl \
    https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x /usr/local/bin/kubectl

# Install kustomize
ENV KUSTOMIZE_VERSION v3.8.4
RUN wget -O /tmp/kustomize.tgz \
    https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz && \
    tar zxvf /tmp/kustomize.tgz && \
    rm /tmp/kustomize.tgz && \
    chmod +x kustomize && \
    mv kustomize /usr/local/bin/kustomize

# Install kubeval
ENV KUBEVAL_VERSION 0.15.0
RUN wget https://github.com/garethr/kubeval/releases/download/${KUBEVAL_VERSION}/kubeval-linux-amd64.tar.gz && \
    tar xf kubeval-linux-amd64.tar.gz && \
    mv kubeval /usr/local/bin && \
    rm kubeval-linux-amd64.tar.gz


ENV STERN_VERSION 1.11.0
RUN wget -O /usr/local/bin/stern \
    https://github.com/wercker/stern/releases/download/${STERN_VERSION}/stern_linux_amd64 && \
    chmod +x /usr/local/bin/stern

RUN wget -q --show-progress --https-only --timestamping \
    https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 \
    https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 && \
    chmod o+x cfssl_linux-amd64 cfssljson_linux-amd64 && \
    mv cfssl_linux-amd64 /usr/local/bin/cfssl && \
    mv cfssljson_linux-amd64 /usr/local/bin/cfssljson

ENV GO_VERSION 1.15.2
ENV GO_PKG go${GO_VERSION}.linux-amd64.tar.gz
RUN wget https://dl.google.com/go/$GO_PKG && \
    tar -xvf $GO_PKG && \
    mv go /usr/local

ENV GOROOT /usr/local/go
ENV GOPATH /go

RUN wget -O /etc/kubectl_aliases https://raw.githubusercontent.com/ahmetb/kubectl-alias/master/.kubectl_aliases

COPY rootfs /

ARG FORCE_GO_REBUILD=false
RUN $GOROOT/bin/go get -v github.com/k8s-school/clouder
