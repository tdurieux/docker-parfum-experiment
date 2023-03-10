FROM ubuntu:18.04

MAINTAINER goldeneggg

RUN mkdir -p /tmp/prv-bash/ubuntu18
WORKDIR /tmp/prv-bash

ADD entry.sh entry.sh
ADD ubuntu18/prepare.sh ubuntu18/prepare.sh
ADD ubuntu18/envs ubuntu18/envs
ADD ubuntu18/files ubuntu18/files

ADD ubuntu18/init.sh ubuntu18/init.sh
RUN bash entry.sh --local ubuntu18 init.sh

# other script
#ADD ubuntu18/init.sh /tmp/prv-bash/ubuntu18/xxx.sh
#RUN bash entry.sh --local ubuntu18 xxx.sh