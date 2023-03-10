# Copyright (c) 2019 vChain, Inc. All Rights Reserved.
# This software is released under GPL3.
# The full license information can be found under:
# https://www.gnu.org/licenses/gpl-3.0.en.html

FROM docker
RUN apk upgrade --update-cache --available
RUN apk add --no-cache git openssl curl
RUN curl -f -Lo /usr/local/bin/kubectl \
    https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x /usr/local/bin/kubectl
RUN curl -f -Lo /usr/local/bin/kind \
    https://github.com/kubernetes-sigs/kind/releases/download/v0.3.0/kind-linux-amd64 \
    && chmod +x /usr/local/bin/kind
RUN curl -f -L https://git.io/get_helm.sh | sh

ADD . /kube-notary

WORKDIR /kube-notary/test/e2e

RUN mkdir .vcn

ENTRYPOINT [ "sh", "-c", "/kube-notary/test/e2e/run.sh" ]
