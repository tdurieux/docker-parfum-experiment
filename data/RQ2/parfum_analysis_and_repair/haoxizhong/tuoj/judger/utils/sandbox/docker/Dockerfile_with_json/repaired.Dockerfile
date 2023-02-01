FROM ubuntu

MAINTAINER mhy12345 <maohanyang789@163.com>

RUN apt-get update

RUN apt-get install --no-install-recommends -y git && \
 apt-get install --no-install-recommends -y vim && \
 apt-get install --no-install-recommends -y g++ && \
 apt-get install --no-install-recommends -y gdb && \
 apt-get install --no-install-recommends -y python && \
 apt-get install --no-install-recommends -y fpc && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /home/judger && \
mkdir -p /root/.ssh && \
mkdir -p /home/build && \
mkdir -p /home/judger/bin/json

ADD .vimrc /root/.vimrc
ADD id_rsa /root/.ssh/id_rsa
ADD id_rsa.pub /root/.ssh/id_rsa.pub

ADD jsoncpp /home/build/jsoncpp
WORKDIR /home/build/jsoncpp
RUN chmod +x /home/build/jsoncpp/install.sh && \
/home/build/jsoncpp/install.sh

ADD bin /home/judger/bin

WORKDIR /home/judger
