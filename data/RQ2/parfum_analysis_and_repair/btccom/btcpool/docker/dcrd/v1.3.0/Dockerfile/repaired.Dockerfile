#
# Dockerfile
#
# @author hanjiang.yu@bitmain.com
# @copyright btc.com
# @since 2018-09-10
#
#
FROM phusion/baseimage:0.10.2
LABEL maintainer="Hanjiang Yu <hanjiang.yu@bitmain.com>"

ENV HOME /root
ENV TERM xterm
CMD ["/sbin/my_init"]

# use aliyun source
#ADD sources-aliyun.com.list /etc/apt/sources.list

RUN apt-get update && apt-get install --no-install-recommends -y net-tools wget && rm -rf /var/lib/apt/lists/*;

# download dcrd
RUN mkdir ~/source
RUN cd ~/source && wget https://github.com/decred/decred-binaries/releases/download/v1.3.0/decred-linux-amd64-v1.3.0.tar.gz
RUN cd ~/source && [ $(sha256sum decred-linux-amd64-v1.3.0.tar.gz | cut -d " " -f 1) = "5002a68d4ddffe775b1f05d454c739ffac6b8e7ea8c3b044b38f0d7594bf294e" ] && \
  tar zxvf decred-linux-amd64-v1.3.0.tar.gz && \
  cp decred-linux-amd64-v1.3.0/dcr* /usr/local/bin && rm decred-linux-amd64-v1.3.0.tar.gz

# mkdir dcrd data dir
RUN mkdir -p /root/.dcrd

#
# services
#

# service for dcrd
RUN mkdir    /etc/service/dcrd
ADD run      /etc/service/dcrd/run
RUN chmod +x /etc/service/dcrd/run

# remove source & build files
RUN rm -rf ~/source

# clean
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
