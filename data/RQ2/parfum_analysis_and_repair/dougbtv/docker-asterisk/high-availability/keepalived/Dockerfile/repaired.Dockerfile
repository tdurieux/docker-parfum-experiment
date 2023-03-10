FROM centos:centos7
MAINTAINER Doug Smith <info@laboratoryb.org>
ENV build_date 2014-12-12

# /usr/sbin/keepalived -f /etc/keepalived/keepalived.conf --dont-fork --log-console

RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum install -y keepalived && rm -rf /var/cache/yum