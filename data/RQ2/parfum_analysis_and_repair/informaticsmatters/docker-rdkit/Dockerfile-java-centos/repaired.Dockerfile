# Dockerfile for Java based RDKit implementation
# Based on Cento8

FROM centos:8
LABEL maintainer="Tim Dudgeon<tdudgeon@informaticsmatters.com>"

RUN yum update -y &&\
  sed -i 's/enabled=0/enabled=1/' /etc/yum.repos.d/CentOS-Linux-PowerTools.repo &&\
  yum install -y --setopt=tsflags=nodocs --setopt=override_install_langs=en_US.utf8\
  java-11-openjdk-headless\
  boost-system\
  boost-thread\
  boost-serialization\
  boost-regex\
  boost-chrono\
  boost-date-time\
  boost-atomic\
  boost-iostreams\
  procps-ng\
  freetype &&\
  yum clean all &&\
  rm -rf /var/cache/yum

ARG DOCKER_TAG=latest

COPY artifacts/centos/$DOCKER_TAG/java/* /rdkit/gmwrapper/
COPY artifacts/centos/$DOCKER_TAG/rpms/RDKit-*-Linux-Runtime.rpm /tmp/
RUN rpm --nodeps -iv /tmp/*.rpm && rm -f /tmp/*.rpm

WORKDIR / 

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/rdkit/gmwrapper
ENV CLASSPATH=/rdkit/gmwrapper/org.RDKit.jar
ENV RDBASE=/usr/share/RDKit

# add the rdkit user