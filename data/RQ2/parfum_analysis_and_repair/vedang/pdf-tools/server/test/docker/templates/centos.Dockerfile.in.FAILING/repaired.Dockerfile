# -*- dockerfile -*-
FROM centos:centos7
RUN sed -i -e "s|mirrorlist=|#mirrorlist=|g" /etc/yum.repos.d/CentOS-*
RUN sed -i -e "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*
RUN yum update -y
# @TODO: Since CentOS is no more, do I even want to try and fix this?