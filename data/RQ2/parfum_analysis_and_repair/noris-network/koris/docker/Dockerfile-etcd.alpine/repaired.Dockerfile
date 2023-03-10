FROM alpine:3.8
MAINTAINER Oz Tiram <oz.tiram@gmail.com>

RUN apk update \
    && apk add --no-cache openssh jq bash alpine-sdk python3-dev libressl-dev linux-headers py3-cryptography libffi-dev make

RUN pip3 install --no-cache-dir -U pip && \
    pip3 install --no-cache-dir flake8 pylint pylint-exit python-gitlab python-cinderclient==3.6.1

COPY requirements.txt requirements_ci.txt ./

RUN curl -f -L https://github.com/etcd-io/etcd/releases/download/v3.3.11/etcd-v3.3.11-linux-amd64.tar.gz -o etcd-v3.3.11-linux-amd64.tar.gz && \
    tar xf etcd-v3.3.11-linux-amd64.tar.gz && \
    cd etcd-v3.3.11-linux-amd64 && \
    cp -v etcd /usr/local/bin/ && \
    cp -v etcdctl /usr/local/bin/ && \
    chmod -v +x /usr/local/bin/etcdctl && \
    chmod -v +x /usr/local/bin/etcd && \
    cd .. && \
    rm -R etcd-v3.3.11* && rm etcd-v3.3.11-linux-amd64.tar.gz

RUN curl --retry 10 -fssL https://github.com/mikefarah/yq/releases/download/2.3.0/yq_linux_amd64 -o /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq


COPY kubectl .
RUN mv kubectl /usr/local/bin/kubectl \
    && chmod  777  /usr/local/bin/kubectl

