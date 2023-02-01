FROM rockylinux:8
LABEL maintainer="Manuel Giffels <giffels@gmail.com>"

RUN yum -y install epel-release curl && yum clean all && rm -rf /var/cache/yum

RUN curl -f -sL https://rpm.nodesource.com/setup_18.x | bash -

RUN yum -y update \
    && yum -y install git \
                      python38 \
                      gcc \
                      python38-devel \
                      nodejs \
                      glibc-langpack-en \
    && yum clean all && rm -rf /var/cache/yum

SHELL [ "/bin/bash", "--noprofile", "--norc", "-e", "-o", "pipefail", "-c" ]
