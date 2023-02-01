FROM centos:7
MAINTAINER Percona Development <info@percona.com>

RUN rpmkeys --import https://www.percona.com/downloads/RPM-GPG-KEY-percona
RUN yum install -y https://www.percona.com/redir/downloads/percona-release/redhat/0.1-4/percona-release-0.1-4.noarch.rpm && rm -rf /var/cache/yum
RUN yum install -y pmm-client procps initscripts && yum clean all && rm -rf /var/cache/yum

ONBUILD RUN yum update -y
