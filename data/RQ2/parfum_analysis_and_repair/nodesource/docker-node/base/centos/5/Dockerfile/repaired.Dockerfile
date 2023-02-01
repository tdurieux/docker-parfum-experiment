FROM centos:5
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
      which \
 && yum clean all && rm -rf /var/cache/yum

RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm \
 && yum install -y python26 git \
 && yum clean all && rm -rf /var/cache/yum

ENV PYTHON python2.6

