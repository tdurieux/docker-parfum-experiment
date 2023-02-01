FROM centos:7

RUN yum install -y git gcc && rm -rf /var/cache/yum

ENV PATH=$PATH:/rust/bin
