#
# This is the rhel7 base image from which all rhel7 based Atomic OpenShift images
# inherit. Only packages common to all downstream images should be here.
#
# The standard name for this image is openshift/ose-base
#
FROM rhel7

RUN INSTALL_PKGS=" \
      which tar wget hostname sysvinit-tools util-linux \
      socat tree findutils lsof bind-utils \
      " && \
    yum --disablerepo=origin-local-release install -y $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all && \
    mkdir -p /var/lib/origin && rm -rf /var/cache/yum

LABEL io.k8s.display-name="Atomic OpenShift RHEL 7 Base" \
      io.k8s.description="This is the base image from which all Atomic OpenShift images inherit."
