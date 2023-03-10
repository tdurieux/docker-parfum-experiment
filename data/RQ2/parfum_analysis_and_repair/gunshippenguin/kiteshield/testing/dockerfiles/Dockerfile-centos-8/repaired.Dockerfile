FROM centos:8

# Needed to get glibc-static
RUN yum install -y dnf-plugins-core && rm -rf /var/cache/yum
run yum config-manager -y --set-enabled powertools

RUN yum install -y gcc clang glibc-static && rm -rf /var/cache/yum

