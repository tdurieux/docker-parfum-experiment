#
# This is the base image from which all OpenShift Origin images inherit. Only packages
# common to all downstream images should be here. Depends on Centos 7.2+
#
# The standard name for this image is openshift/origin-base
#
FROM centos:centos7

RUN INSTALL_PKGS="which git tar wget hostname sysvinit-tools util-linux bsdtar centos-release-openshift-origin \
      socat ethtool device-mapper iptables tree findutils nmap-ncat e2fsprogs xfsprogs lsof device-mapper-persistent-data ceph-common" && \
    yum install -y $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all && \
    mkdir -p /var/lib/origin && rm -rf /var/cache/yum

LABEL io.k8s.display-name="OpenShift Origin Centos 7 Base" \
      io.k8s.description="This is the base image from which all OpenShift Origin images inherit."
