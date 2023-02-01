FROM centos:7
MAINTAINER Henry Lawson "henry.lawson@foinq.com"

ENV REFRESHED_AT 2016-01-24
RUN yum install -y sudo && rm -rf /var/cache/yum
RUN yum install -y wget && rm -rf /var/cache/yum
RUN yum install -y glibc.i686 zlib.i686 libstdc++.i686 ncurses-libs.i686 libgcc.i686 && rm -rf /var/cache/yum
