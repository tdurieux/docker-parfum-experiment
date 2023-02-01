# Copyright (c) 2015 Tigera, Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
### calico/test
# This image is used by various calico repositories and components to run UTs
# and STs. It has libcalico, nose, and other common python libraries
# already installed
#
# For UTs:
#  - volume mount in python code that uses libcalico
#  - volume mount in your unit tests for this code
#  - run 'nosetests'
#
# This container can also be used for running STs written in python. This
# eliminates all dependencies besides docker on the host system to enable
# running of the ST frameworks. Additionally, this allows for sharing of
# common ST framework code (which calico-containers and libnetwork both use).
# To run:
# - volume mount the docker socket, allowing the STs to launch docker
#   containers alongside itself.
# - eliminate most isolation, (--uts=host --pid=host --net=host --privileged)
# - volume mount your ST source code
# - run 'nosetests'
FROM docker:1.13.0
MAINTAINER Tom Denham <tom@projectcalico.org>

# Running STs in this containers require that it has all dependencies installed
# for executing calicoctl. Install these dependencies (including glibc:
# https://github.com/jeanblanchard/docker-alpine-glibc/blob/master/Dockerfile)
# We install glibc onto the official docker image (instead of adding docker to
# the libc image) since glibc installs are more constant than the
# docker-in-docker installation and configuration.
RUN apk add --update python python-dev py2-pip py-setuptools openssl-dev libffi-dev \
        git musl-dev gcc tshark netcat-openbsd \
        iptables ip6tables iproute2 iputils ipset curl && \
        curl -o glibc.apk -L "https://github.com/andyshinn/alpine-pkg-glibc/releases/download/2.23-r1/glibc-2.23-r1.apk" && \
        apk add --allow-untrusted glibc.apk && \
        curl -o glibc-bin.apk -L "https://github.com/andyshinn/alpine-pkg-glibc/releases/download/2.23-r1/glibc-bin-2.23-r1.apk" && \
        apk add --allow-untrusted glibc-bin.apk && \
        /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc/usr/lib && \
        echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
        rm -f glibc.apk glibc-bin.apk && \
        rm -rf /var/cache/apk/*

# Install libcalico and its requirements
ADD . /tmp/pycalico
RUN pip install /tmp/pycalico
RUN pip install -r /tmp/pycalico/calico_test/requirements.txt

# Add the testing framework
ADD calico_test/tests tests

# Install etcdctl
RUN wget https://github.com/coreos/etcd/releases/download/v2.3.3/etcd-v2.3.3-linux-amd64.tar.gz && \
    tar -xzf etcd-v2.3.3-linux-amd64.tar.gz && \
    cd etcd-v2.3.3-linux-amd64 && \
    ln -s etcdctl /usr/local/bin/

# The container is used by mounting the code-under-test to /code
WORKDIR /code/
