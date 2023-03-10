#
# Dockerfile for building Mesos from source
#
# Create snapshot builds with:
# docker build -t mesos/mesos:git-`git rev-parse --short HEAD` .
#
# Run master/slave with:
# docker run mesos/mesos:git-`git rev-parse --short HEAD` mesos-master [options]
# docker run mesos/mesos:git-`git rev-parse --short HEAD` mesos-slave [options]
#

FROM ubuntu:14.04

MAINTAINER Klaus Ma <klaus1982.cn@gmail.com>
MAINTAINER Yong Feng <yongfeng@ca.ibm.com>

RUN apt-get update && apt-get install --no-install-recommends -y libapr1 libcurl3-nss libgflags2 libsasl2-2 libsvn1 libcurl3 libsasl2-modules && rm -rf /var/lib/apt/lists/*;

COPY ./mesos/lib/*.so /usr/lib/

