# Docker build file to create an image with centos 8
FROM centos:8
MAINTAINER Andreas Bok Andersen <bok.chan@gmail.com>

# install required packages
RUN yum install -y rpm-build zlib-devel libtool openssl make \
    openssl-devel automake autoconf gcc-c++ && rm -rf /var/cache/yum
