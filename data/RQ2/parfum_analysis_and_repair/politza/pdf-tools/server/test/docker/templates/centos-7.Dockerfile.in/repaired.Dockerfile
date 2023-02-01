# -*- dockerfile -*-
FROM centos:7
RUN yum update -y && yum install -y gcc gcc-c++ poppler-glib-devel && rm -rf /var/cache/yum
