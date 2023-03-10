FROM ubuntu:14.04

MAINTAINER goldeneggg

RUN mkdir -p /tmp/prv-bash/ubuntu14
WORKDIR /tmp/prv-bash

ADD entry.sh entry.sh
ADD ubuntu14/prepare.sh ubuntu14/prepare.sh
ADD ubuntu14/envs ubuntu14/envs
ADD ubuntu14/files ubuntu14/files

ADD ubuntu14/init.sh ubuntu14/init.sh
RUN bash entry.sh --local ubuntu14 init.sh

# other script
#ADD ubuntu14/init.sh /tmp/prv-bash/ubuntu14/xxx.sh
#RUN bash entry.sh --local ubuntu14 xxx.sh