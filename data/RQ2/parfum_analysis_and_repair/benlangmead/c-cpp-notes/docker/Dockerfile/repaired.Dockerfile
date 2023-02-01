# Author: Ben Langmead
#   Date: 1/21/2018

FROM fedora:27

RUN yum install -y valgrind && rm -rf /var/cache/yum
RUN yum install -y gdb && rm -rf /var/cache/yum
RUN yum install -y gcc && rm -rf /var/cache/yum
RUN yum install -y gcc-c++ && rm -rf /var/cache/yum
RUN yum install -y emacs-nox && rm -rf /var/cache/yum
RUN yum install -y git && rm -rf /var/cache/yum

RUN dnf -y debuginfo-install glibc-2.26-15.fc27.x86_64