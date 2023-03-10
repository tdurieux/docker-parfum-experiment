FROM centos:6

MAINTAINER goldeneggg

RUN mkdir -p /tmp/prv-bash/centos6
WORKDIR /tmp/prv-bash

ADD entry.sh entry.sh
ADD centos6/prepare.sh centos6/prepare.sh
ADD centos6/envs centos6/envs
ADD centos6/files centos6/files

ADD centos6/init.sh centos6/init.sh
RUN bash entry.sh --local centos6 init.sh

# other script
#ADD centos6/init.sh /tmp/prv-bash/centos6/xxx.sh
#RUN bash entry.sh --local centos6 xxx.sh