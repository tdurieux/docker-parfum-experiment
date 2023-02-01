#
# Dockerfile
#
# @author zhibiao.pan@bitmain.com, yihao.peng@bitmain.com
# @copyright btc.com
# @since 2016-08-01
#
#
FROM phusion/baseimage:0.9.22
MAINTAINER PanZhibiao <zhibiao.pan@bitmain.com>

ENV HOME /root
ENV TERM xterm
CMD ["/sbin/my_init"]

# use aliyun source
# ADD sources-aliyun.com.list /etc/apt/sources.list

RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libboost-all-dev libzmq3-dev curl wget net-tools && rm -rf /var/lib/apt/lists/*;

# install libdb for wallet
RUN apt-get install --no-install-recommends -y software-properties-common \
  && add-apt-repository -y ppa:bitcoin/bitcoin \
  && apt-get -y update \
  && apt-get install --no-install-recommends -y libdb4.8-dev libdb4.8++-dev && rm -rf /var/lib/apt/lists/*;

# build bitcoind
RUN mkdir ~/source
RUN cd ~/source && wget https://github.com/UnitedBitcoin/UnitedBitcoin/archive/v2.4.0.1.tar.gz
RUN cd ~/source \
  && tar zxf v2.4.0.1.tar.gz && cd UnitedBitcoin-2.4.0.1 \
  && ./autogen.sh \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-bench --disable-tests \
  && make && make install && rm v2.4.0.1.tar.gz

# make some alias
RUN ln -s ubcd /usr/local/bin/bitcoind \
  && ln -s ubc-cli /usr/local/bin/bitcoin-cli \
  && ln -s ubc-tx /usr/local/bin/bitcoin-tx \
  && ln -s /root/.bitcoin /root/.unitedbitcoin

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
# service for testnet3
#RUN mkdir        /etc/service/bitcoind_testnet3
#ADD run_testnet3 /etc/service/bitcoind_testnet3/run
#RUN chmod +x     /etc/service/bitcoind_testnet3/run
