#
# Dockerfile for building Mesos
#

FROM ubuntu

MAINTAINER Klaus Ma <klaus1982.cn@gmail.com>
MAINTAINER Yong Feng <yongfeng@ca.ibm.com>

RUN apt-get update && apt-get install --no-install-recommends -y libapr1 libcurl3-nss libgflags2 libsasl2-2 libsvn1 libcurl3 libsasl2-modules openjdk-7-jre-headless apparmor && rm -rf /var/lib/apt/lists/*;

COPY ./mesos.deb /opt/mesos/
RUN dpkg -i /opt/mesos/mesos.deb && rm -rf /opt/mesos

ENV MESOS_HOME /opt/ibm/mesos

ENV PATH=$PATH:$MESOS_HOME/sbin:$MESOS_HOME/bin
RUN mkdir -p /var/lib/mesos

# include libmesos on library path
ENV LD_LIBRARY_PATH $MESOS_HOME/lib

