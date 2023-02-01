ARG BASE_IMAGE=centos:7

FROM ${BASE_IMAGE}

RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum install -y rpmrebuild && rm -rf /var/cache/yum
