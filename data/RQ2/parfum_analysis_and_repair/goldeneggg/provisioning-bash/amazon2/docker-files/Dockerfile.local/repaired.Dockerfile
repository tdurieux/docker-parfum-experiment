FROM amazonlinux:2

MAINTAINER goldeneggg

RUN mkdir -p /tmp/prv-bash/amazon2
WORKDIR /tmp/prv-bash

ADD entry.sh entry.sh
ADD amazon2/prepare.sh amazon2/prepare.sh
ADD amazon2/envs amazon2/envs
ADD amazon2/files amazon2/files

ADD amazon2/init.sh amazon2/init.sh
RUN bash entry.sh --local amazon2 init.sh

# other script
#ADD amazon2/init.sh /tmp/prv-bash/amazon2/xxx.sh
#RUN bash entry.sh --local amazon2 xxx.sh