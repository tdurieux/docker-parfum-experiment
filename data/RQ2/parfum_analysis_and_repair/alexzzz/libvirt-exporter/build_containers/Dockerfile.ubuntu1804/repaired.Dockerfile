FROM ubuntu:bionic

ENV PATH=$PATH:/usr/local/go/bin

RUN set -ex && \
    apt update && \
    DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -yq g++ libvirt0 libvirt-dev wget git && \
    wget https://golang.org/dl/go1.16.2.linux-amd64.tar.gz && \
    rm -rf /usr/local/go && tar -C /usr/local -xzf go1.16.2.linux-amd64.tar.gz && \
    export PATH=$PATH:/usr/local/go/bin && rm go1.16.2.linux-amd64.tar.gz && rm -rf /var/lib/apt/lists/*;
