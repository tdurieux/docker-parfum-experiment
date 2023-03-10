FROM registry.access.redhat.com/openshift3/jenkins-slave-base-rhel7:latest

# Adapted from Red Hat Community of Practice
# https://github.com/redhat-cop/containers-quickstarts/blob/master/jenkins-slaves/jenkins-slave-ansible/Dockerfile.rhel7

LABEL name="jenkins-agent-ansible" \
      version="3.11" \
      architecture="x86_64" \
      release="1" \
      io.k8s.display-name="Widget Jenkins Agent" \
      io.openshift.tags="openshift,jenkins,ansible,oc"

ENV ANSIBLE_LOCAL_TEMP=/tmp/ansible

RUN INSTALL_PKGS="ansible" && \
    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum install -y --setopt=tsflags=nodocs \
      --disablerepo=* \
      --enablerepo=rhel-7-server-rpms --enablerepo=rhel-7-server-extras-rpms \
      --enablerepo=epel \
      $INSTALL_PKGS && \
    rpm -V ansible && \
    ansible --version && \
    yum clean all -y && \
    rm -rf /var/cache/yum
#
USER 1001