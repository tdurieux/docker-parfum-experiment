#
# This is the base image for nodes of an openshift dind dev cluster.
#
# The standard name for this image is openshift/dind-node
#

FROM openshift/dind

## Install packages
RUN dnf -y update && dnf -y install\
 bind-utils\
 findutils\
 hostname\
 iproute\
 iputils\
 less\
 procps-ng\
 tar\
 which\
 # Node-specific packages
 bridge-utils\
 ethtool\
 iptables-services\
 openvswitch\
 && dnf clean all

# A default deny firewall (either iptables or firewalld) is
# installed by default on non-cloud fedora and rhel, so all
# network plugins need to be able to work with one enabled.
RUN systemctl enable iptables.service

# Ensure that master-to-kubelet communication will work with iptables
COPY iptables /etc/sysconfig/

COPY openshift-generate-node-config.sh /usr/local/bin/
COPY openshift-dind-lib.sh /usr/local/bin/

RUN systemctl enable openvswitch

COPY openshift-node.service /etc/systemd/system/
RUN systemctl enable openshift-node.service
# Ensure the working directory for the unit file exists
RUN mkdir -p /var/lib/origin

COPY openshift-enable-ssh-access.sh /usr/local/bin/
COPY openshift-enable-ssh-access.service /etc/systemd/system/
RUN systemctl enable openshift-enable-ssh-access.service

# SDN plugin setup
RUN mkdir -p /etc/cni/net.d
RUN mkdir -p /opt/cni/bin

# Symlink from the data path intended to be mounted as a volume to
# make reloading easy.  Revisit if/when dind becomes useful for more
# than dev/test.