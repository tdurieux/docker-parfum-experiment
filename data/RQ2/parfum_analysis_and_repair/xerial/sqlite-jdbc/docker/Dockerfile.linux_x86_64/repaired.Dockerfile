FROM centos:5
MAINTAINER Taro L. Saito <leo@xerial.org>

RUN yum -y install gcc make perl && rm -rf /var/cache/yum

WORKDIR /work
