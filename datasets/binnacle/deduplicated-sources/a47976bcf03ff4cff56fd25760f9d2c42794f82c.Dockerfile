#
# The standard name for this image is ovn-kube-u

# Notes:
# This is for a development build where the ovn-kubernetes utilities
# are built in this Dockerfile and included in the image (instead of the deb package)
#
#
# So this file will change over time.

FROM ubuntu:18.04

USER root

RUN apt-get update && apt-get install -y iptables iproute2 curl software-properties-common setpriv

# We do not have much control over the exact version of OVS/OVN that can be
# obtained from upstream Ubuntu. guru@ovn.org maintains more latest versions of
# OVS/OVN packages at 3.19.28.122. Please comment out the next 3 lines if
# you prefer to use upstream Ubuntu packages instead.
RUN echo "deb http://3.19.28.122/openvswitch/stable /" |  tee /etc/apt/sources.list.d/openvswitch.list
RUN curl http://3.19.28.122/openvswitch/keyFile |  apt-key add -

RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# Install OVS and OVN packages.
RUN apt-get update && apt-get install -y openvswitch-switch openvswitch-common ovn-central ovn-common ovn-host kubectl

RUN mkdir -p /var/run/openvswitch
RUN mkdir -p /etc/cni/net.d
RUN mkdir -p /opt/cni/bin

# Built in ../../go_controller, then the binaries are copied here.
# put things where they are in the pkg
RUN mkdir -p /usr/libexec/cni/
COPY ovnkube ovn-kube-util /usr/bin/
COPY ovn-k8s-cni-overlay /usr/libexec/cni/ovn-k8s-cni-overlay

# ovnkube.sh is the entry point. This script examines environment
# variables to direct operation and configure ovn
COPY ovnkube.sh /root/
COPY ovn-debug.sh /root/
# override the pkg's ovn_k8s.conf with this local copy
COPY ovn_k8s.conf /etc/openvswitch/ovn_k8s.conf

# copy git commit number into image
RUN mkdir -p /root/.git/ /root/.git/refs/heads/
COPY .git/HEAD /root/.git/HEAD
COPY .git/refs/heads/ /root/.git/refs/heads/


LABEL io.k8s.display-name="ovn kubernetes" \
      io.k8s.description="ovnkube ubuntu image" 

WORKDIR /root
ENTRYPOINT /root/ovnkube.sh
