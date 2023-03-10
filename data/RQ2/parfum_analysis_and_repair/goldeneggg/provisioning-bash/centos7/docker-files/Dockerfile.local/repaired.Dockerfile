FROM centos:7

MAINTAINER goldeneggg

RUN mkdir -p /tmp/prv-bash/centos7
WORKDIR /tmp/prv-bash

ADD entry.sh entry.sh
ADD centos7/prepare.sh centos7/prepare.sh
ADD centos7/envs centos7/envs
ADD centos7/files centos7/files

ADD centos7/init.sh centos7/init.sh
RUN bash entry.sh --local centos7 init.sh

# other script
#ADD centos7/init.sh /tmp/prv-bash/centos7/xxx.sh
#RUN bash entry.sh --local centos7 xxx.sh