FROM fedora:21
MAINTAINER William Blankenship <wblankenship@nodesource.com>

RUN yum install -y \
      automake \
      libicu \
      curl \
      gcc \
      gcc-c++ \
      git \
      kernel-devel \
      make \
      perl \
      python \
      which \
 && yum clean all && rm -rf /var/cache/yum

