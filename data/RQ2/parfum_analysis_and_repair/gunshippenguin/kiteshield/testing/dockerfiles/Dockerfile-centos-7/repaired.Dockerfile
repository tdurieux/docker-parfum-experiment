FROM centos:7

RUN yum install -y gcc clang glibc-static && rm -rf /var/cache/yum

