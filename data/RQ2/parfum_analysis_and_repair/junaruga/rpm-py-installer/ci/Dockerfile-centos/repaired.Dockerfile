ARG CONTAINER_IMAGE=centos:8
FROM ${CONTAINER_IMAGE}

WORKDIR /build
COPY tox-requirements.txt .

RUN yum -y update
RUN yum -y install epel-release && rm -rf /var/cache/yum
RUN yum -y install \
  --setopt=deltarpm=0 \
  --setopt=install_weak_deps=false \
  --setopt=tsflags=nodocs \
  # -- RPM packages required for installing --
  rpm-libs \
  redhat-rpm-config \
  gcc \
  python3-devel \
  python36-devel \
  python2-devel \
  /usr/bin/python3.6 \
  /usr/bin/python2.7 \
  # -- RPM packages required for a specified case --
  /usr/bin/git \
  rpm-build-libs \
  /usr/bin/yumdownloader \
  /usr/bin/cpio --setopt=install_weak_deps=false \
  --setopt=tsflags=nodocs \
  # -- RPM packages required for installing --
  rpm-libs \
  redhat-rpm-config \
  gcc \
  python3-devel \
  python36-devel \
  python2-devel \
  /usr/bin/python3.6 \
  /usr/bin/python2.7 \
  # -- RPM packages required for a specified case --
  /usr/bin/git \
  rpm-build-libs \
  /usr/bin/yumdownloader \
  /usr/bin/cpio --setopt=tsflags=nodocs \
  # -- RPM packages required for installing --
  rpm-libs \
  redhat-rpm-config \
  gcc \
  python3-devel \
  python36-devel \
  python2-devel \
  /usr/bin/python3.6 \
  /usr/bin/python2.7 \
  # -- RPM packages required for a specified case --
  /usr/bin/git \
  rpm-build-libs \
  /usr/bin/yumdownloader \
  /usr/bin/cpio && rm -rf /var/cache/yum
# Install on CentOS 7, but not CentOS 8.
RUN yum -y install \
  python34-devel \
  /usr/bin/python3.4 \
  || true && rm -rf /var/cache/yum
RUN yum clean all
RUN python3 -m ensurepip
RUN python3 -m pip install --upgrade -rtox-requirements.txt
