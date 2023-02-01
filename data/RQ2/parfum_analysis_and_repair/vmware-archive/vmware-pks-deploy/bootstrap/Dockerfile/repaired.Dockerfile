#Copyright (c) 2018 VMware, Inc. All Rights Reserved.
#
#SPDX-License-Identifier: MIT
FROM alpine:3.7

ENV GOVC=https://github.com/vmware/govmomi/releases/download/v0.18.0/govc_linux_amd64.gz
ENV OVA=https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64.ova

# use this instead of curling it below to always update on new base images.
# use the curl below for faster iterations on building while testing.
# ADD $OVA /bootstrap.ova

RUN apk update && apk add --no-cache --virtual build-dependencies curl git bash jq openssh rsync py-pip python python-dev libffi-dev openssl-dev build-base && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir 'ansible<2.6' && \
    curl -f -L $OVA -o /bootstrap.ova && \
    curl -f -L $GOVC | gunzip > /usr/bin/govc && chmod +x /usr/bin/govc

COPY . /

ENTRYPOINT [ "/entrypoint.sh" ]
