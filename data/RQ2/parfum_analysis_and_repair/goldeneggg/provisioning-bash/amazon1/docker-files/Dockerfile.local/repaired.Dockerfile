FROM amazonlinux:1

MAINTAINER goldeneggg

RUN mkdir -p /tmp/prv-bash/amazon1
WORKDIR /tmp/prv-bash

ADD entry.sh entry.sh
ADD amazon1/prepare.sh amazon1/prepare.sh
ADD amazon1/envs amazon1/envs
ADD amazon1/files amazon1/files

ADD amazon1/init.sh amazon1/init.sh
RUN bash entry.sh --local amazon1 init.sh

# other script
#ADD amazon1/init.sh /tmp/prv-bash/amazon1/xxx.sh
#RUN bash entry.sh --local amazon1 xxx.sh