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
mkdir -p /root/.ssh  && \
mkdir -p /home/judger/tmp && \
mkdir -p /home/judger/run

ADD .vimrc /root/.vimrc

ADD bin /home/judger/bin

RUN apt-get install --no-install-recommends -y make && rm -rf /var/lib/apt/lists/*;
WORKDIR /home/judger/bin
RUN make

WORKDIR /home/judger
