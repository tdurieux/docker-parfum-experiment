#
# This is the OpenShift ovn overlay network image.
# it provides an overlay network using ovs/ovn/ovn-kube
#
# The standard name for this image is ovn-kube

# Notes:
# This is for a development build where the ovn-kubernetes utilities
# are built locally and included in the image (instead of the rpm)
#
# At present this uses fedora:28
# which has the needed ovs/ovn rpms at 2.8 or higher
#
# So this file will change over time.

FROM fedora:29

USER root

ENV PYTHONDONTWRITEBYTECODE yes

RUN dnf install --refresh -y  \
	PyYAML bind-utils procps-ng hostname \
	openvswitch openvswitch-ovn-common openvswitch-ovn-host openvswitch-ovn-central \
	python2-openvswitch openvswitch-ovn-vtep \
	kubernetes-client \
	containernetworking-cni \
	jq iproute strace socat && \
	dnf clean all

RUN mkdir -p /var/run/openvswitch
RUN mkdir -p /etc/cni/net.d
RUN mkdir -p /opt/cni/bin

# Built in ../../go_controller, then the binaries are copied here.
# put things where they are in the rpm
RUN mkdir -p /usr/libexec/cni/
COPY ovnkube ovn-kube-util /usr/bin/
COPY ovn-k8s-cni-overlay /usr/libexec/cni/ovn-k8s-cni-overlay

# ovnkube.sh is the entry point. This script examines environment
# variables to direct operation and configure ovn
COPY ovnkube.sh /root/
COPY ovn-debug.sh /root/
# override the rpm's ovn_k8s.conf with this local copy
COPY ovn_k8s.conf /etc/openvswitch/ovn_k8s.conf

# copy git commit number into image
RUN mkdir -p /root/.git/ /root/.git/refs/heads/
COPY .git/HEAD /root/.git/HEAD
COPY .git/refs/heads/ /root/.git/refs/heads/


LABEL io.k8s.display-name="ovn kubernetes" \
      io.k8s.description="This is a component of OpenShift Container Platform that provides an overlay network using ovn." \
      io.openshift.tags="openshift" \
      maintainer="Phil Cameron <pcameron@redhat.com>"

WORKDIR /root
ENTRYPOINT /root/ovnkube.sh
