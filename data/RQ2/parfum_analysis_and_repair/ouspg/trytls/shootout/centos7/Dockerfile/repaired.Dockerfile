FROM centos:centos7

ENV VERSION 0.3.4
RUN yum -y update && \
    yum -y install epel-release && \
    yum -y install python-pip && \
    yum -y install openssl && \
    yum clean all && \
    pip install --no-cache-dir trytls==${VERSION} && rm -rf /var/cache/yum

# Stubs
WORKDIR /root
RUN curl -f -Lo- https://github.com/ouspg/trytls/archive/v${VERSION}.tar.gz | \
  zcat | tar --strip-components=1 -xvf - trytls-${VERSION}/stubs

# Go
RUN yum -y install go && rm -rf /var/cache/yum
WORKDIR /root/stubs/go-nethttp
RUN go build run.go

# Java
RUN yum -y install java-sdk && rm -rf /var/cache/yum
WORKDIR /root/stubs/java-https
RUN javac Run.java
WORKDIR /root/stubs/java-net
RUN javac Run.java

# Python 2
RUN yum -y install python-requests && rm -rf /var/cache/yum

# Python 3
RUN yum -y install centos-release-scl scl-utils && rm -rf /var/cache/yum
RUN yum -y install rh-python35 && rm -rf /var/cache/yum

# PHP
RUN yum -y install php && rm -rf /var/cache/yum

# Default workdir & script for easier manual stub testing
WORKDIR /root/stubs/
COPY shootout.sh /root/stubs/
