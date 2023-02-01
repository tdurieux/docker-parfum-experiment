FROM fedora:latest

RUN yum install -y codespell && yum clean all -y && rm -rf /var/cache/yum
