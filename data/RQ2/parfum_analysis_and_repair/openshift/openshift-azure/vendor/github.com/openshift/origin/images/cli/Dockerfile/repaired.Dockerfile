#
# This is the official OpenShift CLI image. It can be used to get a CLI environment
# for OpenShift.
#
# The standard name for this image is openshift/origin-cli
#
FROM openshift/origin-base

RUN INSTALL_PKGS="origin-clients" && \
    yum --enablerepo=origin-local-release install -y ${INSTALL_PKGS} && \
    rpm -V ${INSTALL_PKGS} && \
    yum clean all && rm -rf /var/cache/yum

LABEL io.k8s.display-name="OpenShift Client" \
      io.k8s.description="OpenShift is a platform for developing, building, and deploying containerized applications." \
      io.openshift.tags="openshift,cli"
