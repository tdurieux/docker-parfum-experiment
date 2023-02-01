#upstream https://github.com/woqutech/docker-images
FROM centos:centos7
MAINTAINER Lex Guo <lex.guo@woqutech.com>
RUN curl -f -s https://packagecloud.io/install/repositories/akopytov/sysbench/script.rpm.sh | bash
RUN yum -y install sysbench && rm -rf /var/cache/yum
