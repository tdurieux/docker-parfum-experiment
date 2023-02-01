FROM centos:7

MAINTAINER Nathan Zimmerman, npzimmerman@gmail.com

RUN yum install -y wget curl unzip which nc bzip2

ARG TAG
ARG GEOMESA_VERSION
ARG ACCUMULO_VERSION
ARG THRIFT_VERSION

# JAVA
ENV JAVA_VERSION_MAJOR=8 \
    JAVA_VERSION_MINOR=131 \
    JAVA_VERSION_BUILD=11 \
    JAVA_URL_HASH=d54c1d3a095b4ff2b6607d096fa80163

ENV JAVA_HOME /usr/java/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR}
ENV PATH $PATH:$JAVA_HOME/bin

RUN set -x \
  && curl -sS -LO -H 'Cookie: oraclelicense=accept-securebackup-cookie' "http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_URL_HASH}/jdk-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.rpm" \
  && rpm -Uvh jdk-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.rpm \
  && rm -rf jdk-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.rpm \
  && curl -sS http://www.apache.org/dist/bigtop/stable/repos/centos7/bigtop.repo > /etc/yum.repos.d/bigtop.repo
