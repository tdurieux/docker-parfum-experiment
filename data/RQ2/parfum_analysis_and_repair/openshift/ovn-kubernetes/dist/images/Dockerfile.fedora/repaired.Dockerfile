#
# This is the OpenShift ovn overlay network image.
# it provides an overlay network using ovs/ovn/ovn-kube
#
# The standard name for this image is ovn-kube

# Notes:
# This is for a development build where the ovn-kubernetes utilities
# are built locally and included in the image (instead of the rpm)
#

FROM fedora:35

USER root

ENV PYTHONDONTWRITEBYTECODE yes

ARG ovnver=ovn-22.03.0-1.fc35
# Automatically populated when using docker buildx
ARG TARGETPLATFORM
ARG BUILDPLATFORM

RUN echo "Running on $BUILDPLATFORM, building for $TARGETPLATFORM"

# install needed rpms - openvswitch must be 2.10.4 or higher
RUN INSTALL_PKGS=" \
	python3-pyyaml bind-utils procps-ng openssl numactl-libs firewalld-filesystem \
	libpcap hostname kubernetes-client \
        ovn ovn-central ovn-host python3-openvswitch tcpdump openvswitch-test python3-pyOpenSSL \
	iptables iproute iputils strace socat koji \
        " && \
	dnf install --best --refresh -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
	dnf clean all && rm -rf /var/cache/dnf/*

RUN mkdir -p /var/run/openvswitch

RUN if [ "$TARGETPLATFORM" = "linux/amd64" ] || [ -z "$TARGETPLATFORM"] ; then koji download-build $ovnver --arch=x86_64  ; \
    else koji download-build $ovnver --arch=aarch64 ; fi 

RUN rpm -Uhv --nodeps --force *.rpm

# Built in ../../go_controller, then the binaries are copied here.
# put things where they are in the pkg
RUN mkdir -p /usr/libexec/cni/
COPY ovnkube ovn-kube-util ovndbchecker /usr/bin/
COPY ovn-k8s-cni-overlay /usr/libexec/cni/ovn-k8s-cni-overlay

# ovnkube.sh is the entry point. This script examines environment
# variables to direct operation and configure ovn
COPY ovnkube.sh /root/
COPY ovndb-raft-functions.sh /root/

# copy git commit number into image
COPY git_info /root

# iptables wrappers