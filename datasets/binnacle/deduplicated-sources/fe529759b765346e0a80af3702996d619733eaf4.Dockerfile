FROM oraclelinux:7
MAINTAINER publicisworldwide heichblatt

RUN yum clean all && \
    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum clean all
RUN yum install -y java-1.8.0-openjdk-headless \
      git \
      wget \
      pv \
      yum-plugin-ovl && \
    yum group install -y "Development Tools" && \
    yum clean all
RUN ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
RUN mkdir -pv /jenkins
