FROM centos:5
MAINTAINER James Pike version: 0.1

RUN yum install -y gcc make && rm -rf /var/cache/yum
ADD . /smell-baron
RUN cd smell-baron && make release
