#
# Dockerfile
#
# @author zhibiao.pan@bitmain.com, yihao.peng@bitmain.com
# @copyright btc.com
# @since 2016-08-01
#
#
FROM phusion/baseimage:0.10.2
MAINTAINER YihaoPeng <yihao.peng@bitmain.com>

ENV HOME /root
ENV TERM xterm
CMD ["/sbin/my_init"]

# use aliyun source
ADD sources-aliyun.com.list /etc/apt/sources.list

RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libboost-all-dev libzmq3-dev curl wget net-tools && rm -rf /var/lib/apt/lists/*;

# build litecoind
RUN mkdir ~/source
RUN cd ~/source && wget https://github.com/litecoin-project/litecoin/archive/v0.16.3.tar.gz
RUN cd ~/source \
  && tar zxf v0.16.3.tar.gz && cd litecoin-0.16.3 \
  && ./autogen.sh \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-wallet --disable-tests \
  && make -j4 && make install && rm v0.16.3.tar.gz

# mkdir litecoind data dir
RUN mkdir -p /root/.litecoin
RUN mkdir -p /root/scripts

# logrotate
ADD logrotate-litecoind /etc/logrotate.d/litecoind

#
# services
#
# service for mainnet
RUN mkdir    /etc/service/litecoind
ADD run      /etc/service/litecoind/run
RUN chmod +x /etc/service/litecoind/run
