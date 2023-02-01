#
# Dockerfile
#
# @author zhibiao.pan@bitmain.com, yihao.peng@bitmain.com
# @copyright btc.com
# @since 2016-08-01
#
#
FROM phusion/baseimage:0.9.22
MAINTAINER YihaoPeng <yihao.peng@bitmain.com>

ENV HOME /root
ENV TERM xterm
CMD ["/sbin/my_init"]

# use aliyun source
ADD sources-aliyun.com.list /etc/apt/sources.list

RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils yasm && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libboost-all-dev libzmq3-dev curl wget unzip git && rm -rf /var/lib/apt/lists/*;

# build bitcoind
RUN mkdir ~/source
RUN cd ~/source && git clone -b lightgbt-v0.18.4-reorgsafe --depth 1 https://github.com/btccom/bitcoin-abc-1.git
RUN cd ~/source \
  && cd bitcoin-abc-1 \
  && ./autogen.sh \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-wallet --disable-tests \
  #&& make && make install
  && make -j$(nproc) && make install

# mkdir bitcoind data dir
RUN mkdir -p /root/.bitcoin

# logrotate
ADD logrotate-bitcoind /etc/logrotate.d/bitcoind

#
# services
#

# service for mainnet
RUN mkdir    /etc/service/bitcoind
ADD run      /etc/service/bitcoind/run
RUN chmod +x /etc/service/bitcoind/run

#service for testnet
#RUN mkdir        /etc/service/bitcoind_testnet
#ADD run_testnet /etc/service/bitcoind_testnet/run
#RUN chmod +x     /etc/service/bitcoind_testnet/run
